# Regular-Expressions-in-SQL-Using-PostgreSQL
This project was built as a hands-on introduction to PostgreSQL's POSIX-compliant regular expression operators (~, ~+, ~*) and functions such as SUBSTRING and regexp_matches. 

### Key overview
- Pattern matching with anchors (^, $), quantifiers (+, {n}), and character classes ([a-z]).
- Case-insensitive searches (~*).
- Extracting and grouping data using regex.
- Real-world applications: Email validation, postal code parsing, hashtag extraction from tweets.

### Database:
- PostgreSQL (regex_db) to create tables (customers, twitter)
- Language SQL

### Basic pattern matching with LILE (wildcard)
```sql
-- Extract a list of all customers whose first name starts with 'He'
SELECT * FROM customers WHERE firstname LIKE ('He%');

-- Extract a list of all customers whose last name ends with 's'
SELECT * FROM customers WHERE lastname LIKE ('%s');

-- Extract a list of all customers whose first name contains 'ar'
SELECT * FROM customers WHERE firstname LIKE ('%ar%');

-- Extract a list of all customers whose first name has 'Mar' as the first three letters, followed by any single character
SELECT * FROM customers WHERE firstname LIKE ('Mar_');
```

### Advanced Regex Matching (~ snd ~*)
```sql
-- Retrieve a list of all customers whose first name starts with a
SELECT * FROM customers WHERE firstname ~* '^a+[a-z]+$';

-- Retrieve a list of all customers whose city starts with s
SELECT * FROM customers WHERE city ~* '^s+[a-z\s]+$';

-- Retrieve a list of all customers whose city starts with a, b, c, or d
SELECT *
FROM customers
WHERE
    city ~* '^[abcd]+[a-z\s]+$';
```

### Email Analysis and Validation
```sql
-- Retrieve the first name, last name, phone number, and email of all customers with a Gmail account
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~* '^[a-z0-9._%+-]+@gmail\.com$';
-- Retrieve the first name, last name, phone number, and email of all customers whose email starts with t
SELECT firstname, lastname, phone, email
FROM customers
WHERE
    email ~* '^t[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
```

### Data extraction with SUBSTRING
```sql
-- Retrieve all the data in the customers table
SELECT * FROM customers;

-- Retrieve the city, country, postal code, and original digits of the postal codes for Brazil
SELECT
    city,
    country,
    postalcode,
    SUBSTRING(postalcode FOR 5) AS old_postalcode
FROM customers
WHERE
    country = 'Brazil';

-- Retrieve the first name, last name, city, country, postal code, and the new digits of the postal codes for Brazil
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
```
### Social media extraction
```sql
-- Retrieve all tweetid and all COVID19 hashtags using regexp_matches()
SELECT tweetid, regexp_matches(tweets, '#(COVID19)', 'g') hashtags
FROM twitter;

-- Retrieve all tweet IDs and all distinct hashtags
SELECT DISTINCT
    regexp_matches(
        tweets,
        '#([A-Za-z0-9_]+)',
        'g'
    ) hashtags
FROM twitter;

-- Retrieve all distinct hashtags and the count of hashtags
SELECT regexp_matches(
        tweets, '#([A-Za-z0-9_]+)', 'g'
    ) hashtags, COUNT(*)
FROM twitter
GROUP BY
    hashtags
ORDER BY COUNT(*) DESC;
```
### Contact
Thanh Xuyen, Nguyen

LinkedIn: [xuyen-thanh-nguyen-0518](https://www.linkedin.com/in/xuyen-thanh-nguyen-0518/)

Email: thanhxuyen.nguyen@outlook.com
