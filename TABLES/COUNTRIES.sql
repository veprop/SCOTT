--------------------------------------------------------
--  DDL for Table COUNTRIES
--------------------------------------------------------

  CREATE TABLE "SCOTT"."COUNTRIES" 
   (	"COUNTRY_ID" CHAR(2 BYTE), 
	"COUNTRY_NAME" VARCHAR2(40 BYTE), 
	"REGION_ID" NUMBER, 
	 CONSTRAINT "COUNTRY_C_ID_PK" PRIMARY KEY ("COUNTRY_ID") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS ;
 

   COMMENT ON COLUMN "SCOTT"."COUNTRIES"."COUNTRY_ID" IS 'Primary key of countries table.';
 
   COMMENT ON COLUMN "SCOTT"."COUNTRIES"."COUNTRY_NAME" IS 'Country name';
 
   COMMENT ON COLUMN "SCOTT"."COUNTRIES"."REGION_ID" IS 'Region ID for the country. Foreign key to region_id column in the departments table.';
 
   COMMENT ON TABLE "SCOTT"."COUNTRIES"  IS 'country table. Contains 25 rows. References with locations table.';
