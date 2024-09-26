-- Import tables
CREATE TABLE air_airlines 
    AS SELECT * FROM acampos.air_airlines;
CREATE TABLE air_airplanes 
    AS SELECT * FROM acampos.air_airplanes;
CREATE TABLE air_airplane_types 
    AS SELECT * FROM acampos.air_airplane_types;
CREATE TABLE air_airports 
    AS SELECT * FROM acampos.air_airports;
CREATE TABLE air_airports_geo 
    AS SELECT * FROM acampos.air_airports_geo;
CREATE TABLE air_bookings 
    AS SELECT * FROM acampos.air_bookings;
CREATE TABLE air_flights 
    AS SELECT * FROM acampos.air_flights;
CREATE TABLE air_flights_schedules 
    AS SELECT * FROM acampos.air_flights_schedules;
CREATE TABLE air_passengers 
    AS SELECT * FROM acampos.air_passengers;
CREATE TABLE air_passengers_details 
    AS SELECT * FROM acampos.air_passengers_details;

-- Re-adding constraints
ALTER TABLE air_airplane_types
    ADD CONSTRAINT pk_airplane_types PRIMARY KEY (airplane_type_id);
ALTER TABLE air_airports
    ADD CONSTRAINT pk_airports PRIMARY KEY (airport_id);
ALTER TABLE air_airports_geo
    ADD CONSTRAINT pk_airports_geo PRIMARY KEY (airport_id)
    ADD CONSTRAINT fk_airports_geo_airport_id FOREIGN KEY (airport_id)
        REFERENCES air_airports (airport_id);
ALTER TABLE air_airlines
    ADD CONSTRAINT pk_airlines PRIMARY KEY (airline_id)
    ADD CONSTRAINT fk_base_airport_id FOREIGN KEY (base_airport_id) 
        REFERENCES air_airports (airport_id);
ALTER TABLE air_airplanes
    ADD CONSTRAINT pk_airplanes PRIMARY KEY (airplane_id)
    ADD CONSTRAINT fk_airplanes_airline_id FOREIGN KEY (airline_id)
        REFERENCES air_airlines (airline_id)
    ADD CONSTRAINT fk_airplanes_airplane FOREIGN KEY (airplane_type_id)
        REFERENCES air_airplane_types (airplane_type_id);
ALTER TABLE air_flights_schedules
    ADD CONSTRAINT pk_flights_sched PRIMARY KEY (flightno)
    ADD CONSTRAINT fk_flights_sched_line_id FOREIGN KEY (airline_id)
        REFERENCES air_airlines (airline_id)
    ADD CONSTRAINT fk_flights_sched_from_id FOREIGN KEY (from_airport_id)
        REFERENCES air_airports (airport_id)
    ADD CONSTRAINT fk_flights_sched_to_id FOREIGN KEY (to_airport_id)
        REFERENCES air_airports (airport_id);
ALTER TABLE air_passengers
    ADD CONSTRAINT pk_passengers PRIMARY KEY (passenger_id);
ALTER TABLE air_passengers_details
    ADD CONSTRAINT pk_passengers_details PRIMARY KEY (passenger_id)
    ADD CONSTRAINT fk_passengers_det_psng_id FOREIGN KEY (passenger_id)
        REFERENCES air_passengers (passenger_id);
ALTER TABLE air_flights
    ADD CONSTRAINT pk_flights PRIMARY KEY (flight_id)
    ADD CONSTRAINT fk_flights_flightno FOREIGN KEY (flightno)
        REFERENCES air_flights_schedules (flightno)
    ADD CONSTRAINT fk_flights_airline_id FOREIGN KEY (airline_id)
        REFERENCES air_airlines (airline_id)
    ADD CONSTRAINT fk_flights_from_airport_id FOREIGN  KEY (from_airport_id)
        REFERENCES air_airports (airport_id)
    ADD CONSTRAINT fk_flights_to_airport_id FOREIGN KEY (to_airport_id)
        REFERENCES air_airports (airport_id)
    ADD CONSTRAINT fk_flights_airplane_id FOREIGN KEY (airplane_id)
        REFERENCES air_airplanes (airplane_id);
ALTER TABLE air_bookings
    ADD CONSTRAINT pk_bookings PRIMARY KEY (booking_id)
    ADD CONSTRAINT fk_bookings_passenger_id FOREIGN KEY (passenger_id)
        REFERENCES air_passengers (passenger_id)
    ADD CONSTRAINT fk_bookings_flight_id FOREIGN KEY (flight_id)
        REFERENCES air_flights (flight_id);