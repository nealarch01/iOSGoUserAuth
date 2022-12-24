-- PostgreSQL Version 15
DROP DATABASE IF EXISTS appdb;
CREATE DATABASE appdb;

\c appdb


CREATE TABLE account (
	id SERIAL PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	password VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO account (username, password, email) VALUES ('admin', 'admin', 'admin@localhost');

CREATE TABLE token_blacklist (
	id SERIAL PRIMARY KEY,
	token VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
