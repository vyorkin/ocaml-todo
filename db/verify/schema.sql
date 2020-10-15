-- Verify todo:schema on pg

BEGIN;

DO $$
BEGIN
   ASSERT (SELECT has_schema_privilege('todo', 'usage'));
END $$;

ROLLBACK;
