Overview:
•	Dataset used: Created dataset manually from scratch. Created a dataset which represents a wall climbing gym which is named Climber. There are four total tables in the dataset.
o	The first table consists of gold_user_signup which explains which users are gold. Gold users get personal trainers and free climbing gear/equipment.
o	The second table consists of product which has 3 unique product packages where p1 is the annual membership, p2 is a quarterly membership and p3 is a monthly membership.
o	The third table consists of the types of user IDs and the signup date.
o	The fourth table consists of the sales where user ID, product ID and created date are made. 
o	The dataset is created in MYSQL and Excel for a better understanding.

Code:
-- Create new database 

create database scratch

-- Create the table

CREATE TABLE goldusers_signup (
    userid INT,
    gold_signup_date DATE
);

-- Insert data into the table

INSERT INTO goldusers_signup (userid, gold_signup_date)
VALUES 
    (1, '2018-10-24'),
    (3, '2018-04-11');

-- Create second table called users    

CREATE TABLE users(userid integer,signup_date date); 

-- Inserting values into the users table

INSERT INTO users (userid, signup_date)
VALUES 
    (1, '2015-12-02'),
    (2, '2016-07-14'),
    (3, '2015-03-01');
    
-- Create third table called sales    

CREATE TABLE sales(userid integer,created_date date,product_id integer); 

-- Insert values into sales table

INSERT INTO sales (userid, created_date, product_id)
VALUES 
    (1, '2018-05-18', 2),
    (3, '2020-11-19', 1),
    (2, '2021-08-21', 3),
    (1, '2020-11-24', 2),
    (1, '2019-04-20', 3),
    (3, '2017-12-10', 2),
    (1, '2017-06-21', 1),
    (1, '2018-10-25', 3),
    (2, '2018-04-12', 1),
    (1, '2017-05-01', 2),
    (1, '2017-12-11', 1),
    (3, '2018-01-08', 1),
    (3, '2015-02-16', 2),
    (3, '2016-09-16', 2),
    (2, '2017-07-07', 2),
    (2, '2019-03-17', 3);

-- Create 4th table called products

CREATE TABLE product(product_id integer,product_name text,price integer); 

-- Insert values into the products table

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',970),
(2,'p2',830),
(3,'p3',320);

-- Checking all the table values

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- Total amount each customer spent on climber?

SELECT
    s.userid,
    SUM(p.price) AS Total_amount_spent
FROM
    sales s
INNER JOIN
    product p ON p.product_id = s.product_id
GROUP BY
    s.userid;


-- What is the duration, in days, of each customer's visits to the climber?

SELECT
    userid,
    COUNT(DISTINCT created_date) AS Distinct_days
FROM
    sales
GROUP BY
    userid;


-- Which product did each customer buy first?

select *,rank() over(partition by userid order by created_date) rnk from sales

SELECT
    *
FROM
    (
        SELECT
            *,
            RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
        FROM
            sales
    ) a
WHERE
    rnk = 1;


-- Which menu item had the highest number of purchases, and what is the total count of purchases for that item across all customers?

SELECT
    product_id
FROM
    sales
GROUP BY
    product_id
ORDER BY
    COUNT(product_id) DESC
LIMIT 1;


--  and what is the total count of purchases for that item across all customers?

SELECT
    userid,
    COUNT(product_id) AS count
FROM
    sales
WHERE
    product_id = (
        SELECT
            product_id
        FROM
            sales
        GROUP BY
            product_id
        ORDER BY
            COUNT(product_id) DESC
        LIMIT 1
    )
GROUP BY
    userid;


-- Which menu item was the most favored by each customer?

SELECT *
FROM
    (
        SELECT
            *,
            RANK() OVER (PARTITION BY userid ORDER BY count DESC) AS rnk
        FROM
            (
                SELECT
                    userid,
                    product_id,
                    COUNT(product_id) AS count
                FROM
                    sales
                GROUP BY
                    userid, product_id
            ) a
    ) b
WHERE
    rnk = 1;


-- Which menu item did the customer purchase after obtaining membership?

select * from
(select c.*,rank() over(partition by userid order by created_date) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date) c)d where rnk=1;

-- What are the total number of orders and the total amount spent by each member prior to their membership initiation?

select userid,count(created_date) order_purchased,sum(price) total_amount_spent from
(select c.*,d.price from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date) c inner join product d on c.product_id=d.product_id)e
group by userid;

-- If buying each prodcuts generates points for eg £5= 2 foods point and each product has different purchasing points 
-- for eg for p1 £5=1 climber point ,for p2 £10=5 climber point and p3 £5=1 climber point    £2=1 climber point
-- calculate points collected by each customers and for which product most points have been given till now.

select userid,sum(total_points)*2.5 total_money_earned from 
(select e.*,amount/points total_points from
(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amount from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e)f group by userid;

select * from 
(select *,rank() over(order by total_point_earned desc) rnk from
(select product_id,sum(total_points) total_point_earned from 
(select e.*,amount/points total_points from 
(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amount from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e)f group by product_id)f)g where rnk=1;

-- In the first one year after the customer joins the gold program(including thier join date) irrespective of what
-- the customer has purchased they earn 5 climber points for every £10 spent who earned more than 1 or 3
-- and what was thier points earnings in thier first year?
-- 1 clmr(climber point)= £2 & 0.5 fp=£1

SELECT 
    c.*,
    d.price * 0.5 AS total_points_earned
FROM (
    SELECT 
        a.userid,
        a.created_date,
        a.product_id,
        b.gold_signup_date
    FROM 
        sales a
    INNER JOIN
        goldusers_signup b ON a.userid = b.userid
                            AND a.created_date >= b.gold_signup_date
                            AND a.created_date <= DATE_ADD(b.gold_signup_date, INTERVAL 1 YEAR)
) c
INNER JOIN
    product d ON c.product_id = d.product_id;

-- Assign a ranking to each customer's transactions

SELECT
    *,
    RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
FROM
    sales;

-- Assign a ranking to all transactions made by members when they are climber Gold members. 
-- For transactions made by non-Gold members, mark the rank as "NA."

SELECT
    e.*,
    CASE WHEN rnk = 0 THEN 'na' ELSE CAST(rnk AS CHAR) END AS rnkk
FROM
    (
        SELECT
            c.*,
            CAST(
                CASE WHEN gold_signup_date IS NULL THEN 0
                     ELSE RANK() OVER (PARTITION BY userid ORDER BY created_date DESC)
                END AS UNSIGNED
            ) AS rnk
        FROM
            (
                SELECT
                    a.userid,
                    a.created_date,
                    a.product_id,
                    b.gold_signup_date
                FROM
                    sales a
                LEFT JOIN
                    goldusers_signup b ON a.userid = b.userid
                                      AND a.created_date >= b.gold_signup_date
            ) c
    ) e;










