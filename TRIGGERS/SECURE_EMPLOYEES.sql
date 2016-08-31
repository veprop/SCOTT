--------------------------------------------------------
--  DDL for Trigger SECURE_EMPLOYEES
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."SECURE_EMPLOYEES" 
  BEFORE INSERT OR UPDATE OR DELETE ON employees
BEGIN
  secure_dml;
END secure_employees;
/
ALTER TRIGGER "SCOTT"."SECURE_EMPLOYEES" ENABLE;
