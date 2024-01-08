USE genzdataset;

SHOW TABLES;

SELECT * FROM learning_aspirations;
SELECT * FROM manager_aspirations;
SELECT * FROM mission_aspirations;
SELECT * FROM personalized_info;

-- 1: What percentage of male and female gen z wants to go to office every day?

WITH filtered_data AS
( 
    SELECT p.Gender AS gender
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l 
    ON l.ResponseID = p.ResponseID
    WHERE l.PreferredWorkingEnvironment = 'Every Day Office Environment'
)

SELECT filtered_data.gender, (COUNT(*) / total.total_count) * 100 AS percentage
FROM filtered_data
CROSS JOIN (
    SELECT COUNT(p.Gender) AS total_count
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l 
    ON l.ResponseID = p.ResponseID
    WHERE l.PreferredWorkingEnvironment = 'Every Day Office Environment'
) AS total
GROUP BY filtered_data.gender, total.total_count;

-- 2. What percentage of Gen z who have chosen their career in business operations are most likely to be influenced by their parents?

SELECT (COUNT(*)/total.total_count)*100 AS percentage 
FROM learning_aspirations
CROSS JOIN (
           SELECT COUNT(*) AS total_count
           FROM learning_aspirations
) AS total
WHERE CareerInfluenceFactor = 'My Parents' AND ClosestAspirationalCareer LIKE '%Business Operations%'
GROUP BY total.total_count;

-- 3. What percentage of gen z prefer opting for higher studies, give a gender wise approach?

WITH filtered_data AS
( 
    SELECT p.Gender AS gender
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l 
    ON l.ResponseID = p.ResponseID
    WHERE l.HigherEducationAbroad = 'Yes, I wil'
)

SELECT filtered_data.gender, (COUNT(*) / total.total_count) * 100 AS percentage
FROM filtered_data
CROSS JOIN (
    SELECT COUNT(p.Gender) AS total_count
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l 
    ON l.ResponseID = p.ResponseID
    WHERE l.HigherEducationAbroad = 'Yes, I wil'
) AS total
GROUP BY filtered_data.gender, total.total_count;

-- 4. what percentage of genz are willing to work for a company whose mission is misaligned with their public actions or even their products? (give gender based split)

WITH filtered_data AS
( 
    SELECT p.Gender AS gender
    FROM personalized_info AS p
    INNER JOIN mission_aspirations AS m
    ON m.ResponseID = p.ResponseID
    WHERE m.MisalignedMissionLikelihood = 'Will work for them'
)

SELECT filtered_data.gender, (COUNT(*) / total.total_count) * 100 AS percentage
FROM filtered_data
CROSS JOIN (
    SELECT COUNT(p.Gender) AS total_count
    FROM personalized_info AS p
    INNER JOIN mission_aspirations AS m 
    ON m.ResponseID = p.ResponseID
    WHERE m.MisalignedMissionLikelihood = 'Will work for them'
) AS total
GROUP BY filtered_data.gender, total.total_count;

-- 5. calculate the total number of female who aspire to work in their closest apirational career and have a NO Social Impact Likelihood of '1 to 5'

SELECT COUNT(*) AS Total_number_of_females FROM learning_aspirations AS l
INNER JOIN mission_aspirations AS m
ON l.ResponseID = m.ResponseID
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE Gender = 'Female\r' 
      AND NoSocialImpactLikelihood BETWEEN 1 AND 5
      AND ClosestAspirationalCareer IS NOT NULL;

-- 6. what is the most suitable working environment according to female gen z?

SELECT PreferredWorkingEnvironment, COUNT(*) AS count FROM learning_aspirations
INNER JOIN personalized_info
ON learning_aspirations.ResponseID = personalized_info.ResponseID
WHERE Gender = 'Female\r'
GROUP BY PreferredWorkingEnvironment 
ORDER BY count DESC;

-- 7. Retreieve the male who are interested in higher education abroad and have a career influence factor of "My Parents"

SELECT learning_aspirations.ResponseID From learning_aspirations
INNER JOIN personalized_info
ON learning_aspirations.ResponseID = personalized_info.ResponseID
WHERE personalized_info.Gender = 'Male\r' 
      AND CareerInfluenceFactor = 'My Parents' 
      AND HigherEducationAbroad = 'Yes, I wil';
      
-- 8. Determine the percentage of gender who have a No Social Impact Likelihood of 8 to 10 among those who are interested in Higher Education Abroad

WITH filtered_data AS
( 
    SELECT p.Gender AS gender
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l
    ON p.ResponseID = l.ResponseID
    INNER JOIN mission_aspirations AS m
    ON l.ResponseID = m.ResponseID
    WHERE l.HigherEducationAbroad = 'Yes, I wil'
    AND m.NoSocialImpactLikelihood BETWEEN 8 AND 10
)

SELECT filtered_data.gender, (COUNT(*) / total.total_count) * 100 AS percentage
FROM filtered_data
CROSS JOIN (
    SELECT COUNT(p.Gender) AS total_count
    FROM personalized_info AS p
    INNER JOIN learning_aspirations AS l
    ON p.ResponseID = l.ResponseID
    INNER JOIN mission_aspirations AS m
    ON l.ResponseID = m.ResponseID
    WHERE l.HigherEducationAbroad = 'Yes, I wil'
    AND m.NoSocialImpactLikelihood BETWEEN 8 AND 10
) AS total
GROUP BY filtered_data.gender, total.total_count;

-- 9. Give a detailed split of the gen z preferences to work with Teams, data should include male, female and overall in counts and also the overall in %

WITH filtered_data AS (
   SELECT p.Gender
   FROM personalized_info AS p
   INNER JOIN manager_aspirations AS m
   ON p.ResponseID = m.ResponseID
   WHERE m.PreferredWorkSetup LIKE '%team%'
   AND (p.Gender = 'Male\r' OR p.Gender = 'Female\r')
)

SELECT
    fd.Gender AS gender,
    COUNT(*) AS count,
    (COUNT(*) / total.total_count) * 100 AS Percentage
FROM filtered_data AS fd
CROSS JOIN (
    SELECT COUNT(p.Gender) AS total_count
    FROM personalized_info AS p
    INNER JOIN manager_aspirations AS m ON p.ResponseID = m.ResponseID
    WHERE m.PreferredWorkSetup LIKE '%team%'
    AND (p.Gender = 'Male\r' OR p.Gender = 'Female\r')
) AS total
GROUP BY gender, total.total_count

UNION

SELECT
    'Overall' AS gender,
    COUNT(*) AS count,
    (COUNT(*) / total.total_count) * 100 AS Percentage
FROM filtered_data
CROSS JOIN (
    SELECT COUNT(*) AS total_count
    FROM filtered_data
) AS total
GROUP BY total.total_count;

-- 10. Give a detailed breakdown of "WorkLikelihood3Years" for each gender

SELECT m.WorkLikelihood3Years,
       p.Gender AS gender,
       COUNT(*) AS count
FROM manager_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
GROUP BY gender, m.WorkLikelihood3Years;

-- 11. what is the average starting salary expectations at 3 year mark for each gender

SELECT p.Gender as gender,
       AVG(m.ExpectedSalary3Years) AS Average_salary_at_3_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
GROUP BY gender;

-- 12. what is the average starting salary expectations at 5 years mark for each gender.

SELECT p.Gender as gender,
       AVG(m.ExpectedSalary5Years) AS Average_salary_at_5_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
GROUP BY gender;

-- 13. what is the average higher bar salary expectations at 3 years mark for each gender.

SELECT p.Gender as gender,
       MAX(m.ExpectedSalary3Years) AS Higher_salary_at_3_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
GROUP BY gender;

-- 14. what is the average higher bar salary expectations at 5 years mark for each gender.

SELECT p.Gender as gender,
       MAX(m.ExpectedSalary5Years) AS Higher_salary_at_5_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
GROUP BY gender;

-- 15. what is the average starting salary expectations at 3 years mark for each gender and each state in India.

SELECT p.Gender as gender,
       p.ZipCode as different_states,
       MIN(m.ExpectedSalary3Years) AS starting_salary_at_3_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE p.CurrentCountry = 'India'
GROUP BY gender,different_states;

-- 16. what is the average starting salary expectations at 5 years mark for each gender and each state in India.

SELECT p.Gender as gender,
       p.ZipCode as different_states,
       MIN(m.ExpectedSalary5Years) AS starting_salary_at_5_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE p.CurrentCountry = 'India'
GROUP BY gender,different_states;

-- 17. what is the average higher bar salary expectations at 3 years mark for each gender and each state in India.

SELECT p.Gender as gender,
       p.ZipCode as different_states,
       MAX(m.ExpectedSalary3Years) AS higher_salary_at_3_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE p.CurrentCountry = 'India'
GROUP BY gender,different_states;

-- 18. what is the average higher bar salary expectations at 5 years mark for each gender and each state in India.

SELECT p.Gender as gender,
       p.ZipCode as different_states,
       MAX(m.ExpectedSalary5Years) AS higher_salary_at_5_yrs
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE p.CurrentCountry = 'India'
GROUP BY gender,different_states;

-- 19. Give a detailed breakdown of the possibility of gen z working for an organization if the "Mission is misaligned" for each state in India.

SELECT p.ZipCode AS different_states,
       COUNT(*) AS count
FROM mission_aspirations AS m
INNER JOIN personalized_info AS p
ON m.ResponseID = p.ResponseID
WHERE p.CurrentCountry = 'India' 
      AND MisalignedMissionLikelihood = 'Will work for them'
GROUP BY 1
ORDER BY 2 DESC;