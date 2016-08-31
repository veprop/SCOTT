--------------------------------------------------------
--  Constraints for Table COUNTRIES
--------------------------------------------------------

  ALTER TABLE "SCOTT"."COUNTRIES" ADD CONSTRAINT "COUNTRY_C_ID_PK" PRIMARY KEY ("COUNTRY_ID") ENABLE;
 
  ALTER TABLE "SCOTT"."COUNTRIES" ADD CONSTRAINT "COUNTRY_ID_NN" CHECK ("COUNTRY_ID" IS NOT NULL) ENABLE;
