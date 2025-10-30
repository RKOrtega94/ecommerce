# 🛍️ E-Commerce Microservices Project

This is a comprehensive e-commerce platform built with microservices architecture, featuring Spring Boot backend services, Angular frontend, and modern DevOps practices.

## 🏗️ Architecture Overview

### Backend Services (Spring Boot + gRPC)

- **Core Services**: Config Server, API Gateway, Discovery Server, Identity Service
- **Business Services**: Security Service, Core Business Service
- **Shared Libraries**: Commons, gRPC Common, Messaging, XML Signer

### Frontend

- **Angular Application**: Modern web interface with server-side rendering

## 🚀 Getting Started

### Run Redis

For development purposes, you can run Redis using Docker or install it locally.

```bash
docker run -d --name redisinsight -p 5540:5540 redis/redisinsight:latest -v redisinsight:/data
```

### Postgres

For development purposes, you can run Postgres using Docker or install it locally.

```bash
docker run -d --name postgres -e POSTGRES_USER=youruser -e POSTGRES_PASSWORD=yourpassword -e POSTGRES_DB=yourdb -p 5432:5432 postgres:latest
```
