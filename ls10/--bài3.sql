--bài3
DELIMITER //

CREATE PROCEDURE GetCountriesByLanguage(
    IN p_language VARCHAR(30)
)
BEGIN
    SELECT 
        cl.CountryCode,
        cl.Language,
        cl.Percentage
    FROM countrylanguage cl
    WHERE cl.Language = p_language 
    AND cl.Percentage > 50
    ORDER BY cl.Percentage DESC;
END //

DELIMITER ;

CALL GetCountriesByLanguage('English');  

DROP PROCEDURE IF EXISTS GetCountriesByLanguage;