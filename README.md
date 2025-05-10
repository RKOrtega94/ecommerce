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

1. Initialize submodules:

   ```bash
   git submodule update --init --recursive
   ```

2. Run and configure nexus in local: `(Docker is required)`

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

   - Configure root `.env` file:

      - Copy `.env.example` to `.env` and set the following variables:

         ```bash
         NEXUS_URL=http://localhost:8081
         NEXUS_USERNAME=admin
         NEXUS_PASSWORD=<your_password>
         NEXUS_REPOSITORY=ecommerce
         ```

   - Publish libraries to nexus: `(publish.bat for windows && publish.sh for Unix)`

      ```bash
      ./publish
      ```
