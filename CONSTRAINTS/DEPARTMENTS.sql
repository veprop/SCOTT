--------------------------------------------------------
--  Constraints for Table DEPARTMENTS
--------------------------------------------------------

  ALTER TABLE "SCOTT"."DEPARTMENTS" ADD CONSTRAINT "DEPT_ID_PK" PRIMARY KEY ("DEPARTMENT_ID") ENABLE;
 
  ALTER TABLE "SCOTT"."DEPARTMENTS" ADD CONSTRAINT "DEPT_NAME_NN" CHECK ("DEPARTMENT_NAME" IS NOT NULL) ENABLE;
 
  ALTER TABLE "SCOTT"."DEPARTMENTS" MODIFY ("DEPARTMENT_ID" NOT NULL ENABLE);
