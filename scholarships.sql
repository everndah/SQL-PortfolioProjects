/* In this project we find and compare scholarships for college students, college grants, fellowships, federal financial aid and other forms of student funding to cover expenses for international Bachelors, Masters and PhDs worldwide using  Standard Query language.

1. Get scholarships data from Kaggle.
2.Create a database
3.Create a table and import the CSV data into the database.
4. Use SQL TO query the data. 

Dataset link- https://www.kaggle.com/datasets/timmofeyy/-universities-schoolarships-all-around-the-world */



-- Create a database called scholarshipsdb

CREATE DATABASE scholarshipsdb;

--Check a list of databases

\l   

--Connect  to scholarshipsdb database

\c scholarshipsdb;

-- Create a table inside scholarshipsdb 

CREATE TABLE students(
    id BIGSERIAL  PRIMARY KEY,
    title VARCHAR(250) ,
    degrees VARCHAR(250) ,
    funds VARCHAR(250),
    date VARCHAR(250),
    location VARCHAR(250)
    
);


/* Import data into the students table. 
The  data  has five string  columns and one integer column*/

\copy students FROM '/Users/USER/Scholarships.csv' DELIMITER ',' CSV HEADER;

-- Alter table Columns to accept more varchar

ALTER TABLE students ALTER COLUMN title TYPE varchar(250);
ALTER TABLE students ALTER COLUMN funds TYPE varchar(250);
ALTER TABLE students ALTER COLUMN degree TYPE varchar(200);

-- Alternatively let us  alter varchar to Text

ALTER TABLE students ALTER COLUMN title TYPE TEXT;
ALTER TABLE students ALTER COLUMN funds TYPE TEXT;
ALTER TABLE students ALTER COLUMN degree TYPE TEXT;

-- Inspect the number of rows  in the table

SELECT COUNT(*) students;

--View the number of countries in the data

SELECT DISTINCT location FROM students ORDER BY location ASC;


/* There are two african countries;
1. View values from location  = 'nigeria' 
2. View values from 'nigeria' and 'south Africa'
3. Those from the two African countries with masters degrees*/

SELECT DISTINCT location FROM students WHERE location = 'nigeria';

SELECT *  FROM students WHERE location  = 'nigeria' OR location = 'south-africa';  

SELECT *  FROM students WHERE (location  = 'nigeria' OR location = 'south-africa') AND degrees = 'Master'; 

-- View the date in descending order

SELECT * FROM students ORDER BY date DESC;

/* Most of the values do not have dates.
Select the date column and look at the number of unique  values in the date column*/

SELECT DISTINCT date from students;

--INSPECT THE FIRST 10 ROWS

SELECT * FROM students LIMIT 10; /* Also can be done using*/
SELECT * FROM students FETCH FIRST 10 ROW ONLY;

/*INSPECT THE 100 ROWS AFTER THE FIRST 50 ROWS*/

SELECT * FROM students OFFSET 50 LIMIT 100;

/*Inspect all fully funded students who have  Master', 'Bachelor', 'Phd'
1. Order the selection  by location*/

SELECT * FROM students WHERE degrees in ('Master', 'Bachelor', 'Phd') AND funds = 'Fully Funded';

SELECT * FROM students WHERE degrees in ('Master', 'Bachelor', 'Phd') AND funds = 'Fully Funded' ORDER BY location;

--SELECT scholarships from the year 2019 only

SELECT * FROM students WHERE date BETWEEN '1-Jan 2019' AND '31-Dec-2019';


--Fetch entries that  at least  have a bachelor

SELECT * FROM students WHERE degrees  LIKE '%chelor';

--Fetch  scholarships titles

SELECT DISTINCT title FROM students;

SELECT * FROM students WHERE title = 'NLU Alumni Scholarship'

/* Group by location  and the number of people from every location
1. Count grouped by location.
2. Fetch locations having more than 100 people */

SELECT location AS student_location FROM students; /* select location column as student location*/

SELECT location, COUNT(*) FROM students GROUP BY location;

SELECT location, COUNT(*) FROM students GROUP BY location ORDER BY count  DESC; /* Most are from the UK-309*/

SELECT location, COUNT(*) FROM students GROUP BY location HAVING COUNT(*) > 100 ORDER BY location  DESC;

-- Query the funds column

SELECT funds,count(*) FROM students GROUP BY funds;
SELECT funds,count(*) FROM students GROUP BY funds ORDER BY count DESC;

/* It can  be seen  that  most  students were fully  funded
Since there  are  those who were partially funded and those who where half funded let us check  them*/

SELECT * FROM students WHERE funds = 'Partially Funded';

/*1. From which location were most students partially funded
  2. What  were their qualifications */

SELECT location,count(*) FROM students WHERE funds = 'Partially Funded' GROUP BY location ORDER BY count DESC;

SELECT degrees,count(*)  FROM students WHERE funds = 'Partially Funded' GROUP BY degrees ORDER BY count DESC; 

/*Most of  those who were  fully funded had masters
See*/

--1. list of Masters students who are partially funded
SELECT * FROM students WHERE (funds = 'Partially Funded' AND degrees = 'Master');

--2. Location with most students  who are partially funded

SELECT location,count(*) FROM students WHERE (funds = 'Partially Funded' AND degrees = 'Master') GROUP BY location;