--bài2
-- Create view showing manager_id and total employees under each manager
CREATE VIEW view_manager_summary AS
SELECT manager_id, COUNT(*) as total_employees
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- Query to verify the view (shows manager_id and total_employees)
SELECT * FROM view_manager_summary;

-- Query to show manager names instead of IDs
SELECT e.name as manager_name, v.total_employees
FROM view_manager_summary v
JOIN employees e ON e.employee_id = v.manager_id;