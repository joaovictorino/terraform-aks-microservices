FROM maven:3.6-jdk-11-slim as BUILD
COPY src/. /visits/src
COPY pom.xml /visits/pom.xml
WORKDIR /visits
RUN mvn package -DskipTests

FROM openjdk:11.0-jre
EXPOSE 8082
COPY --from=BUILD /visits/target/visits-0.0.1-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=mysql","-jar","/app.jar", "--server.port=8082"]