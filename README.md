# E COMMERCE

This project is a full e-commerce solution integration

## Prerequisites

- Java 21 or higher
- Gradle 8.0 or higher
- Docker
- Node.js 20 or higher
- npm 9 or bun 1.0 or higher
- PostgreSQL 16 or higher

## Getting Started

### Initialize submodules

   ```bash
   git submodule update --init --recursive
   ```

### Run and configure nexus in local: `(Docker is required)`

   ```bash
   docker run -d -p 8081:8081 --name nexus sonatype/nexus3
   ```

- Open `http://localhost:8081` and login with `admin` and the password found in `nexus-data/admin.password`

  - Run the following command to get the password:

      ```bash
      docker exec -it nexus cat /nexus-data/admin.password
      ```

  - Configure new credentials for the `admin` user.

  - Create a new repository in Nexus:

    - Go to `Repositories` and create a new `Maven (hosted)` repository.
    - Name it `ecommerce`.
    - Set the `Version Policy` to `Mixed`.
    - Set the `Write Policy` to `Allow Redeploy`.
    - Set the `Blob store` to `default`.

- Configure `gradle.properties` file into libraries:
  
     ```gradle
     org.gradle.configuration-cache=true
     org.gradle.parallel=true
     org.gradle.caching=true
     # Nexus repository
     nexus.url=NEXUS_URL
     nexus.username=NEXUS_USER
     nexus.password=NEXUS_PASSWORD
     ```
  
- Publish libraries to nexus: `(publish.bat for windows && publish.sh for Unix)`
  
     ```bash
     ./publish
     ```

- Review the libraries in Nexus:

  - Go to `Browse` and select the `ecommerce` repository.
  - You should see the libraries published.

### Configure `environments` file

- In root path of a project, copy the file `.env.example` to `.env` and set the required variables.

### Run project

- To run the project, you need to have Docker installed and running.
- You can run the project using the following command:

  ```bash
  docker-compose --env-file .env up --build -d --force-recreate
  ```
