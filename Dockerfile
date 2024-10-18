FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5010

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Development
WORKDIR /src

COPY ["Booking.Api/Booking.Api.csproj", "Booking.Api/"]
COPY ["Booking.Application/Booking.Application.csproj", "Booking.Application/"]
COPY ["Booking.Domain/Booking.Domain.csproj", "Booking.Domain/"]
COPY ["Booking.Persistence/Booking.Persistence.csproj", "Booking.Persistence/"]

RUN dotnet restore "Booking.Api/Booking.Api.csproj"

COPY . .
WORKDIR "/src/Booking.Api"
RUN dotnet build "Booking.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Development
RUN dotnet publish "Booking.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Booking.Api.dll"]