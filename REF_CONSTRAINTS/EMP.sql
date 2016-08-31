--------------------------------------------------------
--  Ref Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "SCOTT"."EMP" ADD CONSTRAINT "FK_DEPTNO" FOREIGN KEY ("DEPTNO")
	  REFERENCES "SCOTT"."DEPT" ("DEPTNO") ENABLE;
