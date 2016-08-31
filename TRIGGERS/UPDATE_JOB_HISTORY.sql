--------------------------------------------------------
--  DDL for Trigger UPDATE_JOB_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."UPDATE_JOB_HISTORY" 
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/
ALTER TRIGGER "SCOTT"."UPDATE_JOB_HISTORY" ENABLE;
