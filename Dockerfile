# Используем Gradle с JDK 17
FROM gradle:8.11.1-jdk17 AS builder

WORKDIR /app

# Копируем исходники и файлы Gradle Wrapper
COPY ./src ./src
COPY ./build.gradle.kts .
COPY ./gradlew .
COPY ./gradle ./gradle

# Даем права на выполнение Gradle Wrapper
RUN chmod +x ./gradlew

# Проверяем Java-версию для отладки
RUN java -version

# Запускаем сборку проекта через Gradle Wrapper
RUN ./gradlew bootJar && ls -lah build/libs

# Создаём финальный образ с JDK 17
FROM openjdk:17

WORKDIR /app


# Копируем jar файл из стадии сборки
COPY --from=builder /app/build/libs/*.jar /app/spring-elk.jar

# Запускаем приложение
CMD ["java",  "-jar", "/app/spring-elk.jar"]
