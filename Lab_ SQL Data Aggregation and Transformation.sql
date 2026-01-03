-- USE SAKILA DATABASE
USE sakila;

-- CHALLENGE 1: Data Transformation and Formatting
-- 1.1 Determine the shortest and longest movie durations (max_duration, min_duration)
SELECT MAX(length) AS max_duration, MIN(length) AS min_duration FROM film;

-- 1.2 Express the average movie duration in hours and minutes
-- Using FLOOR for hours and MOD for remaining minutes
SELECT 
    FLOOR(AVG(length) / 60) AS hours, 
    ROUND(AVG(length) % 60) AS minutes 
FROM film;

-- 2.1 Calculate the number of days the company has been operating
-- Using DATEDIFF between the earliest and latest rental date
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS operating_days FROM rental;

-- 2.2 Retrieve rental information and add month and weekday columns
-- Extracting time components from the rental_date
SELECT *, 
       MONTHNAME(rental_date) AS rental_month, 
       DAYNAME(rental_date) AS rental_weekday 
FROM rental 
LIMIT 20;

-- 2.3 Add a column 'DAY_TYPE' with values 'weekend' or 'workday'
-- Using a CASE statement to categorize days
SELECT *,
    CASE 
        WHEN DAYNAME(rental_date) IN ('Saturday', 'Sunday') THEN 'weekend'
        ELSE 'workday'
    END AS DAY_TYPE
FROM rental;

-- 3. Retrieve film titles and their rental duration
-- If rental duration is NULL, replace it with 'Not Available'
SELECT title, IFNULL(rental_duration, 'Not Available') AS rental_duration
FROM film
ORDER BY title ASC;

-- 4. Personalize customer communications
-- Concatenating name and masking email (first 3 characters)
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(LEFT(email, 3), '...') AS masked_email
FROM customer
ORDER BY last_name ASC;


-- CHALLENGE 2: Grouping and Filtering (Aggregations)
-- 1.1 Total number of films released
SELECT COUNT(*) AS total_films FROM film;

-- 1.2 Number of films for each rating
SELECT rating, COUNT(*) AS number_of_films 
FROM film 
GROUP BY rating;

-- 1.3 Number of films for each rating, sorted descending
SELECT rating, COUNT(*) AS number_of_films 
FROM film 
GROUP BY rating 
ORDER BY number_of_films DESC;

-- 2.1 Mean film duration for each rating (rounded to 2 decimal places)
SELECT rating, ROUND(AVG(length), 2) AS mean_duration
FROM film
GROUP BY rating
ORDER BY mean_duration DESC;

-- 2.2 Identify ratings with a mean duration of over two hours (120 min)
-- Using HAVING to filter aggregate results
SELECT rating, ROUND(AVG(length), 2) AS mean_duration
FROM film
GROUP BY rating
HAVING mean_duration > 120;

-- BONUS: Determine which last names are not repeated in the actor table
SELECT last_name FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;