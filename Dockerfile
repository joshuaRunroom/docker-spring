FROM eclipse-temurin:19-jdk-focal as java-spring

ARG UID=1000
ARG GID=1000
ARG USER=www-data

RUN usermod -u $UID ${USER}
RUN groupmod -g $GID ${USER}

COPY .mvn/ .mvn
COPY mvnw pom.xml ./

RUN ./mvnw dependency:go-offline

RUN mkdir /var/www

RUN chown $UID:$GID /var/www

COPY target ./target

COPY src ./src


USER ${USER}

WORKDIR /app

CMD ["./mvnw", "spring-boot:run"]