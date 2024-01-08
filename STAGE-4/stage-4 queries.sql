USE genzdataset;

SHOW TABLES;

SELECT * FROM learning_aspirations;
SELECT * FROM manager_aspirations;
SELECT * FROM mission_aspirations;
SELECT * FROM personalized_info;

-- Q1: How many male have responded from India?

SELECT COUNT(*) FROM personalized_info
WHERE CurrentCountry = 'India' AND Gender = 'Male\r';

-- Q2: How many female have responded from India?

SELECT COUNT(*) FROM personalized_info
WHERE Gender = 'Female\r' AND CurrentCountry = 'India';

-- Q3: How many Gen Z are influenced by their parents in regards to their career choices from India?

SELECT COUNT(*) 
FROM (SELECT CareerInfluenceFactor, CurrentCountry FROM learning_aspirations
      INNER JOIN personalized_info
      ON learning_aspirations.ResponseID = personalized_info.ResponseID) AS merged
WHERE CareerInfluenceFactor = 'My Parents' AND CurrentCountry = 'India';

-- Q4: How many female Gen Z are influenced by their parents in regards to their career choices from India?

SELECT COUNT(*) 
FROM (SELECT CareerInfluenceFactor, CurrentCountry, Gender FROM learning_aspirations
      INNER JOIN personalized_info
      ON learning_aspirations.ResponseID = personalized_info.ResponseID) AS merged
WHERE CareerInfluenceFactor = 'My Parents' AND CurrentCountry = 'India' AND Gender = 'Female\r';

-- Q5: How many male Gen Z are influenced by their parents in regards to their career choices from India?

SELECT COUNT(*) 
FROM (SELECT CareerInfluenceFactor, CurrentCountry, Gender FROM learning_aspirations
      INNER JOIN personalized_info
      ON learning_aspirations.ResponseID = personalized_info.ResponseID) AS merged
WHERE CareerInfluenceFactor = 'My Parents' AND CurrentCountry = 'India' AND Gender = 'Male\r';

-- Q6: How many male and female (individually display in 2 different columns but as part of the same query) Gen Z are influenced by their parents in regards to their career choices from India?

SELECT 'Male\r' AS gender, COUNT(*) AS count
FROM (SELECT CareerInfluenceFactor, CurrentCountry, Gender FROM learning_aspirations
      INNER JOIN personalized_info
      ON learning_aspirations.ResponseID = personalized_info.ResponseID) AS merged
WHERE CareerInfluenceFactor = 'My Parents' AND CurrentCountry = 'India' AND Gender = 'Male\r'

UNION

SELECT 'Female\r' AS gender, COUNT(*) AS count
FROM (SELECT CareerInfluenceFactor, CurrentCountry, Gender FROM learning_aspirations
      INNER JOIN personalized_info
      ON learning_aspirations.ResponseID = personalized_info.ResponseID) AS merged
WHERE CareerInfluenceFactor = 'My Parents' AND CurrentCountry = 'India' AND Gender = 'Female\r';

-- Q7: How many Gen Z are influenced by media and influencers together from India?

SELECT
    CareerInfluenceFactor AS InfluenceFactor,
    COUNT(*) AS Count
FROM
    learning_aspirations AS la
INNER JOIN
    personalized_info AS pi ON la.ResponseID = pi.ResponseID
WHERE
    CurrentCountry = 'India'
    AND (CareerInfluenceFactor = 'Social Media like LinkedIn' OR CareerInfluenceFactor = 'Influencers who had successful careers')
GROUP BY
    CareerInfluenceFactor;

-- Q8: How many Gen Z are influenced by media and influencers together,display male and female separately from India?

SELECT
    CareerInfluenceFactor AS InfluenceFactor,
    Gender,
    COUNT(*) AS Count
FROM
    learning_aspirations AS la
INNER JOIN
    personalized_info AS pi ON la.ResponseID = pi.ResponseID
WHERE
    CurrentCountry = 'India'
    AND (CareerInfluenceFactor = 'Social Media like LinkedIn' OR CareerInfluenceFactor = 'Influencers who had successful careers')
    AND (Gender = 'Male\r' OR Gender = 'Female\r')
GROUP BY
    CareerInfluenceFactor, Gender;

-- Q9: How many of the Gen Z who are influenced by the social media for their career aspiration are looking to go abroad?

SELECT COUNT(*) FROM learning_aspirations
WHERE CareerInfluenceFactor = 'Social Media like LinkedIn' AND HigherEducationAbroad = 'Yes, I wil';

-- Q10: How many Gen Z who are influenced by "people in their circle" for their career aspiration are looking to go abroad?

SELECT COUNT(*) FROM learning_aspirations
WHERE CareerInfluenceFactor = 'People from my circle, but not family members' AND HigherEducationAbroad = 'Yes, I wil';