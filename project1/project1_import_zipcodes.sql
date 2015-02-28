/*

Mauricio Alarcon
IS606 - Project 1
mauricio.alarcon_balan@spsmail.cuny.edu

RVC Gym - Fitness Classes Database
===================================
POPULATE ZIP CODE TABLE.

Importing ZIP code database from: http://www.unitedstateszipcodes.org/zip-code-database/

IMPORTANT: PLEASE UPDATE THE PATH OF THE ZIPCODE CSV
*/

--Import data

DROP TABLE IF EXISTS zipcodes;

CREATE TABLE zipcodes
(
  zip int
, type VARCHAR(8)
, primary_city VARCHAR(27)
, acceptable_cities VARCHAR(255)
, unacceptable_cities VARCHAR(255)
, state VARCHAR(2)
, county VARCHAR(39)
, timezone VARCHAR(28)
, area_codes VARCHAR(21)
, latitude numeric
, longitude numeric
, world_region VARCHAR(2)
, country VARCHAR(2)
, decommissioned BIGINT
, estimated_population BIGINT
, notes VARCHAR(124)
)
;

-- populate zip code table
-- UPDATE path accordingly

COPY zipcodes from '/Users/malarcon/Google Drive/CUNY/IS607/submissions/project1/zip_code_database.csv' WITH DELIMITER ',' CSV HEADER ;
