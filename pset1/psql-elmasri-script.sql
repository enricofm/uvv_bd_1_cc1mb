-- Role: enrico
-- DROP ROLE IF EXISTS enrico;

CREATE ROLE enrico WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  
ALTER USER enrico
SET SEARCH_PATH TO enrico, "$user", public;

-- SCHEMA: elmasri

-- DROP SCHEMA IF EXISTS elmasri ;

CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION enrico;

COMMENT ON SCHEMA elmasri
    IS 'Esquema para o projeto Elmasri.';
	
GRANT ALL ON SCHEMA elmasri TO enrico;
  
-- Database: uvv

-- DROP DATABASE IF EXISTS uvv;

CREATE DATABASE uvv
    WITH 
    OWNER = enrico
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE uvv
    IS 'Database para o projeto Elmasri no psql.';
	
-- Table: elmasri.departamento

-- DROP TABLE IF EXISTS elmasri.departamento;

CREATE TABLE IF NOT EXISTS elmasri.departamento
(
    numero_departamento integer NOT NULL,
    nome_departamento character varying(15) COLLATE pg_catalog."default" NOT NULL,
    cpf_gerente character(11) COLLATE pg_catalog."default" NOT NULL,
    data_inicio_gerente date,
    CONSTRAINT departamento_pkey PRIMARY KEY (numero_departamento),
    CONSTRAINT departamento_ak UNIQUE (nome_departamento)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.departamento
    OWNER to enrico;

COMMENT ON TABLE elmasri.departamento
    IS 'Tabela que armazena as informaçoẽs dos departamentos.';

COMMENT ON COLUMN elmasri.departamento.numero_departamento
    IS 'Número do departamento. É a PK desta tabela.';

COMMENT ON COLUMN elmasri.departamento.nome_departamento
    IS 'Nome do departamento. Deve ser único.';

COMMENT ON COLUMN elmasri.departamento.cpf_gerente
    IS 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';

COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente
    IS 'Data do início do gerente no departamento.';
	
-- Table: elmasri.dependente

-- DROP TABLE IF EXISTS elmasri.dependente;

CREATE TABLE IF NOT EXISTS elmasri.dependente
(
    cpf_funcionario character(11) COLLATE pg_catalog."default" NOT NULL,
    nome_dependente character varying(15) COLLATE pg_catalog."default" NOT NULL,
    sexo character(1) COLLATE pg_catalog."default",
    data_nascimento date,
    parentesco character varying(15) COLLATE pg_catalog."default",
    CONSTRAINT dependente_pkey PRIMARY KEY (cpf_funcionario, nome_dependente)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.dependente
    OWNER to enrico;

COMMENT ON TABLE elmasri.dependente
    IS 'Tabela que armazena as informações dos dependentes dos funcionários.';

COMMENT ON COLUMN elmasri.dependente.cpf_funcionario
    IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

COMMENT ON COLUMN elmasri.dependente.nome_dependente
    IS 'Nome do dependente. Faz parte da PK desta tabela.';

COMMENT ON COLUMN elmasri.dependente.sexo
    IS 'Sexo do dependente.';

COMMENT ON COLUMN elmasri.dependente.data_nascimento
    IS 'Data de nascimento do dependente.';

COMMENT ON COLUMN elmasri.dependente.parentesco
    IS 'Descrição do parentesco do dependente com o funcionário.';

-- Table: elmasri.funcionario

-- DROP TABLE IF EXISTS elmasri.funcionario;

CREATE TABLE IF NOT EXISTS elmasri.funcionario
(
    cpf character(11) COLLATE pg_catalog."default" NOT NULL,
    primeiro_nome character varying(15) COLLATE pg_catalog."default" NOT NULL,
    nome_meio character(1) COLLATE pg_catalog."default",
    ultimo_nome character varying(15) COLLATE pg_catalog."default" NOT NULL,
    data_nascimento date,
    endereco character varying(50) COLLATE pg_catalog."default",
    sexo character(1) COLLATE pg_catalog."default",
    salario numeric(10,2),
    cpf_supervisor character(11) COLLATE pg_catalog."default" NOT NULL,
    numero_departamento integer NOT NULL,
    CONSTRAINT funcionario_pk PRIMARY KEY (cpf)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.funcionario
    OWNER to enrico;

COMMENT ON TABLE elmasri.funcionario
    IS 'Tabela que armazena as informações dos funcionários.';

COMMENT ON COLUMN elmasri.funcionario.cpf
    IS 'CPF do funcionário. Será a PK da tabela.';

COMMENT ON COLUMN elmasri.funcionario.primeiro_nome
    IS 'Primeiro nome do funcionário.';

COMMENT ON COLUMN elmasri.funcionario.nome_meio
    IS 'Inicial do nome do meio.';

COMMENT ON COLUMN elmasri.funcionario.ultimo_nome
    IS 'Sobrenome do funcionario.';

COMMENT ON COLUMN elmasri.funcionario.data_nascimento
    IS 'Data de nascimento do funcionario.';

COMMENT ON COLUMN elmasri.funcionario.endereco
    IS 'Endereço do funcionário.';

COMMENT ON COLUMN elmasri.funcionario.sexo
    IS 'Sexo do funcionário.';

COMMENT ON COLUMN elmasri.funcionario.salario
    IS 'Salário do funcionário.';

COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor
    IS 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).';

COMMENT ON COLUMN elmasri.funcionario.numero_departamento
    IS 'Número do departamento do funcionário.';
	
-- Table: elmasri.localizacoes_departamento

-- DROP TABLE IF EXISTS elmasri.localizacoes_departamento;

CREATE TABLE IF NOT EXISTS elmasri.localizacoes_departamento
(
    numero_departamento integer NOT NULL,
    local character varying(15) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT localizacoes_departamento_pkey PRIMARY KEY (numero_departamento, local)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.localizacoes_departamento
    OWNER to enrico;

COMMENT ON TABLE elmasri.localizacoes_departamento
    IS 'Tabela que armazena as possíveis localizações dos departamentos.';

COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento
    IS 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.';

COMMENT ON COLUMN elmasri.localizacoes_departamento.local
    IS 'Localização do departamento. Faz parte da PK desta tabela.';

-- Table: elmasri.projeto

-- DROP TABLE IF EXISTS elmasri.projeto;

CREATE TABLE IF NOT EXISTS elmasri.projeto
(
    numero_projeto integer NOT NULL,
    nome_projeto character varying(20) COLLATE pg_catalog."default" NOT NULL,
    local_projeto character varying(15) COLLATE pg_catalog."default",
    numero_departamento integer NOT NULL,
    CONSTRAINT projeto_pkey PRIMARY KEY (numero_projeto),
    CONSTRAINT projeto_ak UNIQUE (nome_projeto)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.projeto
    OWNER to enrico;

COMMENT ON TABLE elmasri.projeto
    IS 'Tabela que armazena as informações sobre os projetos dos departamentos.';

COMMENT ON COLUMN elmasri.projeto.numero_projeto
    IS 'Número do projeto. É a PK desta tabela.';

COMMENT ON COLUMN elmasri.projeto.nome_projeto
    IS 'Nome do projeto. Deve ser único.';

COMMENT ON COLUMN elmasri.projeto.local_projeto
    IS 'Localização do projeto.';

COMMENT ON COLUMN elmasri.projeto.numero_departamento
    IS 'Número do departamento. É uma FK para a tabela departamento.';

-- Table: elmasri.trabalha_em

-- DROP TABLE IF EXISTS elmasri.trabalha_em;

CREATE TABLE IF NOT EXISTS elmasri.trabalha_em
(
    cpf_funcionario character(11) COLLATE pg_catalog."default" NOT NULL,
    numero_projeto integer NOT NULL,
    horas numeric(3,1) NOT NULL,
    CONSTRAINT trabalha_em_pkey PRIMARY KEY (cpf_funcionario, numero_projeto),
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS elmasri.trabalha_em
    OWNER to enrico;

COMMENT ON TABLE elmasri.trabalha_em
    IS 'Tabela para armazenar quais funcionários trabalham em quais projetos.';

COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario
    IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto
    IS 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';

COMMENT ON COLUMN elmasri.trabalha_em.horas
    IS 'Horas trabalhadas pelo funcionário neste projeto.';

INSERT INTO elmasri.funcionario (cpf,primeiro_nome,nome_meio,ultimo_nome,data_nascimento,endereco,sexo,salario,cpf_supervisor,numero_departamento) VALUES
('12345678966','João','B','Silva','1965-01-09','Rua das Flores, 751, São Paulo, SP','M',30000.00,'33344555587',5),
('33344555587','Fernando','T','Wong','1955-12-08','Rua da Lapa, 34, São Paulo, SP','M',40000.00,'88866555576',5),
('99988777767','Alice','J','Zelaya','1968-01-19','Rua Souza Lima, 35, Curitiba, PR','F',25000.00,'98765432168',4),
('98765432168','Jennifer','D','Souza','1946-06-20','Av.Arthur de Lima, 54 , Santo André , SP','F',43000.00,'88866555576',4),
('66688444476','Ronaldo','K','Lima','1962-09-15','Rua Rebouças, 65, Piracicaba, SP','M',38000.00,'33344555587',5),
('45345345376','Joice','A','Leite','1972-07-31','Av.Lucas Obes, 74 , São Paulo, SP','F',25000.00,'33344555587',5),
('98798798733','André','V','Pereira','1969-03-29','Rua Timbira, 35, São Paulo, SP','M',25000.00,'98765432168',4),
('88866555576','Jorge','E','Brito','1937-11-10','Rua do Horto, 35, São Paulo','M',55000.00,NULL,1);

INSERT INTO elmasri.departamento (numero_departamento,nome_departamento,cpf_gerente,data_inicio_gerente) VALUES
(4,'Admininstração','98765432168','1995-01-01'),
(1,'Matriz','88866555576','1981-06-19'),
(5,'Pesquisa','33344555587','1988-05-22');
	 
INSERT INTO elmasri.localizacoes_departamento (local,numero_departamento) VALUES
('São Paulo',1),
('Mauá',4),
('Santo André',5),
('Itu',5),
('Sao Paulo',5);
	 
INSERT INTO elmasri.projeto (numero_projeto,nome_projeto,local_projeto,numero_departamento) VALUES
(1,'ProdutoX','Santo André',5),
(2,'ProdutoY','Itu',5),
(3,'ProdutoZ','São Paulo',5),
(10,'Informatização','Mauá',4),
(20,'Reorganização','Sao Paulo',1),
(30,'Novos Benefícios','Mauá',4);

INSERT INTO elmasri.dependente (cpf_funcionario,nome_dependente,sexo,data_nascimento,parentesco) VALUES
('33344555587','Alicia','F','1986-04-05','Filha'),
('33344555587','Tiago','M','1983-10-25','Filho'),
('33344555587','Janaína','F','1958-05-03','Esposa'),
('98765432168','Antonio','M','1942-02-28','Marido'),
('12345678966','Michael','M','1988-01-04','Filho'),
('12345678966','Alícia','F','1988-12-30','Filha'),
('12345678966','Elizabeth','F','1967-05-05','Esposa');

INSERT INTO elmasri.trabalha_em (cpf_funcionario,numero_projeto,horas) VALUES
('12345678966',1,32.5),
('12345678966',2,7.5),
('66688444476',3,40.0),
('45345345376',1,20.0),
('45345345376',2,20.0),
('33344555587',2,10.0),
('33344555587',3,10.0),
('33344555587',10,10.0),
('33344555587',20,10.0),
('99988777767',30,30.0),
('99988777767',10,10.0),
('98798798733',10,35.0),
('98798798733',30,5.0),
('98765432168',30,20.0),
('98765432168',20,15.0),
('88866555576',20,NULL);

ALTER TABLE departamento ADD CONSTRAINT departamento_fk 
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;

ALTER TABLE dependente ADD CONSTRAINT dependente_fk 
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT projeto_fk 
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT loc_dep_fk 
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
		
ALTER TABLE trabalha_em ADD CONSTRAINT cpf_trabalha_em_fk 
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT np_trabalha_em_fk 
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;