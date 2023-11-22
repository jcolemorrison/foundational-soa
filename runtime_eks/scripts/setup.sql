set time zone 'UTC';
create extension pgcrypto;

CREATE TABLE customers (
    id VARCHAR(255) PRIMARY KEY NOT NULL,
    name VARCHAR(255) NOT NULL
);

INSERT INTO customers (id, name) VALUES (1, 'Rosemary');
INSERT INTO customers (id, name) VALUES (2, 'Cole');