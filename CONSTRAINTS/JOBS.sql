--------------------------------------------------------
--  Constraints for Table JOBS
--------------------------------------------------------

  ALTER TABLE "SCOTT"."JOBS" ADD CONSTRAINT "JOB_ID_PK" PRIMARY KEY ("JOB_ID") ENABLE;
 
  ALTER TABLE "SCOTT"."JOBS" ADD CONSTRAINT "JOB_TITLE_NN" CHECK ("JOB_TITLE" IS NOT NULL) ENABLE;
 
  ALTER TABLE "SCOTT"."JOBS" MODIFY ("JOB_ID" NOT NULL ENABLE);
