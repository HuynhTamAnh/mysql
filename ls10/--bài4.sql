--bài4
DELIMITER //

CREATE PROCEDURE UpdateCityPopulation(
    INOUT p_city_id INT,
    IN new_population INT
)
BEGIN
    -- Update the city population
    UPDATE city 
    SET Population = new_population
    WHERE ID = p_city_id;
    
    -- Return the updated city information
    SELECT 
        ID AS 'CityID',
        Name AS 'Tên thành phố',
        Population AS 'Dân số mới'
    FROM city
    WHERE ID = p_city_id;
END //

DELIMITER ;
SET @city_id = 1;  -- Replace with actual city ID
CALL UpdateCityPopulation(@city_id, 1000000);  
DROP PROCEDURE IF EXISTS UpdateCityPopulation;