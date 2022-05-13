-- QUESTÃO 1

SELECT AVG(salario) AS media_salario 
FROM funcionario;

-- QUESTÃO 2

SELECT sexo, AVG(salario) AS media_salario 
FROM funcionario
GROUP BY sexo;

-- QUESTÃO 3

SELECT nome_departamento, CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, data_nascimento, DATEDIFF(DD, data_nascimento, GETDATE())/365.25 AS idade, salario
FROM departamento
INNER JOIN funcionario ON (departamento.numero_departamento = funcionario.numero_departamento);

-- QUESTÃO 4

SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, DATEDIFF(DD, data_nascimento, GETDATE())/365.25 AS idade, salario*1.2 AS reajuste_salario
FROM funcionario 
WHERE salario < 35.000
UNION
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, DATEDIFF(DD, data_nascimento, GETDATE())/365.25 AS idade, salario*1.5 AS reajuste_salario
WHERE salario >= 35.000

-- QUESTÃO 5

SELECT nome_departamento, 
CASE WHEN departamento.cpf_gerente = funcionario.cpf THEN primeiro_nome END AS gerente,
CASE WHEN departamento.cpf_gerente = funcionario.cpf THEN primeiro_nome END AS funcionario, salario
FROM funcionario
INNER JOIN departamento ON (funcionario.numero_departamento = departamento.numero_departamento)
ORDER BY departamento.nome_departamento ASC, funcionario.salario DESC;

-- QUESTÃO 6

SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, cpf, numero_departamento, CONCAT(dependente.nome_dependente, ' ', nome_meio, ' ', ultimo_nome) AS nome_dependente, DATEDIFF(DD, dependente.data_nascimento, GETDATE())/365.25 AS idade_dependente, 
CASE dependente.sexo WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Feminino' END AS sexo
FROM funcionario
INNER JOIN dependente ON (funcionario.cpf = dependente.cpf_funcionario)
INNER JOIN departamento ON (funcionario.numero_departamento = departamento.numero_departamento);

-- QUESTÃO 7

SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, nome_departamento, salario
FROM funcionario
INNER JOIN departamento
INNER JOIN dependente
WHERE departamento.numero_departamento = funcionario.numero_departamento AND funcionario.cpf NOT IN (SELECT dependente.cpf_funcionario);

-- QUESTÃO 8

SELECT nome_departamento, projeto.nome_projeto, SUM(trabalha_em.horas), CONCAT(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome)
FROM departamento 
INNER JOIN funcionario ON (projeto.numero_departamento = funcionario.numero_departamento)
INNER JOIN trabalha_em ON (projeto.numero_projeto = trabalha_em.numero_projeto)
INNER JOIN departamento ON (projeto.numero_departamento = departamento.numero_departamento)
WHERE departamento.numero_departamento = projeto.numero_departamento AND projeto.numero_projeto = trabalha_em.numero_projeto
GROUP BY projeto.nome_projeto;

-- QUESTÃO 9

SELECT projeto.nome_projeto, departamento.nome_departamento, SUM(horas) AS horas_totais
FROM trabalha_em
INNER JOIN projeto ON (trabalha_em.numero_projeto = projeto.numero_projeto)
INNER JOIN departamento ON (projeto.numero_departamento = departamento.numero_departamento)
GROUP BY projeto.nome_projeto;

-- QUESTÃO 10

SELECT nome_departamento, AVG(funcionario.salario) AS media_salario
FROM departamento 
INNER JOIN funcionario
WHERE departamento.numero_departamento = funcionario.numero_departamento
GROUP BY departamento.nome_departamento;

-- QUESTÃO 11

SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, nome_projeto, horas*50 AS valor_recebido
FROM trabalha_em 
INNER JOIN projeto ON (trabalha_em.numero_projeto = projeto.numero_projeto)
INNER JOIN funcionario ON (trabalha_em.cpf_funcionario = funcionario.cpf);

-- QUESTÃO 12

SELECT departamento.nome_departamento, projeto.nome_projeto, CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS nome, trabalha_em.horas
FROM funcionario 
INNER JOIN departamento
INNER JOIN projeto
INNER JOIN trabalha_em
WHERE funcionario.cpf = trabalha_em.cpf_funcionario AND projeto.numero_projeto = trabalha_em.numero_projeto AND (trabalha_em.horas = 0 OR trabalha_em.horas = NULL)
GROUP BY funcionario.primeiro_nome;

-- QUESTÃO 13

SELECT departamento.nome_dependente, sexo, DATEDIFF(DD, data_nascimento, GETDATE())/365.25 AS idade
FROM dependente
UNION 
SELECT CONCAT (primeiro_nome,' ',nome_meio,' ', ultimo_nome), sexo,
DATEDIFF(DD, data_nascimento, GETDATE())/365.25 AS idade
FROM funcionario
ORDER BY idade DESC;

-- QUESTÃO 14

SELECT departamento.nome_departamento, COUNT(funcionario.numero_departamento) AS qtd_funcionarios
FROM funcionario 
INNER JOIN departamento
ON (funcionario.numero_departamento = departamento.numero_departamento)
GROUP BY departamento.nome_departamento;

-- QUESTÃO 15

SELECT CONCAT (primeiro_nome, ' ',nome_meio, ' ', ultimo_nome) AS nome, numero_departamento, projeto.nome_projeto
FROM funcionario
INNER JOIN trabalha_em ON (trabalha_em.cpf_funcionario = funcionario.cpf)
INNER JOIN projeto ON (projeto.numero_projeto = trabalha_em.numero_projeto)
ORDER BY funcionario.numero_departamento;