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
   docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
   ```

   - Open `http://localhost:8081` and login with `admin` and the password found in `nexus-data/admin.password`

     - Run the following command to get the password:

       ```bash
       docker exec -it nexus cat /nexus-data/admin.password
       ```
