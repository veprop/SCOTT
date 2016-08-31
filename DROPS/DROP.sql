DROP TABLE "SCOTT"."APP_PARAMETER" cascade constraints;
DROP TABLE "SCOTT"."BONUS" cascade constraints;
DROP TABLE "SCOTT"."COUNTRIES" cascade constraints;
DROP TABLE "SCOTT"."DEPARTMENTS" cascade constraints;
DROP TABLE "SCOTT"."DEPT" cascade constraints;
DROP TABLE "SCOTT"."EMP" cascade constraints;
DROP TABLE "SCOTT"."EMPLOYEES" cascade constraints;
DROP TABLE "SCOTT"."EVENT_LOG" cascade constraints;
DROP TABLE "SCOTT"."JOB_HISTORY" cascade constraints;
DROP TABLE "SCOTT"."JOBS" cascade constraints;
DROP TABLE "SCOTT"."LOCATIONS" cascade constraints;
DROP TABLE "SCOTT"."PARAMETERS" cascade constraints;
DROP TABLE "SCOTT"."REGIONS" cascade constraints;
DROP TABLE "SCOTT"."SALGRADE" cascade constraints;
DROP SEQUENCE "SCOTT"."DEPARTMENTS_SEQ";
DROP SEQUENCE "SCOTT"."EMPLOYEES_SEQ";
DROP SEQUENCE "SCOTT"."EVENT_LOG_SEQ";
DROP SEQUENCE "SCOTT"."LOCATIONS_SEQ";
DROP PACKAGE "SCOTT"."LOG_COMMON_PKG";
DROP PACKAGE "SCOTT"."LOG_PKG";
DROP PACKAGE BODY "SCOTT"."LOG_COMMON_PKG";
DROP PACKAGE BODY "SCOTT"."LOG_PKG";
DROP PROCEDURE "SCOTT"."ADD_JOB_HISTORY";
DROP PROCEDURE "SCOTT"."SECURE_DML";