-- USE netflix

-- Question 1 <  Analyze the distribution of content types (Movies vs. TV Shows).

SELECT type,COUNT(*) FROM netflix_titles
GROUP BY type ;

-- Question 2 < Identify the top 5 genres with the most content.

SELECT listed_in,COUNT(*) as num FROM netflix_titles
GROUP BY listed_in
ORDER BY num DESC
LIMIT 5 ;

-- Question 3 < Identify the top 5 genres with the most titles.

-- Split the genres into separate rows and count occurrences

-- Step 1: Create a temporary table to store the split genres
CREATE TEMPORARY TABLE genre_split AS
SELECT 
    show_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre
FROM 
    netflix_titles
JOIN 
    (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers 
ON 
    CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1;

-- Step 2: Count the occurrences of each genre
SELECT 
    genre, 
    COUNT(*) AS count
FROM 
    genre_split
GROUP BY 
    genre
ORDER BY 
    count DESC
LIMIT 5;


-- Question 4 > How has the number of movies and TV shows added to Netflix changed over the years?
SELECT type,release_year,COUNT(*) FROM netflix_titles
GROUP BY type,release_year ;

-- Question 5 < Which countries produce the most content on Netflix?
SELECT country,COUNT(*) AS num FROM netflix_titles
GROUP BY country
ORDER BY num DESC
LIMIT 1,1;

-- Question 6 < Who are the most prolific directors from the top 5 countries?
SELECT country,director,COUNT(*) AS num FROM netflix_titles
GROUP BY Director,Country
ORDER BY num DESC
LIMIT 5;

-- Question 7 < What is the average duration of movies on Netflix?
SELECT 
    AVG(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) AS average_duration
FROM 
    netflix_titles
WHERE 
    type = 'Movie';

-- Question 8 < How does the duration vary across different genres?
-- Step 1: Create a temporary table to store the split genres and their durations
CREATE TEMPORARY TABLE movie_genres_duration AS
SELECT 
    show_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre,
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS duration
FROM 
    netflix_titles
JOIN 
    (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers 
ON 
    CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
WHERE 
    type = 'Movie';

-- Step 2: Calculate the average duration for each genre
SELECT 
    genre,
    AVG(duration) AS average_duration
FROM 
    movie_genres_duration
GROUP BY 
    genre
ORDER BY 
    average_duration DESC;

-- Question 9 < What is the distribution of content ratings (e.g., TV-MA, PG-13)?
SELECT rating,COUNT(*) FROM netflix_titles
GROUP BY rating ;

-- Question 10 < How does the distribution differ between movies and TV shows?
SELECT type,rating,COUNT(*) FROM netflix_titles
GROUP BY type,rating
ORDER BY type ;

-- Question 11 < Who are the top 10 actors who appear most frequently in Netflix content?
-- Step 1: Create a temporary table to store the split cast
CREATE TEMPORARY TABLE actor_split AS
SELECT 
    show_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor
FROM 
    netflix_titles
JOIN 
    (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers 
ON 
    CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1
WHERE 
    cast IS NOT NULL;

-- Step 2: Count the occurrences of each actor and identify the top 10 actors
SELECT 
    actor, 
    COUNT(*) AS appearance_count
FROM 
    actor_split
GROUP BY 
    actor
ORDER BY 
    appearance_count DESC
LIMIT 10;


-- Question 12 > Which directors have directed the most number of movies/TV shows on Netflix?

SELECT type,director,COUNT(*) AS num FROM netflix_titles
GROUP BY director,type
ORDER BY director ;

-- Question 13 > Analyze the trend of content added on a monthly basis.
SELECT date_added,COUNT(*) FROM netflix_titles
GROUP BY date_added
ORDER BY date_added ; 

-- Question 14 > Are there any months where more content is added compared to others?
SELECT 
    MONTHNAME(STR_TO_DATE(date_added, '%M %d, %Y')) AS month,
    COUNT(*) AS content_count
FROM 
    netflix_titles
WHERE 
    date_added IS NOT NULL
GROUP BY 
    month
ORDER BY 
    content_count DESC;

-- Question 15 < What are the most popular categories for movies and TV shows?
-- Step 1: Create a temporary table to store the split categories for movies
CREATE TEMPORARY TABLE movie_categories AS
SELECT 
    show_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS category
FROM 
    netflix_titles
JOIN 
    (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers 
ON 
    CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
WHERE 
    type = 'Movie';

-- Step 2: Create a temporary table to store the split categories for TV shows
CREATE TEMPORARY TABLE tvshow_categories AS
SELECT 
    show_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS category
FROM 
    netflix_titles
JOIN 
    (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers 
ON 
    CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
WHERE 
    type = 'TV Show';

-- Step 3: Count the occurrences of each category for movies
SELECT 
    category, 
    COUNT(*) AS count
FROM 
    movie_categories
GROUP BY 
    category
ORDER BY 
    count DESC
LIMIT 10;

-- Step 4: Count the occurrences of each category for TV shows
SELECT 
    category, 
    COUNT(*) AS count
FROM 
    tvshow_categories
GROUP BY 
    category
ORDER BY 
    count DESC
LIMIT 10;

