SELECT *
FROM sakila1_59.rental
WHERE YEAR(rental_date) = 2005;

SELECT *
FROM sakila1_59.rental
WHERE DATE(rental_date) = "2005-05-24";

SELECT *
FROM sakila1_59.rental
WHERE rental_date > "2005-06-30";

select *
from staff;


SELECT staff_id
FROM sakila1_59.staff
WHERE first_name = "Jon";

SELECT rental_id, return_date, staff_id
FROM sakila1_59.rental
WHERE (return_date BETWEEN "2005-06-30" AND "2005-08-31 23:59:59")
  AND staff_id IN (SELECT staff_id
                   FROM sakila1_59.staff
                   WHERE first_name IN ("Mike", "Jon"));
# ORDER BY staff_id;


select *
from sakila1_59.customer;

SELECT first_name, last_name, active
FROM sakila1_59.customer
WHERE active = 1;

SELECT first_name, last_name, active
FROM sakila1_59.customer
WHERE active = 1
   OR first_name LIKE "ANDRE%"
ORDER BY first_name;

SELECT first_name, last_name, active
FROM sakila1_59.customer
WHERE first_name LIKE "__D%"
ORDER BY first_name;

select *
from customer;

SELECT create_date, first_name, last_name, email, active
FROM sakila1_59.customer
WHERE (store_id = 1 AND active = 0);

SELECT create_date, first_name, last_name, email, active
FROM sakila1_59.customer
WHERE (email NOT LIKE "%sakilacustomer.org");


SELECT DISTINCT create_date
FROM sakila1_59.customer;

select *
from sakila1_59.actor_analytics;

SELECT first_name, last_name, films_amount
FROM sakila1_59.actor_analytics
WHERE films_amount > 25;

SELECT first_name, last_name, films_amount, avg_film_rate
FROM sakila1_59.actor_analytics
WHERE films_amount > 20
  AND avg_film_rate > 3.3;

SELECT first_name, last_name, films_amount, avg_film_rate
FROM sakila1_59.actor_analytics
WHERE (films_amount > 20 AND avg_film_rate > 3.3)
   OR actor_payload > 2000;

SELECT ren.rental_id,
       ren.rental_date AS date_of_rental,
       ren.customer_id,
       ren.inventory_id,
       ren.return_date AS date_of_rental_return
FROM sakila1_59.rental ren;

select rental_id    AS "id wypożyczenia",
       inventory_id AS "id przedmiotu"
from sakila1_59.rental;


select *
from payment;

SELECT payment_date,
       DATE_FORMAT(payment_date, "%Y/%m/%d")              AS pd1,
       DATE_FORMAT(payment_date, "%Y-%M-%w")              AS pd2,
       DATE_FORMAT(payment_date, "%Y-%v")                 AS pd3,
       DATE_FORMAT(payment_date, "%Y/%m/%d@%a")           AS pd4,
       DATE_FORMAT(payment_date, "%Y/%m/%d@%w")           AS pd5,
       DATE_FORMAT(payment_date, GET_FORMAT(DATE, 'USA')) AS pd6,
       DATE_FORMAT(payment_date, GET_FORMAT(DATE, 'EUR')) AS pd6
FROM sakila1_59.payment;


SELECT GET_FORMAT(DATE, '');


select title, price, length, LEAST(price, length)
from sakila1_59.film_list;

select title, price, length, LEAST(price, length, rating)
from sakila1_59.film_list;

# 'A', 'b', 'c'
SELECT LEAST('C', '2.99', '3');


SELECT first_name
FROM sakila1_59.customer
UNION
SELECT first_name
FROM sakila1_59.actor
UNION
SELECT first_name
FROM sakila1_59.staff;

SELECT 'ANDRZEJ'
UNION
SELECT 'DARIUSZ'
UNION
SELECT 'ANDRZEJ';

SELECT category
FROM sakila1_59.nicer_but_slower_film_list
UNION
SELECT category
FROM sakila1_59.nicer_but_slower_film_list;


select *
from sakila1_59.sales_by_store;

select *
from sakila1_59.sales_total;

SELECT store.*
FROM sakila1_59.sales_by_store AS store
WHERE 1 = (SELECT 1
           FROM sakila1_59.sales_total AS total
           WHERE store.total_sales / total.total_sales > 0.5);



SELECT *
FROM sakila1_59.rating_analytics;



SELECT *
FROM sakila1_59.rating_analytics
WHERE avg_rental_rate > (SELECT avg_rental_rate FROM sakila1_59.rating_analytics AS r2 LIMIT 1 OFFSET 5);

SELECT *
FROM sakila1_59.rating_analytics r1
WHERE r1.avg_rental_duration < (SELECT r2.avg_rental_duration
                                FROM sakila1_59.rating_analytics AS r2
                                WHERE r2.rating IS NULL);

# CTE - common table expression

WITH cte AS (SELECT r2.avg_rental_duration
             FROM sakila1_59.rating_analytics AS r2
             WHERE r2.rating IS NULL)
SELECT *
FROM sakila1_59.rating_analytics r1
WHERE r1.avg_rental_duration < (SELECT * FROM cte);


SELECT *
FROM sakila1_59.rating_analytics
WHERE rating IN (SELECT rating FROM sakila1_59.rating WHERE id_rating = 3);


SELECT *
FROM sakila1_59.rating_analytics
WHERE rating IN (SELECT rating FROM sakila1_59.rating WHERE id_rating IN (2, 3, 5));

# SELECT * FROM sakila1_59.rating WHERE id_rating IN (2, 3, 5);


# 1. Pobierz wszystkie dane z tabeli rating_analytics
SELECT *
FROM sakila1_59.rating_analytics;
# 2. Zostaw tylko rating z nazwą
SELECT *
FROM sakila1_59.rating_analytics
WHERE rating IS NOT NULL;
# 3. Posortuj dane (ORDER BY) po kolumnie rentals malejące
SELECT *
FROM sakila1_59.rating_analytics
WHERE rating IS NOT NULL
ORDER BY rentals DESC;
# 4. Ogranicz liczbę wyników do jednego najbardziej wyczesanego
SELECT *
FROM sakila1_59.rating_analytics
WHERE rating IS NOT NULL
ORDER BY rentals DESC
LIMIT 1;



SELECT rating
FROM sakila1_59.rating_analytics
ORDER BY avg_film_length
LIMIT 1;


WITH actor_var AS (SELECT actor.actor_id
                   FROM sakila1_59.actor
                   WHERE actor.first_name = 'ZERO'
                     AND actor.last_name = 'CAGE')
SELECT *
FROM sakila1_59.actor_analytics
WHERE actor_id IN (SELECT * FROM actor_var);

SELECT *
FROM sakila1_59.actor_analytics;

SELECT actor.actor_id
FROM sakila1_59.actor;


SELECT *
FROM sakila1_59.actor_analytics
WHERE films_amount >= 30;


WITH actor_var AS (SELECT *
                   FROM sakila1_59.actor_analytics
                   WHERE films_amount >= 30)
SELECT *
FROM sakila1_59.actor
WHERE actor_id IN (SELECT actor_var.actor_id FROM actor_var);


SELECT *
FROM sakila1_59.actor_analytics
WHERE longest_movie_duration in (184, 174, 176, 164);



WITH selected_actors AS (SELECT *
                         FROM sakila1_59.actor_analytics
                         WHERE longest_movie_duration in (184, 174, 176, 164)),
     actor_film AS (SELECT *
                    FROM sakila1_59.film_actor
                    WHERE actor_id IN (SELECT actor_id
                                       FROM selected_actors))
SELECT *
FROM sakila1_59.film
WHERE film_id IN (SELECT film_id FROM actor_film);


# Wyświetl imiona i nazwiska ludzi kochających dramy

SELECT first_name, last_name, email
FROM sakila1_59.customer
WHERE customer_id IN (SELECT customer_id
                      FROM sakila1_59.rental
                      WHERE inventory_id IN (SELECT inventory_id
                                             FROM sakila1_59.inventory
                                             WHERE film_id IN (SELECT film_id
                                                               FROM film
                                                               WHERE film.film_id IN (SELECT film_id
                                                                                      FROM film_category
                                                                                      WHERE category_id IN (SELECT category_id
                                                                                                            FROM category
                                                                                                            WHERE name = 'DRAMA')))))
ORDER BY first_name, last_name
LIMIT 100;

SELECT * FROM sakila1_59.category;



















