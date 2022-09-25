# Reorganizando a tabela tb_vendas
SELECT
COALESCE(empID, 'Total') AS empID,
SUM( IF(ano='2020', valor_venda, 0) ) AS '2020',
SUM( IF(ano='2021', valor_venda, 0) ) AS '2021',
SUM( IF(ano='2022', valor_venda, 0) ) AS '2022'
FROM tb_vendas
GROUP BY empID WITH ROLLUP;