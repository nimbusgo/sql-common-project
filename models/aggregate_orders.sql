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

  {#Calculates the total revenue generated from all orders.#}
  SELECT 
    sum(o_totalprice) AS o_totalprice
  
  FROM orders AS in0

)

SELECT *

FROM Aggregate_1
