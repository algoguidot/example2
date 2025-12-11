show tables;

WITH dept_final_year AS (
    SELECT department, MAX(year_of_study) AS final_year
    FROM students
    GROUP BY department
),

improvements AS (
    SELECT 
        s.student_id,
        s.department,
        s.year_of_study,
        p.gpa_after_ai - p.gpa_before_ai AS gpa_improvement,
        d.final_year
    FROM students s
    JOIN performance p ON s.student_id = p.student_id
    JOIN dept_final_year d ON s.department = d.department
)

SELECT 
    CASE 
        WHEN year_of_study = 1 THEN 'First Year'
        WHEN year_of_study = final_year THEN 'Final Year'
        ELSE 'Other Years'
    END AS study_level,
    AVG(gpa_improvement) AS avg_gpa_improvement
FROM improvements
WHERE year_of_study = 1 OR year_of_study = final_year
GROUP BY study_level
ORDER BY avg_gpa_improvement DESC;
