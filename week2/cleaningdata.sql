/*
===============cleaning data====================
================================================ */

--in table customers_orders exclusion and extras table containnull' keywords
-- we can clean them by creating a temp table
-- customer order table
	SELECT 
	order_id, customer_id, pizza_id,order_time,
	CASE
		WHEN exclusions = 'null' THEN ''
		else exclusions
	END AS exclusions,
	CASE
		WHEN extras is null or extras like 'null' THEN ''
		else extras
	END AS extras
	INTO cot
	FROM pizza_runner.customer_orders




--in table customers_orders exclusion and extras table contain 'null' keywords
-- we can clean them by creating a new table
-- we also change the data types.
-- runners order table - rot
	SELECT 
    order_id,
    runner_id,
    CAST(CASE 
        WHEN pickup_time = 'null' THEN null
        ELSE pickup_time
    END as timestamp) as pickup_time,
    CAST(CASE 
        WHEN distance = 'null' THEN null
        ELSE TRIM('km' from distance)
    END as float) as distance,
    CAST(CASE
        WHEN duration = 'null' THEN null
        ELSE SUBSTRING(duration, 1, 2)
    END as int)as duration,
    CASE
        WHEN cancellation in ('null', '') THEN null
        ELSE cancellation
END as cancellation
INTO rot
FROM pizza_runner.runner_orders;

alter table public.runner_orders_temp
alter duration type int














