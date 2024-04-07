SELECT p.payment_id, ren.rental_id, p.amount, ren.return_date, p.payment_date
FROM sakila1_59.rental AS ren
         INNER JOIN sakila1_59.payment p ON ren.rental_id = p.rental_id;


# SELECT ren.rental_id, p.rental_id, ren.*, p.*
# FROM sakila1_59.rental AS ren
# INNER JOIN sakila1_59.payment AS p ON ren.rental_id = p.rental_id;

SELECT *
FROM sakila1_59.payment;

SELECT p.payment_id, ren.rental_id, p.amount, ren.return_date, p.payment_date
FROM sakila1_59.rental AS ren
         INNER JOIN sakila1_59.payment p USING (rental_id);

SELECT i.inventory_id, ren.rental_id, i.film_id
FROM sakila1_59.rental AS ren
         INNER JOIN sakila1_59.inventory i on ren.inventory_id = i.inventory_id;

SELECT i.inventory_id, f.film_id, f.title, f.description, f.release_year
FROM sakila1_59.film AS f
         INNER JOIN sakila1_59.inventory i ON f.film_id = i.film_id;


SELECT i.inventory_id
FROM sakila1_59.film AS f
         INNER JOIN sakila1_59.inventory AS i ON i.film_id = f.film_id;

SELECT r.rental_id,
       f.film_id,
       f.title       AS film_title,
       f.description AS film_description,
       f.rating      AS film_rating,
       f.rental_rate,
       r.rental_date,
       p.payment_date,
       p.amount      AS payment_amount
FROM sakila1_59.film AS f
         INNER JOIN sakila1_59.inventory AS i ON i.film_id = f.film_id
         INNER JOIN sakila1_59.rental r ON i.inventory_id = r.inventory_id
         INNER JOIN sakila1_59.payment p ON r.rental_id = p.rental_id;


SELECT *
FROM sakila1_59.rental AS r
         LEFT JOIN tasks1_59.payment AS p USING (rental_id)
WHERE p.payment_id IS NULL;

SELECT *
FROM tasks1_59.payment AS p
         RIGHT JOIN sakila1_59.rental AS r USING (rental_id)
WHERE p.payment_id IS NULL;

# podaj imię i nazwisko wszystkich co kochają dramy
SELECT DISTINCT cust.first_name, cust.last_name
FROM sakila1_59.customer AS cust
         INNER JOIN sakila1_59.rental r on cust.customer_id = r.customer_id
         INNER JOIN sakila1_59.inventory i on r.inventory_id = i.inventory_id
         INNER JOIN sakila1_59.film f on i.film_id = f.film_id
         INNER JOIN sakila1_59.film_category fc on f.film_id = fc.film_id
         INNER JOIN sakila1_59.category c on fc.category_id = c.category_id
WHERE c.name = 'Documentary'
ORDER BY first_name, last_name;

select *
from category;

SELECT *
FROM tasks1_59.city_country AS cc;


SELECT *
FROM sakila1_59.country AS c;

SELECT *
FROM tasks1_59.city_country AS cc
         INNER JOIN sakila1_59.country c on cc.country_id = c.country_id;


UPDATE tasks1_59.city_country AS cc
    INNER JOIN sakila1_59.country c on cc.country_id = c.country_id
SET cc.country = c.country
WHERE cc.country IS NULL;

SELECT *
FROM sakila1_59.country;

SELECT *
FROM sakila1_59.actor;

UPDATE sakila1_59.actor
SET first_name = 'JAROSŁAW'
WHERE actor_id = 1;


DELETE
FROM sakila1_59.actor
WHERE actor_id = 1;


SELECT *
FROM tasks1_59.films_to_be_cleaned AS fc
         INNER JOIN sakila1_59.film_category f on fc.film_id = f.film_id
WHERE f.category_id IN (1, 5, 7, 9)
  AND fc.length < 60
  AND fc.rating NOT IN ("NC-17", "PG");


DELETE fc
FROM tasks1_59.films_to_be_cleaned AS fc
         INNER JOIN sakila1_59.film_category f on fc.film_id = f.film_id
WHERE f.category_id IN (1, 5, 7, 9)
  AND fc.length < 60
  AND fc.rating NOT IN ("NC-17", "PG");


INSERT INTO tasks1_59.california_payments
SELECT p.*
FROM sakila1_59.payment p
INNER JOIN sakila1_59.customer c on p.customer_id = c.customer_id
INNER JOIN sakila1_59.address a on c.address_id = a.address_id
WHERE a.district = "California";


SELECT *
FROM sakila1_59.payment p
INNER JOIN sakila1_59.customer c on p.customer_id = c.customer_id
INNER JOIN sakila1_59.address a on c.address_id = a.address_id
WHERE a.district = "California";


SELECT *
FROM sakila1_59.address
WHERE district = "California";

SELECT *
FROM tasks1_59.california_payments;

SELECT DISTINCT a.district
FROM tasks1_59.california_payments AS cp
INNER JOIN sakila1_59.customer c on cp.customer_id = c.customer_id
INNER JOIN sakila1_59.address a on c.address_id = a.address_id;


SELECT *
FROM tasks1_59.school;

SELECT *
FROM tasks1_59.class;

SELECT *
FROM tasks1_59.child;

DELETE
FROM tasks1_59.school
WHERE school_id = 2;

SELECT *
FROM tasks1_59.school
WHERE school_id = 2;

SELECT *
FROM tasks1_59.class
WHERE school_id = 2;

SELECT DISTINCT class_id
FROM tasks1_59.child;


USE information_schema;
SELECT
    UNIQUE_CONSTRAINT_SCHEMA,
    TABLE_NAME,
    REFERENCED_TABLE_NAME,
    DELETE_RULE
FROM
    referential_constraints
WHERE delete_rule = 'CASCADE' AND UNIQUE_CONSTRAINT_SCHEMA = 'tasks1_59';

SELECT *
FROM referential_constraints;



-- Skrypt do wygenerowania danych jeszcze raz w razie potrzeby

USE tasks;

-- tabela school
insert into school values (1,'School 1');
insert into school values (2,'School 2');
insert into school values (3,'School 3');
insert into school values (4,'School 4');
insert into school values (5,'School 5');

-- tabela class
insert into class values (1,1,'Class 1','Jan');
insert into class values (2,1,'Class 2','Maria');
insert into class values (3,1,'Class 3','Jarosław');
insert into class values (4,1,'Class 4','Donald');
insert into class values (5,1,'Class 5','Cookiz');
insert into class values (6,1,'Class 6','Janusz');
insert into class values (7,2,'Class 7','Sławomir');
insert into class values (8,2,'Class 8','Vateusz');
insert into class values (9,2,'Class 9','Adrian');
insert into class values (10,2,'Class 10','Jacek');
insert into class values (11,3,'Class 11','Kaja');
insert into class values (12,3,'Class 12','Natalia');
insert into class values (13,3,'Class 13','Michał');
insert into class values (14,3,'Class 14','Wacław');
insert into class values (15,3,'Class 15','Bogumił');
insert into class values (16,4,'Class 16','Hubert');
insert into class values (17,4,'Class 17','Marcin');
insert into class values (18,4,'Class 18','Marian');
insert into class values (19,4,'Class 19','Juliusz');
insert into class values (20,5,'Class 20','Adam');

-- tabela child
insert into child values (1,1,'Child 1');
insert into child values (2,1,'Child 2');
insert into child values (3,1,'Child 3');
insert into child values (4,1,'Child 4');
insert into child values (5,1,'Child 5');
insert into child values (6,1,'Child 6');
insert into child values (7,1,'Child 7');
insert into child values (8,1,'Child 8');
insert into child values (9,1,'Child 9');
insert into child values (10,1,'Child 10');
insert into child values (11,2,'Child 11');
insert into child values (12,2,'Child 12');
insert into child values (13,2,'Child 13');
insert into child values (14,2,'Child 14');
insert into child values (15,2,'Child 15');
insert into child values (16,2,'Child 16');
insert into child values (17,2,'Child 17');
insert into child values (18,3,'Child 18');
insert into child values (19,3,'Child 19');
insert into child values (20,3,'Child 20');
insert into child values (21,3,'Child 21');
insert into child values (22,3,'Child 22');
insert into child values (23,3,'Child 23');
insert into child values (24,3,'Child 24');
insert into child values (25,4,'Child 25');
insert into child values (26,4,'Child 26');
insert into child values (27,4,'Child 27');
insert into child values (28,4,'Child 28');
insert into child values (29,4,'Child 29');
insert into child values (30,4,'Child 30');
insert into child values (31,5,'Child 31');
insert into child values (32,5,'Child 32');
insert into child values (33,5,'Child 33');
insert into child values (34,5,'Child 34');
insert into child values (35,5,'Child 35');
insert into child values (36,6,'Child 36');
insert into child values (37,6,'Child 37');
insert into child values (38,6,'Child 38');
insert into child values (39,6,'Child 39');
insert into child values (40,6,'Child 40');
insert into child values (41,6,'Child 41');
insert into child values (42,6,'Child 42');
insert into child values (43,6,'Child 43');
insert into child values (44,7,'Child 44');
insert into child values (45,7,'Child 45');
insert into child values (46,7,'Child 46');
insert into child values (47,7,'Child 47');
insert into child values (48,7,'Child 48');
insert into child values (49,7,'Child 49');
insert into child values (50,7,'Child 50');
insert into child values (51,7,'Child 51');
insert into child values (52,7,'Child 52');
insert into child values (53,7,'Child 53');
insert into child values (54,8,'Child 54');
insert into child values (55,8,'Child 55');
insert into child values (56,8,'Child 56');
insert into child values (57,8,'Child 57');
insert into child values (58,8,'Child 58');
insert into child values (59,8,'Child 59');
insert into child values (60,8,'Child 60');
insert into child values (61,8,'Child 61');
insert into child values (62,8,'Child 62');
insert into child values (63,8,'Child 63');
insert into child values (64,8,'Child 64');
insert into child values (65,9,'Child 65');
insert into child values (66,9,'Child 66');
insert into child values (67,9,'Child 67');
insert into child values (68,9,'Child 68');
insert into child values (69,9,'Child 69');
insert into child values (70,9,'Child 70');
insert into child values (71,9,'Child 71');
insert into child values (72,9,'Child 72');
insert into child values (73,9,'Child 73');
insert into child values (74,9,'Child 74');
insert into child values (75,10,'Child 75');
insert into child values (76,10,'Child 76');
insert into child values (77,10,'Child 77');
insert into child values (78,10,'Child 78');
insert into child values (79,10,'Child 79');
insert into child values (80,10,'Child 80');
insert into child values (81,10,'Child 81');
insert into child values (82,10,'Child 82');
insert into child values (83,10,'Child 83');
insert into child values (84,10,'Child 84');
insert into child values (85,10,'Child 85');
insert into child values (86,10,'Child 86');
insert into child values (87,10,'Child 87');
insert into child values (88,10,'Child 88');
insert into child values (89,10,'Child 89');
insert into child values (90,10,'Child 90');
insert into child values (91,10,'Child 91');
insert into child values (92,10,'Child 92');
insert into child values (93,11,'Child 93');
insert into child values (94,11,'Child 94');
insert into child values (95,11,'Child 95');
insert into child values (96,11,'Child 96');
insert into child values (97,11,'Child 97');
insert into child values (98,11,'Child 98');
insert into child values (99,11,'Child 99');
insert into child values (100,11,'Child 100');
insert into child values (101,12,'Child 101');
insert into child values (102,12,'Child 102');
insert into child values (103,12,'Child 103');
insert into child values (104,12,'Child 104');
insert into child values (105,12,'Child 105');
insert into child values (106,12,'Child 106');
insert into child values (107,13,'Child 107');
insert into child values (108,13,'Child 108');
insert into child values (109,13,'Child 109');
insert into child values (110,13,'Child 110');
insert into child values (111,13,'Child 111');
insert into child values (112,13,'Child 112');
insert into child values (113,13,'Child 113');
insert into child values (114,13,'Child 114');
insert into child values (115,14,'Child 115');
insert into child values (116,14,'Child 116');
insert into child values (117,14,'Child 117');
insert into child values (118,14,'Child 118');
insert into child values (119,14,'Child 119');
