#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="${1:-MinimalAPI}"
TEST_PROJECT_NAME="${PROJECT_NAME}.Tests"

# Crea un proyecto de minimal api de .net
echo "CREANDO PROYECTO DE MINIMAL API DE .NET"
dotnet new webapi -n "$PROJECT_NAME"

# Crea un proyecto de pruebas [ara el proyecto minimal de .net
echo "CREANDO PROYECTO DE PRUEBAS PARA MINIMAL API DE .NET"
dotnet new xunit -n "$TEST_PROJECT_NAME"

# Crea un archivo de solución
echo "CREANDO ARCHIVO DE SOLUCIÓN"
dotnet new sln -n "$PROJECT_NAME"

# Agrega ambos proyectos a la solución
echo "AGREGANDO PROYECTOS A LA SOLUCIÓN"
dotnet sln "$PROJECT_NAME.slnx" add \
    "$PROJECT_NAME/$PROJECT_NAME.csproj" \
    "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj"

# Agrega los paquetes necesarios para el proyecto test minimal api de .net
echo "AGREGANDO PAQUETES NECESARIOS PARA EL PROYECTO DE PRUEBAS"
dotnet add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj" package Microsoft.AspNetCore.Mvc.Testing
dotnet add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj" package MiniValidation

# Agrega un arhivp de Docker en el proyecto de minimal api de .net
echo "AGREGANDO ARCHIVO DE DOCKER"
cat <<EOL > Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY . ./
RUN dotnet publish "$PROJECT_NAME/$PROJECT_NAME.csproj" -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

EXPOSE 80
ENTRYPOINT ["dotnet", "$PROJECT_NAME.dll"]
EOL

echo "PROYECTO DE MINIMAL API DE .NET '$PROJECT_NAME' CREADO CON ÉXITO"