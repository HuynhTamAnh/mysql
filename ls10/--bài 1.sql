--bài 1
DELIMITER //

CREATE PROCEDURE GetCitiesByCountry(
    IN country_code CHAR(3)
)
BEGIN
    SELECT 
        ID,
        Name AS 'tên thành phố',
        Population AS 'dân số'
    FROM city
    WHERE CountryCode = country_code;
END //

DELIMITER ;CALL GetCitiesByCountry('VNM');  

DROP PROCEDURE IF EXISTS GetCitiesByCountry;