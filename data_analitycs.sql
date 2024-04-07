SELECT sum(amount)
FROM payment;
SELECT count(amount)
FROM payment;


# suma płatności całkowitej przez klientów posortowane od największej
SELECT customer_id, sum(amount) AS amount_agg
FROM payment
GROUP BY customer_id
ORDER BY amount_agg DESC;


SELECT staff_id, sum(amount) AS amount_agg
FROM payment
GROUP BY staff_id
ORDER BY amount_agg DESC;


SELECT customer_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       sum(amount)                        AS amount_agg
FROM payment
GROUP BY customer_id, payment_month
ORDER BY customer_id, amount_agg DESC;


SELECT staff_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       sum(amount)                        AS amount_agg
FROM payment
GROUP BY staff_id, payment_month
ORDER BY staff_id, amount_agg DESC;


#
CREATE OR REPLACE VIEW payment_report AS
SELECT c.first_name,
       c.last_name,
       c.email,
       SUM(p.amount)       AS payments_total,
       COUNT(p.amount)     AS payments_amount,
       AVG(p.amount)       AS payments_average,
       MAX(p.amount)       AS payments_max,
       MAX(p.payment_date) AS last_payment_date
FROM payment AS p
         INNER JOIN customer AS c USING (customer_id)
GROUP BY c.customer_id;

SELECT *
FROM payment_report;

SELECT sum(payments_total)
FROM payment_report;

SELECT sum(amount)
FROM payment;

SELECT (SELECT sum(payments_total) FROM payment_report) = (SELECT sum(amount) FROM payment);


CREATE TEMPORARY TABLE IF NOT EXISTS tmp_film_actors AS
SELECT f.film_id,
       f.title,
       count(fa.actor_id) as actors
FROM film_actor AS fa
         INNER JOIN film AS f ON fa.film_id = f.film_id
GROUP BY f.film_id;

# SELECT * FROM tmp_film_actors;

WITH cte AS (SELECT film_id,
                    count(actor_id) as actors
             FROM film_actor AS fa
             GROUP BY 1)
SELECT *
FROM cte as c
         INNER JOIN tmp_film_actors as tfa USING (film_id)
WHERE c.actors <> tfa.actors;

SELECT *
FROM film_actor;

SELECT film_id,
       count(actor_id) as actors
FROM film_actor AS fa
GROUP BY 1;


CREATE TEMPORARY TABLE IF NOT EXISTS tmp_film_rentals AS
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rentals
FROM film AS f
         INNER JOIN inventory AS i ON f.film_id = i.film_id
         INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id;

SELECT title, rentals
FROM tmp_film_rentals
ORDER BY rentals DESC
LIMIT 1;

SELECT *
FROM tmp_film_rentals;

WITH cte AS (SELECT i.film_id, COUNT(r.rental_id) as rentals
             FROM inventory AS i
                      INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
             GROUP BY 1)
SELECT *
FROM cte AS c
         INNER JOIN tmp_film_rentals AS tfr ON c.film_id = tfr.film_id
WHERE c.rentals <> tfr.rentals;

DROP TABLE IF EXISTS tmp_film_payments;
CREATE TEMPORARY TABLE tmp_film_payments
SELECT f.film_id, sum(p.amount) AS payments
FROM film AS f
         INNER JOIN inventory AS i ON f.film_id = i.film_id
         INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
         INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY f.film_id;

SELECT *
FROM tmp_film_payments;

SELECT COUNT(*)
FROM payment;
SELECT COUNT(*)
FROM payment
WHERE rental_id IS NOT NULL;

SELECT (SELECT SUM(amount) FROM payment WHERE rental_id IS NOT NULL) = (SELECT SUM(payments) FROM tmp_film_payments);


SELECT fa.title,
       fa.actors,
       tfp.payments,
       tfr.rentals,
       tfp.payments / fa.actors   AS hajs,
       tfp.payments / tfr.rentals AS sredni_hajs_za_wypozyczenie
FROM tmp_film_actors fa
         INNER JOIN tmp_film_rentals tfr on fa.film_id = tfr.film_id
         INNER JOIN tmp_film_payments tfp on fa.film_id = tfp.film_id
ORDER BY tfp.payments DESC, hajs DESC
LIMIT 10;


SELECT st.store_id, SUM(p.amount) AS sales
FROM inventory i
         INNER JOIN rental r USING (inventory_id)
         INNER JOIN payment p USING (rental_id)
         INNER JOIN store st USING (store_id)
         INNER JOIN staff sf USING (store_id)
GROUP BY st.store_id;

SELECT sf.staff_id, SUM(p.amount) AS sales
FROM inventory i
         INNER JOIN rental r USING (inventory_id)
         INNER JOIN payment p USING (rental_id)
         INNER JOIN store st USING (store_id)
         INNER JOIN staff sf USING (store_id)
GROUP BY sf.staff_id;


SELECT st.store_id, sf.staff_id, SUM(p.amount) AS sales
FROM inventory i
         INNER JOIN rental r USING (inventory_id)
         INNER JOIN payment p USING (rental_id)
         INNER JOIN store st USING (store_id)
         INNER JOIN staff sf USING (store_id)
GROUP BY st.store_id, sf.staff_id
WITH ROLLUP;
# ORDER BY 1, 2;


SELECT customer_id,
       staff_id,
       SUM(amount) AS s
FROM payment
WHERE customer_id < 4
GROUP BY customer_id, staff_id
WITH ROLLUP
HAVING s > 70;


SELECT *
FROM actor_analytics;

SELECT *, ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn
FROM payment;


SELECT *, ROW_NUMBER() OVER (ORDER BY avg_film_rate DESC) AS rating
FROM actor_analytics;


SELECT *,
       ROW_NUMBER() OVER (_order)                AS actor,
       MIN(avg_film_rate) OVER (_order)          AS min_cummulation,
       SUM(actor_payload) OVER (_order)          AS payload_cummulation,
       MAX(longest_movie_duration) OVER (_order) AS max_cummulation
FROM sakila1_59.actor_analytics
WINDOW _order AS (ORDER BY actor_id);


SELECT *,
       ROW_NUMBER() OVER (payload) / COUNT(1) OVER ()                 AS count_percent,
       SUM(actor_payload) OVER (payload) / SUM(actor_payload) OVER () as payload_percent
FROM actor_analytics
WINDOW payload AS (ORDER BY actor_payload DESC);


SELECT *,
       ROW_NUMBER() OVER (rental) AS _row_number,
       RANK() OVER (rental)       AS _rank,
       DENSE_RANK() OVER (rental) AS _dense_rank
FROM film_analytics
WINDOW rental AS (ORDER BY rentals DESC);

SELECT *,
       ROW_NUMBER() OVER (rental) AS _row_number,
       RANK() OVER (rental)       AS _rank,
       DENSE_RANK() OVER (rental) AS _dense_rank
FROM film_analytics
WINDOW rental AS (PARTITION BY rating ORDER BY rentals DESC);


SELECT DATEDIFF('2030-12-31', '2000-01-01');

WITH cte AS (SELECT ADDDATE('1999-12-31', ROW_NUMBER() over ()) AS date
             FROM payment
             LIMIT 11322)
SELECT date,
       EXTRACT(year from date)  as date_year,
       EXTRACT(month from date) as date_month,
       EXTRACT(day from date)   as date_day,
       DAYOFWEEK(date)          as day_of_week,
       WEEKOFYEAR(date)         as week_of_year,
       NOW()                    as last_update
FROM cte;


SELECT
    EXTRACT(year from payment_date) as payment_year,
    EXTRACT(month from payment_date) as payment_month,
    SUM(amount) as amount
FROM payment
GROUP BY 1, 2 WITH ROLLUP
ORDER BY 1, 2;
