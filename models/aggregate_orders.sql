{{
  config({    
    "materialized": "ephemeral"
  })
}}

{% set param_a = "def" %}

WITH orders AS (

  SELECT * 
  
  FROM {{ source('samples.tpch', 'orders') }}

),

Aggregate_1 AS (

  {#Calculates the total revenue generated from all orders.#}
  SELECT 
    sum(o_totalprice) AS o_totalprice
  
  FROM orders AS in0

),

aggregate_total_price AS (

  {#Summarizes total price while incorporating a specific parameter for further analysis.#}
  SELECT 
    o_totalprice AS o_totalprice,
    '{{var("param_a")}}' AS o_param_a
  
  FROM Aggregate_1 AS in0

)

SELECT *

FROM aggregate_total_price
