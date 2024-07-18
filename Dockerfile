#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
ENV SimpleProperty="hello-from-BASE-dockerfile"

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["MTTest.API/MTTest.API.csproj", "MTTest.API/"]
RUN dotnet restore "MTTest.API/MTTest.API.csproj"
COPY . .
WORKDIR "/src/MTTest.API"
RUN dotnet build "MTTest.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MTTest.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV SimpleProperty="hello-from-FINAL-dockerfile"
ENTRYPOINT ["dotnet", "MTTest.API.dll"]
