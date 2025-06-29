-- Create security database
CREATE DATABASE security
WITH
    OWNER = 'postgres' ENCODING = 'UTF8';

DO $$ BEGIN IF NOT EXISTS (
    SELECT
    FROM pg_database
    WHERE
        datname = 'core'
) THEN PERFORM dblink_exec (
    'dbname=' || current_database (),
    'CREATE DATABASE core WITH OWNER = ''postgres'' ENCODING = ''UTF8'''
);

END IF;

END $$ LANGUAGE plpgsql;