CREATE ROLE sirene_as_api WITH LOGIN CREATEDB PASSWORD 'password';
CREATE DATABASE sirene_as_api_docker WITH OWNER postgres;

\c sirene_as_api_docker;
CREATE EXTENSION pg_trgm;
