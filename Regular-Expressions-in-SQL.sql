-- Active: 1761242575631@@127.0.0.1@5432@regex_db
###############################################################
###############################################################
-- Regular Expressions in SQL, using PostgreSQL
###############################################################
###############################################################
-- Create the customers table
CREATE TABLE customers (
    CustomerId SERIAL PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address text,
    City VARCHAR(255),
    Country VARCHAR(255),
    PostalCode VARCHAR(12),
    Phone VARCHAR(20),
    Email text,
    SupportRepId INT
);

-- Create the twitter table
CREATE TABLE twitter (tweetid INT, tweets text);

#############################
-- Retrieve all the data from the tables in regex-db database
SELECT * FROM customers;

SELECT * FROM twitter;

#############################
-- Extract a list of all customers whose first name starts with 'He'
SELECT * FROM customers WHERE firstname LIKE ('He%');

-- Extract a list of all customers whose last name ends with 's'
SELECT * FROM customers WHERE lastname LIKE ('%s');

-- Extract a list of all customers whose first name contains 'ar'
SELECT * FROM customers WHERE firstname LIKE ('%ar%');

-- Extract a list of all customers whose first name has 'Mar' as the first three letters followed by any single character
SELECT * FROM customers WHERE firstname LIKE ('Mar_');

-- Extract all individuals from the customers table whose first name does not contain 'Mar'
SELECT *
FROM customers
WHERE
    firstname NOT LIKE ('%Mar%');

#############################
-- Using regular expressions wildcard characters
#############################
-- Retrieve a list of all customers whose first name starts with a
SELECT * FROM customers WHERE firstname ~* '^a+[a-z]+$';

-- Retrieve a list of all customers whose city starts with s
SELECT * FROM customers WHERE city ~* '^s+[a-z\s]+$';

-- Retrieve a list of all customers whose city starts with a, b, c, or d
SELECT *
FROM customers
WHERE
    city ~* '^[abcd]+[a-z\s]+$';
-- Or
SELECT * FROM customers WHERE city ~* '^[a-d]+[a-z\s]+$';

-- Alternative
SELECT *
FROM customers
WHERE
    city ~* '^(a|b|c|d)+[a-z\s]+$';

-- Retrieve a list of all customers whose city starts with s
SELECT *
FROM customers
WHERE
    city ~* '^s+[a-z]{2}\s[a-z]{5}$';

#############################
-- Retrieve the first name, last name, phone number and email of all customers with a gmail account
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~* '^[a-z0-9._%+-]+@gmail\.com$';

-- Alternative
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ 'gmail\.com$';

-- Retrieve the first name, last name, phone number and email of all customers whose email starts with t
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~* '^t[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';

-- Alternative
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ '^t';

-- Retrieve the first name, last name, phone number and email of all customers whose email ends with com
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.com$';

-- Alternative
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ 'com$';

-- Retrieve the first name, last name, phone number and email of all customers whose email starts with a, b, or t
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ '^[abt]';

-- Alternative
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ '^(a|b|t)';

-- Retrieve the first name, last name, phone number and email of all customers whose email contain a number
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ '[0-9]';

-- Retrieve the first name, last name, phone number and email of all customers whose email contain two-digit numbers
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~ '[0-9]{2}';

#############################
-- Retrieve all the data in the customers table
SELECT * FROM customers;

-- Retrieve the city, country, postalcode and original digits of the postal codes for Brazil
SELECT
    city,
    country,
    postalcode,
    SUBSTRING(postalcode FOR 5) AS old_postalcode
FROM customers
WHERE
    country = 'Brazil';

-- Retrieve the first name, last name, city, country, postalcode and the new digits of the postal codes for Brazil
SELECT
    firstname,
    lastname,
    city,
    country,
    postalcode,
    SUBSTRING(
        postalcode
        FROM 7 FOR 3
    ) AS new_postalcode
FROM customers
WHERE
    country = 'Brazil';

-- Retrieve the numbers in the email addresses of customers
SELECT
    firstname,
    lastname,
    phone,
    email,
    SUBSTRING(
        email
        FROM '[0-9]+'
    ) AS numbers_in_email
FROM customers
WHERE
    email ~ '[0-9]';

-- Retrieve the domain names in the email addresses of customers
SELECT
    firstname,
    lastname,
    phone,
    email,
    SUBSTRING(
        email
        FROM '@([A-Za-z0-9.-]+\.[A-Za-z]{2,})'
    ) AS domain_name
FROM customers
WHERE
    email ~ '@([A-Za-z0-9.-]+\.[A-Za-z]{2,})';

-- Alternative
SELECT
    firstname,
    lastname,
    phone,
    email,
    SUBSTRING(
        email
        FROM '@(.+)$'
    ) AS domain_name -- * greedy match and + one or more
FROM customers;

-- Retrieve the distinct domain names in the email addresses of customers
SELECT DISTINCT
    SUBSTRING(
        email
        FROM '@([A-Za-z0-9.-]+\.[A-Za-z]{2,})'
    ) AS domain_name
FROM customers;

-- Retrieve the domain names and count of the domain names in the email addresses of customers
SELECT SUBSTRING(
        email
        FROM '@([A-Za-z0-9.-]+\.[A-Za-z]{2,})'
    ) AS domain_name, COUNT(*) AS domain_count
FROM customers
GROUP BY
    domain_name
ORDER BY domain_count DESC;

-- Retrieve the first name, last name, country and emails of all customers whose email domain name is gmail.com
SELECT
    firstname,
    lastname,
    country,
    email
FROM customers
WHERE
    email ~ '@gmail\.com$';

#############################
-- Retrieve all tweets and tweetid with the word #COVID
SELECT * FROM twitter WHERE tweets ~ '#COVID';

-- Retrieve all tweets and tweetid with the word #COVID19
SELECT * FROM twitter WHERE tweets ~ '#COVID19';

-- Retrieve all tweetid and all hashtags
SELECT tweetid, regexp_matches(
        tweets, '#([A-Za-z0-9_]+)', 'g'
    ) hashtags
FROM twitter;

-- Retrieve all tweetid and all COVID19 hashtags using regexp_matches()
SELECT tweetid, regexp_matches(tweets, '#(COVID19)', 'g') hashtags
FROM twitter;

-- Retrieve all tweetid and all distinct hashtags
SELECT DISTINCT
    regexp_matches(
        tweets,
        '#([A-Za-z0-9_]+)',
        'g'
    ) hashtags
FROM twitter;

-- Retrieve all distinct hashtags and the count of the hashtags
SELECT regexp_matches(
        tweets, '#([A-Za-z0-9_]+)', 'g'
    ) hashtags, COUNT(*)
FROM twitter
GROUP BY
    hashtags
ORDER BY COUNT(*) DESC;