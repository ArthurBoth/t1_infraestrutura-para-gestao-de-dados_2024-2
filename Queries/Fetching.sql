/*  
    Listar o nome completo (primeiro nome + ultimo nome), a idade e a cidade 
    de todos os passageiros do sexo feminino com mais de 40 anos, 
    residentes no pais 'BRAZIL'.
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
    Listar o nome da companhia aerea, o identificador da aeronave, o nome do 
    tipo de aeronave e o numero de todos os voos operados por essa companhia 
    aerea (independentemente de a aeronave ser de sua propriedade) que saem E 
    chegam em aeroportos localizados no pais 'BRAZIL'.
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
    air_airplane_types plane_types
            ON planes.airplane_type_id = plane_types.airplane_type_id
WHERE 
    location_from.country LIKE location_to.country
        AND
    location_from.country LIKE 'BRAZIL';

/*
 Listar o numero do voo, o nome do aeroporto de saida e o nome do aeroporto de 
 destino, o nome completo (primeiro e ultimo nome) e o assento de cada 
 passageiro, para todos os voos que partem no dia do seu aniversario(11/10/2024)
 neste ano.
*/
DEFINE birthday = TO_DATE('11/10/2023', 'DD/MM/YYYY');
SELECT 
    flights.flightno,
    from_geo.name AS "from",
    to_geo.name AS "to",
    passengers.firstname || ' ' || passengers.lastname AS full_name,
    bookings.seat
FROM
    air_flights flights
        INNER JOIN
    air_airports from_airport
            ON flights.from_airport_id = from_airport.airport_id
        INNER JOIN
    air_airports to_airport
            ON flights.to_airport_id = to_airport.airport_id
        INNER JOIN
    air_airports_geo from_geo
            ON from_airport.airport_id = from_geo.airport_id
        INNER JOIN
    air_airports_geo to_geo
            ON to_airport.airport_id = to_geo.airport_id
        INNER JOIN
    air_bookings bookings
            ON flights.flight_id = bookings.flight_id
        INNER JOIN
    air_passengers passengers
            ON bookings.passenger_id = passengers.passenger_id
WHERE 
    flights.departure 
        BETWEEN 
            &birthday + 1 -- there was no flight on my birthday
        AND 
            (&birthday + 2) - (1 / (24 * 60 * 60));
UNDEFINE birthday;

/*
    Listar o nome da companhia aerea bem como a data e a hora de saida de todos 
    os voos que chegam para a cidade de 'NEW YORK' que partem as tercas, quartas 
    ou quintas-feiras, no mes do seu aniversario.
*/
SELECT
    airlines.airline_name,
    flights.departure
FROM
    air_flights flights
        INNER JOIN
    air_flights_schedules schedules
            ON flights.flightno = schedules.flightno
        INNER JOIN
    air_airports to_airport
            ON schedules.to_airport_id = to_airport.airport_id
        INNER JOIN
    air_airports_geo to_geo
            ON to_airport.airport_id = to_geo.airport_id
        INNER JOIN
    air_airlines airlines
            ON schedules.airline_id = airlines.airline_id
WHERE
    to_geo.city LIKE 'NEW YORK'
        AND
    (
        flights.departure >= TO_DATE('3', 'MM')
            AND
        flights.departure < TO_DATE('4', 'MM')
    )
        AND 
    (
        schedules.tuesday = 1
            OR
        schedules.wednesday = 1
            OR
        schedules.thursday = 1
    );

/*
    Crie uma consulta que seja resolvida adequadamente com um acesso hash em um 
    cluster com pelo menos duas tabelas. A consulta deve utilizar todas as 
    tabelas do cluster e pelo menos outra tabela fora dele.
    Consulta escolhida:
    Listar o numero do voo, nome da cidade do destino, nome do aeroporto e 
    assento de passageiros idosos
*/
-- Fetch WITHOUT clusters
SELECT
    flights.flightno,
    to_geo.city,
    airports.name,
    bookings.seat,
    TRUNC(MONTHS_BETWEEN(SYSDATE, passengers.birthdate) / 12) AS age
FROM
    air_flights flights
        INNER JOIN
    air_airports airports
            ON flights.to_airport_id = airports.airport_id
        INNER JOIN
    air_airports_geo to_geo
            ON airports.airport_id = to_geo.airport_id
        INNER JOIN
    air_bookings bookings
            ON flights.flight_id = bookings.flight_id
        INNER JOIN
    air_passengers_details passengers
            ON bookings.passenger_id = passengers.passenger_id
WHERE
    passengers.birthdate <= ADD_MONTHS(SYSDATE, -60*12);
    
-- Fetch WITH clusters
SELECT
    flights.flightno,
    to_geo.city,
    airports.name,
    bookings.seat,
    TRUNC(MONTHS_BETWEEN(SYSDATE, passengers.birthdate) / 12) AS age
FROM
    air_flights_cl flights
        INNER JOIN
    air_airports_cl airports
            ON flights.to_airport_id = airports.airport_id
        INNER JOIN
    air_airports_geo_cl to_geo
            ON airports.airport_id = to_geo.airport_id
        INNER JOIN
    air_bookings bookings
            ON flights.flight_id = bookings.flight_id
        INNER JOIN
    air_passengers_details passengers
            ON bookings.passenger_id = passengers.passenger_id
WHERE
    passengers.birthdate <= ADD_MONTHS(SYSDATE, -60*12);