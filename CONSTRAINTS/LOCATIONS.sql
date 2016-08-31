--------------------------------------------------------
--  Constraints for Table LOCATIONS
--------------------------------------------------------

  ALTER TABLE "SCOTT"."LOCATIONS" ADD CONSTRAINT "LOC_CITY_NN" CHECK ("CITY" IS NOT NULL) ENABLE;
 
  ALTER TABLE "SCOTT"."LOCATIONS" ADD CONSTRAINT "LOC_ID_PK" PRIMARY KEY ("LOCATION_ID") ENABLE;
 
  ALTER TABLE "SCOTT"."LOCATIONS" MODIFY ("LOCATION_ID" NOT NULL ENABLE);
