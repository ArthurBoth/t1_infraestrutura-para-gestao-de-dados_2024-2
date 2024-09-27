-- Criacao dos indices
CREATE INDEX idx_psgdet_country ON air_passengers_details (country);
CREATE INDEX idx_psgfull_name ON air_passengers (firstname, lastname);
CREATE INDEX idx_airptgeo_country ON air_airports_geo (country); 
CREATE INDEX idx_airptgeo_city ON air_airports_geo (city); 
CREATE INDEX idx_airflt_departure ON air_flights (departure); 

-- Delecao dos indices
DROP INDEX idx_psgdet_country;
DROP INDEX idx_psgfull_name;
DROP INDEX idx_airptgeo_country;
DROP INDEX idx_airflt_departure;
DROP INDEX idx_airptgeo_city;