-- Cluster creation
CREATE CLUSTER cl_airport_id (
    airport_id NUMBER(5)
)
SIZE 8K
HASHKEYS 128;

-- Aux tables
CREATE TABLE air_flights_cl
    CLUSTER cl_airport_id (to_airport_id) AS
    SELECT * FROM air_flights;
        
CREATE TABLE air_airports_cl
    CLUSTER cl_airport_id (airport_id) AS
        SELECT * FROM air_airports;
        
CREATE TABLE air_airports_geo_cl
    CLUSTER cl_airport_id (airport_id) AS
        SELECT * FROM air_airports_geo;
    
-- Deletions
DROP TABLE air_flights_cl CASCADE CONSTRAINTS;
DROP TABLE air_airports_cl CASCADE CONSTRAINTS;
DROP TABLE air_airports_geo_cl CASCADE CONSTRAINTS;
DROP CLUSTER cl_airport_id;