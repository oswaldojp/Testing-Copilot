# Generador de proyecto Minimal API

Este proyecto contiene un script Bash que automatiza la creación de una solución
base de .NET para una Minimal API. La solución incluye un proyecto de API, un
proyecto de pruebas con xUnit, las dependencias de pruebas configuradas por el
script y un `Dockerfile` para publicar y ejecutar la API en un contenedor.

## Requisitos

- Bash.
- .NET SDK 10.
- Acceso a Internet para restaurar los paquetes NuGet que agrega el generador.
- Docker, solo si se desea construir y ejecutar la imagen del proyecto generado.

## Uso

Desde esta carpeta, ejecuta el generador con el nombre que quieras usar para la
API:

```bash
bash generador.sh MiProyecto
```

El nombre debe ser adecuado para un proyecto de .NET. El generador usa ese valor
para nombrar la API, la solución y el archivo DLL de inicio. El proyecto de
pruebas se nombra `<nombre>.Tests`.

Si no se proporciona un nombre, se usa `MinimalAPI`:

```bash
bash generador.sh
```

El script crea los archivos en el directorio actual desde el que se ejecuta.
Conviene ejecutarlo en una carpeta vacía para evitar conflictos con archivos o
directorios existentes.

## Estructura generada

Al ejecutar `bash generador.sh MiProyecto`, se obtiene una estructura similar a
esta:

```text
.
├── Dockerfile
├── MiProyecto.slnx
├── MiProyecto/
│   └── MiProyecto.csproj
└── MiProyecto.Tests/
    └── MiProyecto.Tests.csproj
```

Los proyectos y sus archivos adicionales los crea la plantilla de .NET
correspondiente. La solución agrega ambos proyectos. El proyecto de pruebas
recibe los paquetes `Microsoft.AspNetCore.Mvc.Testing` y `MiniValidation`.

## Docker

El `Dockerfile` generado compila y publica la API en una etapa con el SDK de
.NET 10 y copia el resultado a una imagen de ejecución de ASP.NET Core 10. Desde
la carpeta donde se generó, se puede construir la imagen y ejecutarla así:

```bash
docker build -t miproject .
docker run --rm -p 8080:80 miproject
```

El puerto `8080` del equipo se redirige al puerto `80` del contenedor.

## Alcance del generador

El script crea el esqueleto de los proyectos y configura la solución, los
paquetes indicados y el `Dockerfile`. No implementa endpoints propios ni casos
de prueba; esos se agregan después dentro de los proyectos generados.
