SELECT
emp,
SUM( IF(recurso='email', quantidade, 0) ) AS emails,
SUM( IF(recurso='print', quantidade, 0) ) AS printings,
SUM( IF(recurso='sms', quantidade, 0) ) AS sms,
quantidade
FROM tb_recursos
GROUP BY emp;

SELECT
emp,
GROUP_CONCAT( IF(recurso='email', quantidade, 0) ) AS emails,
GROUP_CONCAT( IF(recurso='print', quantidade, 0) ) AS printings,
GROUP_CONCAT( IF(recurso='sms', quantidade, 0) ) AS sms,
quantidade
FROM tb_recursos
GROUP BY emp;