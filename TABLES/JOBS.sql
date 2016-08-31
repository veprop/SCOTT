--------------------------------------------------------
--  DDL for Table JOBS
--------------------------------------------------------

  CREATE TABLE "SCOTT"."JOBS" 
   (	"JOB_ID" VARCHAR2(10 BYTE), 
	"JOB_TITLE" VARCHAR2(35 BYTE), 
	"MIN_SALARY" NUMBER(6,0), 
	"MAX_SALARY" NUMBER(6,0)
   ) ;
 

   COMMENT ON COLUMN "SCOTT"."JOBS"."JOB_ID" IS 'Primary key of jobs table.';
 
   COMMENT ON COLUMN "SCOTT"."JOBS"."JOB_TITLE" IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
 
   COMMENT ON COLUMN "SCOTT"."JOBS"."MIN_SALARY" IS 'Minimum salary for a job title.';
 
   COMMENT ON COLUMN "SCOTT"."JOBS"."MAX_SALARY" IS 'Maximum salary for a job title';
 
   COMMENT ON TABLE "SCOTT"."JOBS"  IS 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';
