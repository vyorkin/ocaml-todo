-- Deploy todo:todos to pg

BEGIN;

CREATE TABLE todo.todos
( id SERIAL PRIMARY KEY
, content TEXT NOT NULL
);

COMMIT;
