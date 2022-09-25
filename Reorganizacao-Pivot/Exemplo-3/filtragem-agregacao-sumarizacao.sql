CREATE TABLE cap08.TB_PIPELINE_VENDAS (
  `Account` text,
  `Opportunity_ID` text,
  `Sales_Agent` text,
  `Deal_Stage` text,
  `Product` text,
  `Created_Date` text,
  `Close_Date` text,
  `Close_Value` text DEFAULT NULL
);

# Carregue o dataset3.csv na tabela anterior a partir do MySQL Workbench
# Cria a tabela
CREATE TABLE cap08.TB_VENDEDORES (
  `Sales_Agent` text,
  `Manager` text,
  `Regional_Office` text,
  `Status` text
);

# Carregue o dataset4.csv na tabela anterior a partir do MySQL Workbench

# Responda os itens abaixo com Linguagem SQL

# 1- Total de vendas
SELECT COUNT(*)
FROM tb_pipeline_vendas pv;

# 2- Valor total vendido
SELECT CAST(SUM(pv.Close_Value) AS DECIMAL(20,2)) AS Vendas_Won
FROM tb_pipeline_vendas pv;

# 3- Número de vendas concluídas com sucesso
SELECT COUNT(*) AS num_vendas_sucesso
FROM tb_pipeline_vendas pv
WHERE Deal_Stage = 'Won';

# 4- Média do valor das vendas concluídas com sucesso
SELECT ROUND(AVG(CAST(Close_Value AS DECIMAL(20, 2))),2) AS media_valor
FROM tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 5- Valor máximo vendido
SELECT MAX( CAST(Close_Value AS DECIMAL(20,2))) AS valor_maximo
FROM tb_pipeline_vendas;

# 6- Valor mínimo vendido entre as vendas concluídas com sucesso
SELECT MIN( CAST(Close_Value AS DECIMAL(20,2))) AS valor_maximo
FROM tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 7- Valor médio das vendas concluídas com sucesso por agente de vendas
SELECT 
Sales_Agent, 
ROUND(AVG( CAST(Close_Value AS UNSIGNED)), 2) AS Valor_Medio 
FROM tb_pipeline_vendas
WHERE Deal_Stage = 'Won'
GROUP BY Sales_Agent
ORDER BY Valor_Medio DESC;

# 8- Valor médio das vendas concluídas com sucesso por gerente do agente de vendas
SELECT 
v.Manager, 
ROUND(AVG( CAST(pv.Close_Value AS UNSIGNED)), 2) AS Valor_Medio 
FROM tb_pipeline_vendas pv, tb_vendedores v
WHERE Deal_Stage = 'Won'
AND pv.Sales_Agent = v.Sales_Agent
GROUP BY v.Manager
ORDER BY Valor_Medio DESC;

# 9- Total do valor de fechamento da venda por agente de venda e por conta das vendas concluídas com sucesso
SELECT Sales_Agent, Account, SUM(CAST(Close_Value AS UNSIGNED)) AS Soma_Vendas
FROM tb_pipeline_vendas
WHERE Deal_Stage = 'Won'
GROUP BY Sales_Agent, Account
ORDER BY Account;

# 10- Número de vendas por agente de venda para as vendas concluídas com sucesso e valor de venda superior a 1000
SELECT 
Sales_Agent,
COUNT(*) AS Num_Vendas
FROM tb_pipeline_vendas
WHERE Deal_Stage = 'Won' AND Close_Value > 1000
GROUP BY Sales_Agent
ORDER BY Num_Vendas DESC;

# 11- Número de vendas e a média do valor de venda por agente de vendas
SELECT 
Sales_Agent,
COUNT(*) AS Sales_Total,
ROUND(AVG(CAST(Close_Value AS UNSIGNED)),2) AS Avg_Close_Value
FROM tb_pipeline_vendas
GROUP BY Sales_Agent
ORDER BY Sales_Total DESC;

# 12- Quais agentes de vendas tiveram mais de 30 vendas?
SELECT
Sales_Agent,
COUNT(*) AS Sales_Total
FROM tb_pipeline_vendas
GROUP BY Sales_Agent
HAVING Sales_Total > 30
ORDER BY Sales_Total DESC;