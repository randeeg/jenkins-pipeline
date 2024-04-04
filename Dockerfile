FROM openjdk:21-jdk

WORKDIR /app

COPY target/springdemo-1.0.0.jar /app/springdemo.jar

EXPOSE 8081

CMD ["java", "-jar", "springdemo.jar"]
