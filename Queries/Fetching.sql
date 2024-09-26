/*  
    Listar o nome completo (primeiro nome + último nome), a idade e a cidade 
    de todos os passageiros do sexo feminino com mais de 40 anos, 
    residentes no país 'BRAZIL'.
*/
SELECT 
    passengers.FIRSTNAME || ' ' || passengers.LASTNAME AS FULL_NAME,
    ADD_MONTHS(details.birthdate, -40*12) AS AGE,
    details.CITY
FROM 
     AIR_PASSENGERS passengers 
        INNER JOIN
     AIR_PASSENGERS_DETAILS details
            ON passengers.passenger_id = details.passenger_id
WHERE
    details.SEX LIKE 'w' 
        AND
    details.birthdate <= ADD_MONTHS(SYSDATE, -40*12)
        AND
    details.COUNTRY LIKE 'BRAZIL';
    
/*
    Listar o nome da companhia aérea, o identificador da aeronave, o nome do 
    tipo de aeronave e o número de todos os voos operados por essa companhia 
    aérea (independentemente de a aeronave ser de sua propriedade) que saem E 
    chegam em aeroportos localizados no país 'BRAZIL'.
*/
SELECT 
    airlines.AIRLINE_NAME,
    flights.AIRPLANE_ID,
    plane_types.NAME AS AIRPLANE_TYPE,
    flights.FLIGHTNO
FROM
    AIR_FLIGHTS flights
        INNER JOIN
    AIR_AIRPORTS_GEO location_from
            ON flights.FROM_AIRPORT_ID = location_from.AIRPORT_ID
        INNER JOIN 
    AIR_AIRPORTS_GEO location_to
            ON flights.TO_AIRPORT_ID = location_to.AIRPORT_ID
        INNER JOIN
    AIR_AIRLINES airlines
            ON flights.AIRLINE_ID = airlines.AIRLINE_ID
        INNER JOIN
    AIR_AIRPLANES planes
            ON flights.AIRPLANE_ID = planes.AIRPLANE_ID
        INNER JOIN
    AIR_AIRPLANE_TYPES plane_types
            ON planes.AIRPLANE_TYPE_ID = plane_types.AIRPLANE_TYPE_ID
WHERE 
    location_from.COUNTRY LIKE location_to.COUNTRY
        AND
    location_from.COUNTRY LIKE 'BRAZIL';
    