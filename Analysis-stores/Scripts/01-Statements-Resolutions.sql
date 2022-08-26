# Número de hubs por cidade
SELECT DISTINCT COUNT(h.hub_name), h.hub_city
FROM hubs as h
GROUP BY h.hub_city;

# Número de pedidos por status
SELECT DISTINCT COUNT(o.order_id), o.order_status
FROM orders o
GROUP BY o.order_status;

# Número de lojas por cidade dos hubs
SELECT DISTINCT COUNT(s.store_name), h.hub_city
FROM hubs h, stores s
WHERE h.hub_id = s.hub_id
GROUP BY h.hub_city;

# Qual é o maior e o menor valor de pagamento registrado?
SELECT MIN(p.payment_amount), MAX(p.payment_amount)
FROM payments as p;

# Qual tipo de driver fez o maior número de entregas?
SELECT COUNT(de.delivery_id), dr.driver_type
FROM deliveries de, drivers dr
WHERE de.driver_id = dr.driver_id
GROUP BY dr.driver_type;

# Qual a distância média das entregas por tipo de driver?
SELECT ROUND(AVG(de.delivery_distance_meters),2), dr.driver_modal
FROM deliveries de, drivers dr
WHERE de.driver_id = dr.driver_id
GROUP BY dr.driver_modal;

# Qual a média de valor de pedido por loja, em ordem decrescente?
SELECT ROUND(AVG(o.order_amount),2), s.store_name
FROM orders o, stores s
WHERE o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY o.order_amount DESC;

# Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?
SELECT count(o.order_id)
FROM orders o
LEFT JOIN stores s
ON o.store_id = s.store_id
WHERE s.store_name = null;

# Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?
SELECT sum(order_amount), channel_name
FROM channels c, orders o
WHERE c.channel_id = o.channel_id
AND c.channel_name = 'FOOD PLACE'
GROUP BY c.channel_name
ORDER BY c.channel_name ASC;

# Quantos pagamentos foram cancelados (chargeback)?
SELECT count(p.payment_status), p.payment_status
FROM payments p
WHERE p.payment_status = 'chargeback'
GROUP BY p.payment_status;

# Qual foi o valor médio dos pagamentos cancelados (chargeback)?
SELECT ROUND(avg(p.payment_amount),2), p.payment_status
FROM payments p
WHERE p.payment_status = 'chargeback'
GROUP BY p.payment_status;

# Qual a média do valor de pagamento por método de pagamento (payment_method) em ordem decrescente?
SELECT ROUND(avg(p.payment_amount),2), p.payment_status
FROM payments p
GROUP BY p.payment_status
ORDER BY p.payment_status DESC;

# Quais métodos de pagamento tiveram valor médio superior a 100? 
SELECT ROUND(AVG(p.payment_amount),2) as tktmedio, p.payment_method
FROM payments p
GROUP BY p.payment_method
HAVING tktmedio > 100;

# Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) 
#e tipo de canal (channel_type)?
SELECT ROUND(AVG(o.order_amount),2), h.hub_state, s.store_segment, c.channel_type
FROM orders o, hubs h, stores s, channels c
WHERE o.channel_id = c.channel_id
AND o.store_id = s.store_id
AND h.hub_id = s.hub_id
GROUP BY h.hub_state, s.store_segment, c.channel_type;

# Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type) 
#teve média de valor de pedido (order_amount) maior que 450?
SELECT ROUND(AVG(o.order_amount),2) AS media_pedido, h.hub_state, s.store_segment, c.channel_type
FROM hubs h, stores s, channels c, orders o
WHERE h.hub_id = s.hub_id
AND c.channel_id = o.channel_id
AND o.store_id = s.store_id
GROUP BY h.hub_state, s.store_segment, c.channel_type
HAVING media_pedido > 450;

# Qual  o  valor  total  de  pedido  (order_amount)  por  estado  do  hub  (hub_state), 
# segmento  da  loja  (store_segment)  e  tipo  de  canal  (channel_type)?  
# Demonstre  os  totais intermediários e formate o resultado.
SELECT
IF(GROUPING(h.hub_state), "Total Hub State", h.hub_state) as Hub_State,
IF(GROUPING(s.store_segment), "Total Segment", s.store_segment) as Store_Segment,
IF(GROUPING(c.channel_type), "Total Canal", c.channel_type) as Channel_Type,
 FORMAT(SUM(o.order_amount), 'C', 'pt-br') as valor
FROM orders o, hubs h, stores s, channels c
WHERE h.hub_id = s.hub_id
AND c.channel_id = o.channel_id
AND o.store_id = s.store_id
GROUP BY h.hub_state, s.store_segment, c.channel_type with rollup
ORDER BY GROUPING(h.hub_state, s.store_segment, c.channel_type) DESC;

# Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 'FOOD',  
#tipo de canal Marketplace e foi cancelado, qual foi a média de valor do  pedido (order_amount)?
SELECT ROUND(AVG(o.order_amount), 2) as tkt_medio
FROM hubs h, stores s, channels c, orders o, payments p
WHERE h.hub_id = s.hub_id
AND c.channel_id = o.channel_id
AND o.store_id = s.store_id
AND o.payment_order_id = p.payment_order_id;

# Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state 
# teve total de valor do pedido superior a 100.000?
SELECT sum(o.order_amount) as total_pedido, h.hub_state 
FROM hubs h, stores s, channels c, orders o, payments p
WHERE h.hub_id = s.hub_id
AND c.channel_id = o.channel_id
AND o.store_id = s.store_id
AND o.payment_order_id = p.payment_order_id
AND s.store_segment = 'GOOD'
AND c.channel_type = 'MARKETPLACE'
AND p.payment_status = 'CHARGEBACK'
GROUP BY h.hub_state
HAVING total_pedido > 100000;