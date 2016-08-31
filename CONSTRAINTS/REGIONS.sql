--------------------------------------------------------
--  Constraints for Table REGIONS
--------------------------------------------------------

  ALTER TABLE "SCOTT"."REGIONS" ADD CONSTRAINT "REGION_ID_NN" CHECK ("REGION_ID" IS NOT NULL) ENABLE;
 
  ALTER TABLE "SCOTT"."REGIONS" ADD CONSTRAINT "REG_ID_PK" PRIMARY KEY ("REGION_ID") ENABLE;
