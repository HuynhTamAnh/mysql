--bài5
DELIMITER //

CREATE PROCEDURE GetLargeCitiesByCountry(
    IN country_code CHAR(3)
)
BEGIN
    SELECT 
        ID AS CityID,
        Name AS CityName,
        Population
    FROM city
    WHERE CountryCode = country_code
    AND Population > 1000000
    ORDER BY Population DESC;
END //

DELIMITER ;
CALL GetLargeCitiesByCountry('USA');
DROP PROCEDURE IF EXISTS GetLargeCitiesByCountry;