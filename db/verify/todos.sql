-- Verify todo:todos on pg

BEGIN;

SELECT
  id, content
FROM
  todo.todos
WHERE
  FALSE;

ROLLBACK;
