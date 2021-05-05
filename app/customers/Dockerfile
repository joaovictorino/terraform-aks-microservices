FROM maven:3.6-jdk-11-slim as BUILD
COPY src/. /customers/src
COPY pom.xml /customers/pom.xml
WORKDIR /customers
RUN mvn package -DskipTests

FROM openjdk:11.0-jre
EXPOSE 8081
COPY --from=BUILD /customers/target/customers-0.0.1-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=mysql","-jar","/app.jar", "--server.port=8081"]