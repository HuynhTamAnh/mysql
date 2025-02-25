--bai7-ss10
DELIMITER //

CREATE PROCEDURE GetEnglishSpeakingCountriesWithCities(IN p_language CHAR(30))
BEGIN
    SELECT 
        co.Name AS CountryName,
        SUM(ci.Population) AS TotalPopulation
    FROM 
        country co
    INNER JOIN 
        countrylanguage cl ON co.Code = cl.CountryCode
    INNER JOIN 
        city ci ON co.Code = ci.CountryCode
    WHERE 
        cl.Language = p_language
        AND cl.IsOfficial = 'T'
    GROUP BY 
        co.Name
    HAVING 
        SUM(ci.Population) > 5000000
    ORDER BY 
        TotalPopulation DESC
    LIMIT 10;
END //

DELIMITER ;