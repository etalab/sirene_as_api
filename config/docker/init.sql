CREATE ROLE sirene_as_api WITH LOGIN CREATEDB PASSWORD 'password';

\c sirene_as_api_docker;
CREATE EXTENSION pg_trgm;
