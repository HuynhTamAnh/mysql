--bài2
DELIMITER //

CREATE PROCEDURE CalculatePopulation(
    IN p_countryCode CHAR(3),
    OUT total_population INT
)
BEGIN
    SELECT SUM(Population) INTO total_population
    FROM city
    WHERE CountryCode = p_countryCode;
END //

DELIMITER ;
SET @total_pop = 0;
CALL CalculatePopulation('VNM', @total_pop);
SELECT @total_pop AS 'Total Population';
DROP PROCEDURE IF EXISTS CalculatePopulation;