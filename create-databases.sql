-- Create security database
CREATE DATABASE security
WITH
    OWNER = postgres
    ENCODING = 'UTF8';

-- Create core database
CREATE DATABASE core
WITH
    OWNER = postgres
    ENCODING = 'UTF8';

-- Create auth_db database
CREATE DATABASE auth_db
WITH
    OWNER = postgres
    ENCODING = 'UTF8';