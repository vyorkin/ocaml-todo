-- Revert todo:todos from pg

BEGIN;

DROP TABLE todo.todos;

COMMIT;
