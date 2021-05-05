FROM maven:3.6-jdk-11-slim as BUILD
COPY src/. /vets/src
COPY pom.xml /vets/pom.xml
WORKDIR /vets
RUN mvn package -DskipTests

FROM openjdk:11.0-jre
EXPOSE 8083
COPY --from=BUILD /vets/target/vets-0.0.1-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=mysql","-jar","/app.jar", "--server.port=8083"]