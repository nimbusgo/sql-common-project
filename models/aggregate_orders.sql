{{
  config({    
    "materialized": "ephemeral"
  })
}}

WITH orders AS (

  SELECT * 
  
  FROM {{ source('samples.tpch', 'orders') }}

),

Aggregate_1 AS (

  {#Calculates total sales by order status to assess performance.#}
  SELECT 
    sum(o_totalprice) AS o_totalprice,
    any_value(o_orderstatus) AS o_orderstatus
  
  FROM orders AS in0
  
  GROUP BY o_orderstatus

),

aggregate_total_price AS (

  {#Summarizes total prices along with additional parameters and order statuses.#}
  SELECT 
    o_totalprice AS o_totalprice,
    '{{var("param_a")}}' AS o_param_a,
    o_orderstatus AS o_orderstatus
  
  FROM Aggregate_1 AS in0

),

filtered_orders_by_status AS (

  {#Filters orders based on a specific status for targeted analysis.#}
  SELECT * 
  
  FROM aggregate_total_price AS in0
  
  WHERE o_orderstatus = '{{var("order_status")}}'

)

SELECT *

FROM filtered_orders_by_status
