--bài6
DELIMITER //

CREATE PROCEDURE GetCountriesWithLargeCities()
BEGIN
    SELECT 
        c.Name AS CountryName,
        SUM(ci.Population) AS TotalPopulation
    FROM country c
    INNER JOIN city ci ON c.Code = ci.CountryCode
    WHERE c.Continent = 'Asia'
    GROUP BY c.Code, c.Name
    HAVING SUM(ci.Population) > 10000000
    ORDER BY TotalPopulation DESC;
END //

DELIMITER ;

CALL GetCountriesWithLargeCities();

DROP PROCEDURE IF EXISTS GetCountriesWithLargeCities;