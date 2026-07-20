# Imagenes base fijadas por digest sha256 (Bloque B.1 - Reproducibilidad).
# Digests verificados en Docker Hub el 20/07/2026.
#
# Se usa una imagen con Maven YA instalado (en vez de descargarlo con
# mvnw durante el build) para que la construcción no dependa de la
# disponibilidad de repo.maven.apache.org en el momento de construir,
# haciendo el build mas determinista y reproducible.
FROM maven@sha256:d88e5b38297858f65f97bc7e7964c760ab988fd18ace41589176f1468c49a489 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests

FROM eclipse-temurin@sha256:3f08b13888f595cc49edabea7250ba69499ba25602b267da591720769400e08c
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
