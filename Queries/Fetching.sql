/*  
    Listar o nome completo (primeiro nome + último nome), a idade e a cidade 
    de todos os passageiros do sexo feminino com mais de 40 anos, 
    residentes no país 'BRAZIL'.
*/
SELECT 
    passengers.firstname || ' ' || passengers.lastname AS full_name,
    ADD_MONTHS(details.birthdate, -40*12) AS age,
    details.city
FROM 
     air_passengers passengers 
        INNER JOIN
     air_passengers_details details
            ON passengers.passenger_id = details.passenger_id
WHERE
    details.sex LIKE 'w' 
        AND
    details.birthdate <= ADD_MONTHS(SYSDATE, -40*12)
        AND
    details.country LIKE 'BRAZIL';
    
/*
    Listar o nome da companhia aérea, o identificador da aeronave, o nome do 
    tipo de aeronave e o número de todos os voos operados por essa companhia 
    aérea (independentemente de a aeronave ser de sua propriedade) que saem E 
    chegam em aeroportos localizados no país 'BRAZIL'.
*/
SELECT 
    airlines.airline_name,
    flights.airplane_id,
    plane_types.name AS airplane_type,
    flights.flightno
FROM
    air_flights flights
        INNER JOIN
    air_airports_geo location_from
            ON flights.from_airport_id = location_from.airport_id
        INNER JOIN 
    air_airports_geo location_to
            ON flights.to_airport_id = location_to.airport_id
        INNER JOIN
    air_airlines airlines
            ON flights.airline_id = airlines.airline_id
        INNER JOIN
    air_airplanes planes
            ON flights.airplane_id = planes.airplane_id
        INNER JOIN
    AIR_AIRPLANE_TYPES plane_types
            ON planes.airplane_type_id = plane_types.airplane_type_id
WHERE 
    location_from.COUNTRY LIKE location_to.COUNTRY
        AND
    location_from.COUNTRY LIKE 'BRAZIL';
    