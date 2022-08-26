# 1-Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro?
SELECT
ROUND(AVG(duration),2) AS 'AVG Duration',
`Member type`
FROM `data-q2`
GROUP BY `Member type`;

# 2-Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro 
# e por estação fim (onde as bikes são entregues após o aluguel)?
SELECT
ROUND(AVG(duration),2) AS 'AVG Duration',
`Member type`,
`End station`
FROM `data-q2`
GROUP BY `Member type`, `End station`;

# 3-Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro 
# e por estação fim (onde as bikes são entregues após o aluguel) ao longo do tempo?
SELECT
AVG(duration) OVER (PARTITION BY `Member type` ORDER BY `Start date`) AS 'AVG Duration', 
`Member type`,
`End station`
FROM `data-q2`;

# 4-Qual hora do dia (independente do mês) a bike de número W01182 teve o maior número 
# de aluguéis considerando a data de início?
SELECT HOUR(`Start date`) as Hora, COUNT((HOUR(`Start date`))) as Vezes
FROM `data-q2`
WHERE `Bike number` = 'W01182'
GROUP BY HOUR(`Start date`)
ORDER BY COUNT((HOUR(`Start date`))) desc;

# 5-Qual o número de aluguéis da bike de número W01182 ao longo do tempo considerando a data de início?
SELECT 
count(duration) OVER (PARTITION BY `Start station` ORDER BY CAST(`Start date` AS date)) AS Count,
 CAST(`Start date` AS date) as Data
FROM `data-q2`
WHERE `Bike number` = 'W01182';


# 6-Retornar:# Estação fim, data fim de cada aluguel de bike e duração de cada aluguel em segundos
# Número de aluguéis de bikes (independente da estação) ao longo do tempo 
# Somente os registros quando a data fim foi no mês de Abril
SELECT 
`End station`,
`End date`,
Duration,
COUNT(duration) OVER(ORDER BY `End date`) AS num_alugueis
FROM `data-q2`
WHERE MONTH(`End date`) = 4;

# 7-Retornar:# Estação fim, data fim e duração em segundos do aluguel 
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00
# Queremos a ordem (classificação ou ranking) dos dias de aluguel ao longo dotempo
# Retornar os dados para os aluguéis entre 7 e 11 da manhã
SELECT
`End station`,
DATE_FORMAT(`End date`, '%d/%M/%Y %H:%i:%S') AS Data_Fim,
Duration,
RANK() OVER (PARTITION BY `End station` ORDER BY CAST(`End date` AS Date)) AS Ranking_Aluguel
FROM `data-q2`
WHERE HOUR(`End date`) BETWEEN 7 AND 11;

# 8-Qual a diferença da duração do aluguel de bikesao longo do tempo, de um registro para outro, 
# considerando data de início do aluguel e estação de início?
# A data de início deve ser retornada 
# no formato: Sat/Jan/12 00:00:00 (Sat = Dia da semana abreviado e Jan igual mês abreviado). 
# Retornar os dados para os aluguéis entre 01 e 03 da manhã
SELECT
Duration - LAG(Duration, 1) OVER (PARTITION BY `Start station` ORDER BY CAST(`Start date` AS Date)) AS Diff,
DATE_FORMAT(`Start date`, '%a/%b/%y %H:%i:%S') AS Date
FROM `data-q2`
WHERE HOUR(`Start date`) BETWEEN 01 AND 03;


# 9-Retornar:# Estação fim, data fim e duração em segundos do aluguel 
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00
# Queremos os registros divididos em 4 grupos ao longo do tempo por partição
# Retornar os dados para os aluguéis entre 8 e 10 da manhã
SELECT 
`End station`,
DATE_FORMAT(`End date`, '%d/%M/%Y %H:%i:%S') AS 'Date',
Duration,
NTILE(4) OVER (PARTITION BY `End station` ORDER BY `End date`) AS Num_Grupo
FROM `data-q2`;

# 10-Quais estações tiveram mais de 35 horas de duração total do aluguel de bike ao longo do tempo 
# considerando a data fim e estação fim?
# Retorne os dados entre os dias '2012-04-01' e '2012-04-02'
# Dica: Use função window e subquery
SELECT *
FROM (SELECT
`End station`,
CAST(`End date` AS Date) AS 'Data',
SUM(Duration/60/60) OVER (PARTITION BY `End station` ORDER BY CAST(`End date` AS Date)) AS 'Duracao_total'
FROM `data-q2`
WHERE CAST(`End date` AS Date) BETWEEN '2012-04-01' AND '2012-04-02') Sub
WHERE Sub.Duracao_total > 35