--PART A--Pizza Metrics--


--Q.How many pizzas were ordered?
SELECT count(order_id) as total_orders
FROM public.cot

--Q.How many unique customer orders were made?

SELECT count(DISTINCT order_id) as total_orders
FROM  public.cot

--Q.How many successful orders were delivered by each runner?
SELECT 
  runner_id, 
  COUNT(order_id) AS successful_orders
FROM  public.rot
WHERE cancellation is null
GROUP BY runner_id;


--Q.How many of each type of pizza was delivered?
SELECT COUNT(cot.order_id) as total_orders,pizza_name
FROM public.cot
JOIN pizza_runner.pizza_names on pizza_names.pizza_id = cot.pizza_id
JOIN public.rot on cot.order_id = rot.order_id
WHERE rot.cancellation is null
GROUP by pizza_name

--Q.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, COUNT(pizza_name) as total_orders,pizza_name
FROM public.cot
JOIN pizza_runner.pizza_names on pizza_names.pizza_id = cot.pizza_id
JOIN public.rot on cot.order_id = rot.order_id
GROUP by customer_id,pizza_name
ORDER BY customer_id


--Q.What was the maximum number of pizzas delivered in a single order?
SELECT order_id, count(pizza_id)
FROM cot
GROUP BY order_id
ORDER BY count(pizza_id) DESC
LIMIT 1


/*Q.For each customer, how many delivered pizzas had at least 1 change 
and how many had no changes?*/
SELECT *
FROM cot









--Q.How many pizzas were delivered that had both exclusions and extras?
--Q.What was the total volume of pizzas ordered for each hour of the day?
--Q.What was the volume of orders for each day of the week?