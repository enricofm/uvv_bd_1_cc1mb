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
    CONSTRAINT departamento_ak UNIQUE (nome_departamento),
    CONSTRAINT departamento_fk FOREIGN KEY (cpf_gerente)
        REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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
    CONSTRAINT dependente_pkey PRIMARY KEY (cpf_funcionario, nome_dependente),
    CONSTRAINT dependente_fk FOREIGN KEY (cpf_funcionario)
        REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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
    endereco character varying(30) COLLATE pg_catalog."default",
    sexo character(1) COLLATE pg_catalog."default",
    salario numeric(10,2),
    cpf_supervisor character(11) COLLATE pg_catalog."default" NOT NULL,
    numero_departamento integer NOT NULL,
    CONSTRAINT funcionario_pk PRIMARY KEY (cpf),
    CONSTRAINT funcionario_fk FOREIGN KEY (cpf_supervisor)
        REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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
    CONSTRAINT localizacoes_departamento_pkey PRIMARY KEY (numero_departamento, local),
    CONSTRAINT loc_dep_fk FOREIGN KEY (numero_departamento)
        REFERENCES elmasri.departamento (numero_departamento) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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
    nome_projeto character varying(15) COLLATE pg_catalog."default" NOT NULL,
    local_projeto character varying(15) COLLATE pg_catalog."default",
    numero_departamento integer NOT NULL,
    CONSTRAINT projeto_pkey PRIMARY KEY (numero_projeto),
    CONSTRAINT projeto_ak UNIQUE (nome_projeto),
    CONSTRAINT projeto_fk FOREIGN KEY (numero_departamento)
        REFERENCES elmasri.departamento (numero_departamento) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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
    CONSTRAINT cpf_trabalha_em_fk FOREIGN KEY (cpf_funcionario)
        REFERENCES elmasri.funcionario (cpf) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT np_trabalha_em_fk FOREIGN KEY (numero_projeto)
        REFERENCES elmasri.projeto (numero_projeto) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
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