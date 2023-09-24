--What is the total amount each customer spent at the restaurant?
SELECT
	customer_id, sum(price) as total_amount_spent
FROM
	sales
JOIN 
	menu ON sales.product_id = menu.product_id
GROUP BY 
	customer_id 
ORDER BY 
	SUM(price) DESC

--How many days has each customer visited the restaurant?
SELECT
	customer_id, COUNT(DISTINCT order_date)
FROM
	sales
GROUP BY 
	customer_id 


--What was the first item from the menu purchased by each customer?

WITH all_sales AS (
	SELECT 
    sales.customer_id, 
    sales.order_date, 
    menu.product_name,
    DENSE_RANK() OVER (
      PARTITION BY sales.customer_id 
      ORDER BY sales.order_date) AS rank
  FROM sales
  JOIN menu
    ON sales.product_id = menu.product_id
)
-- IF WE USE ROW_NUMBER() HERE, THEN IT WILL GIVE RANK 2 TO THE SECOND ITEM ORDERED IN SAME DAY,
--SINCE WE DON'T KNOW THE TIME, IT IS BETTER TO USE DENSE RANK
SELECT 
  customer_id, 
  product_name
FROM ordered_sales
WHERE rank = 1
GROUP BY customer_id, product_name

--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
	product_name, count(sales.product_id) as total_times_purchased
FROM
	sales
JOIN 
	menu ON sales.product_id = menu.product_id
GROUP BY 
	product_name
ORDER BY 
	total_times_purchased DESC 
	LIMIT 1

--Which item was the most popular for each customer?

WITH POP AS(
	
SELECT
	customer_id, menu.product_name, COUNT(menu.product_id) AS order_count,
	DENSE_RANK() OVER (PARTITION BY customer_id order by COUNT(sales.customer_id) DESC) as rank
FROM
	sales
JOIN 
	menu ON sales.product_id = menu.product_id
	
GROUP BY sales.customer_id, menu.product_name
 )
 
SELECT 
  customer_id, 
  product_name, 
  order_count
FROM pop
WHERE rank = 1;

--Which item was purchased first by the customer after they became a member?
WITH cust_order_date AS(
SELECT 
sales.customer_id,menu.product_name,order_date,
ROW_NUMBER() OVER(PARTITION BY members.customer_id order by sales.order_date) as row_num
FROM 
members 
INNER JOIN sales ON sales.customer_id = members.customer_id
INNER JOIN menu ON sales.product_id = menu.product_id
where sales.order_date > members.join_date
)

SELECT 
customer_id,product_name,order_date
FROM 
cust_order_date
WHERE row_num = 1



--Which item was purchased just before the customer became a member?
WITH cust_order_date AS(
SELECT 
sales.customer_id,menu.product_name,order_date,
ROW_NUMBER() OVER(PARTITION BY members.customer_id order by sales.order_date DESC) as row_num
FROM 
members 
INNER JOIN sales ON sales.customer_id = members.customer_id
INNER JOIN menu ON sales.product_id = menu.product_id
where sales.order_date < members.join_date
)
SELECT 
customer_id,product_name,order_date
FROM 
cust_order_date
WHERE row_num = 1


--What is the total items and amount spent for each member before they became a member?
SELECT
	sales.customer_id, sum(price) as total_amount_spent , count(sales.product_id) as 
	total_products_bought
FROM
	sales
JOIN 
	menu ON sales.product_id = menu.product_id
JOIN 
	members ON sales.customer_id = members.customer_id
	
WHERE join_date > order_date

GROUP BY 
	sales.customer_id 
ORDER BY
sales.customer_id 

/*If each $1 spent equates to 10 points and sushi has a 2x points multiplier
how many points would each customer have?*/
WITH points_tab as (
SELECT product_id, 
	CASE 
	WHEN product_id = 1 THEN price*20
	ELSE price*10
	END AS points
FROM
	menu)

SELECT sales.customer_id, sum(points)
FROM sales
JOIN points_tab ON sales.product_id = points_tab.product_id
GROUP BY 
	sales.customer_id
ORDER BY sales.customer_id

/*In the first week after a customer joins the program (including their join date) -
they earn 2x points on all items, not just sushi - how many points do customer
A and B have at the end of January?*/

with new_date as (SELECT
sales.order_date,members.join_date,sales.product_id,price,sales.customer_id,
 DATE_TRUNC(
        'month', '2021-01-31'::DATE)
        + interval '1 month' 
        - interval '1 day' AS last_date

FROM members
JOIN SALES ON members.customer_id  = sales.customer_id  
JOIN menu ON menu.product_id  = sales.product_id
	WHERE sales.order_date <= '2021-01-31' and sales.order_date >= join_date)

SELECT new_date.customer_id, sum(CASE 
WHEN new_date.order_date between join_date and (join_date +6) then price*20
WHEN new_date.product_id = 1 THEN 20*PRICE
ELSE 10* price
END)AS PRICE_WEEK

FROM
new_date

group by new_date.customer_id
order by customer_id
----
















