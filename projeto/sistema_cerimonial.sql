-- Criação do banco de dados

CREATE DATABASE sistema_cerimonial;
use sistema cerimonial;

-- Criação das tabelas

CREATE TABLE clientes (
                codigo_cliente VARCHAR(15) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                email VARCHAR(100) NOT NULL,
                PRIMARY KEY (codigo_cliente)
);

ALTER TABLE clientes COMMENT 'Tabela que armazena as informacoes dos clientes.';


CREATE TABLE convidados (
                codigo_convidado VARCHAR(15) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                data_nascimento DATE NOT NULL,
                sexo VARCHAR(1) NOT NULL,
                PRIMARY KEY (codigo_convidado)
);

ALTER TABLE convidados COMMENT 'Tabela que armazena as informacoes dos convidados.';


CREATE TABLE endereco (
                codigo_endereco VARCHAR(15) NOT NULL,
                logradouro VARCHAR(100) NOT NULL,
                numero INT NOT NULL,
                complemento VARCHAR(150),
                cep CHAR(8) NOT NULL,
                uf VARCHAR(2) NOT NULL,
                bairro VARCHAR(25) NOT NULL,
                cidade VARCHAR(25) NOT NULL,
                codigo_convidado VARCHAR(15) NOT NULL,
                codigo_cliente VARCHAR(15) NOT NULL,
                PRIMARY KEY (codigo_endereco)
);

ALTER TABLE endereco COMMENT 'Tabela que armazena os enderecos.';


CREATE TABLE convites (
                codigo_cliente VARCHAR(15) NOT NULL,
                codigo_convidado VARCHAR(15) NOT NULL,
                PRIMARY KEY (codigo_cliente, codigo_convidado)
);

ALTER TABLE convites COMMENT 'Tabela que relaciona clientes e convidados.';


CREATE TABLE eventos (
                codigo_evento VARCHAR(15) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                motivo VARCHAR(50) NOT NULL,
                data_inicio DATE NOT NULL,
                data_fim DATE NOT NULL,
                hora_inicio TIME NOT NULL,
                hora_fim TIME NOT NULL,
                valor DECIMAL(8,2) NOT NULL,
                forma_pagamento VARCHAR(30) NOT NULL,
                PRIMARY KEY (codigo_evento)
);

ALTER TABLE eventos COMMENT 'Tabela que armazena as informacoes dos eventos.';


CREATE TABLE servicos (
                codigo_servico VARCHAR(15) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                descricao VARCHAR(100) NOT NULL,
                valor DECIMAL(8,2) NOT NULL,
                PRIMARY KEY (codigo_servico)
);

ALTER TABLE servicos COMMENT 'Tabela que armazena as informacoes dos servicos.';


CREATE TABLE consumos (
                codigo_servico VARCHAR(15) NOT NULL,
                codigo_evento VARCHAR(15) NOT NULL,
                quant_contratada INT NOT NULL,
                quant_consumida INT,
                PRIMARY KEY (codigo_servico)
);

ALTER TABLE consumos COMMENT 'Tabela que armazena as informacoes dos consumos.';


CREATE TABLE comidas (
                codigo_servico VARCHAR(15) NOT NULL,
                nome VARCHAR(25) NOT NULL,
                teor_calorico INT NOT NULL,
                PRIMARY KEY (codigo_servico)
);

ALTER TABLE comidas COMMENT 'Tabela que armazena as informacoes das comidas.';


CREATE TABLE bebidas (
                codigo_servico VARCHAR(15) NOT NULL,
                nome VARCHAR(25) NOT NULL,
                indice_alcool DECIMAL(5,2) NOT NULL,
                PRIMARY KEY (codigo_servico)
);

ALTER TABLE bebidas COMMENT 'Tabela que armazena as informacoes das bebidas.';


CREATE TABLE profissionais (
                codigo_profissional VARCHAR(15) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                PRIMARY KEY (codigo_profissional)
);

ALTER TABLE profissionais COMMENT 'Tabela que armazena as informacoes dos profissionais.';


CREATE TABLE equipes (
                data_inicio DATE NOT NULL,
                codigo_profissional VARCHAR(15) NOT NULL,
                data_fim DATE,
                codigo_evento VARCHAR(15) NOT NULL,
                PRIMARY KEY (data_inicio, codigo_profissional)
);

ALTER TABLE equipes COMMENT 'Tabela que armazena as informacoes das equipes.';


CREATE TABLE telefones (
                numero_tel VARCHAR(15) NOT NULL,
                codigo_profissional VARCHAR(15) NOT NULL,
                codigo_convidado VARCHAR(15) NOT NULL,
                codigo_cliente VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_tel)
);

ALTER TABLE telefones COMMENT 'Tabela que armazena os telefones.';


CREATE TABLE garcom (
                codigo_profissional VARCHAR(15) NOT NULL,
                tempo_exp VARCHAR(15) NOT NULL,
                PRIMARY KEY (codigo_profissional)
);

ALTER TABLE garcom COMMENT 'Tabela que armazena as informacoes dos garcons.';


CREATE TABLE cozinheiros (
                codigo_profissional VARCHAR(15) NOT NULL,
                formacao VARCHAR(20) NOT NULL,
                especialidade VARCHAR(20) NOT NULL,
                PRIMARY KEY (codigo_profissional)
);

ALTER TABLE cozinheiros COMMENT 'Tabela que armazena as informacoes dos cozinheiros.';


CREATE TABLE musicos (
                codigo_profissional VARCHAR(15) NOT NULL,
                formacao VARCHAR(20) NOT NULL,
                desc_habilidade VARCHAR(20) NOT NULL,
                PRIMARY KEY (codigo_profissional)
);

ALTER TABLE musicos COMMENT 'Tabela que armazena as informacoes dos musicos.';

-- Criação das contraints

ALTER TABLE telefones ADD CONSTRAINT clientes_telefones_fk
FOREIGN KEY (codigo_cliente)
REFERENCES clientes (codigo_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE convites ADD CONSTRAINT clientes_convites_fk
FOREIGN KEY (codigo_cliente)
REFERENCES clientes (codigo_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE endereco ADD CONSTRAINT clientes_endereco_fk
FOREIGN KEY (codigo_cliente)
REFERENCES clientes (codigo_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE telefones ADD CONSTRAINT convidados_telefones_fk
FOREIGN KEY (codigo_convidado)
REFERENCES convidados (codigo_convidado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE convites ADD CONSTRAINT convidados_convites_fk
FOREIGN KEY (codigo_convidado)
REFERENCES convidados (codigo_convidado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE endereco ADD CONSTRAINT convidados_endereco_fk
FOREIGN KEY (codigo_convidado)
REFERENCES convidados (codigo_convidado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE equipes ADD CONSTRAINT eventos_equipes_fk
FOREIGN KEY (codigo_evento)
REFERENCES eventos (codigo_evento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE consumos ADD CONSTRAINT eventos_consumos_fk
FOREIGN KEY (codigo_evento)
REFERENCES eventos (codigo_evento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE bebidas ADD CONSTRAINT servicos_bebidas_fk
FOREIGN KEY (codigo_servico)
REFERENCES servicos (codigo_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE comidas ADD CONSTRAINT servicos_comidas_fk
FOREIGN KEY (codigo_servico)
REFERENCES servicos (codigo_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE consumos ADD CONSTRAINT servicos_consumos_fk
FOREIGN KEY (codigo_servico)
REFERENCES servicos (codigo_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE musicos ADD CONSTRAINT profissionais_musicos_fk
FOREIGN KEY (codigo_profissional)
REFERENCES profissionais (codigo_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE cozinheiros ADD CONSTRAINT profissionais_cozinheiros_fk
FOREIGN KEY (codigo_profissional)
REFERENCES profissionais (codigo_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE garcom ADD CONSTRAINT profissionais_garcom_fk
FOREIGN KEY (codigo_profissional)
REFERENCES profissionais (codigo_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE telefones ADD CONSTRAINT profissionais_telefones_fk
FOREIGN KEY (codigo_profissional)
REFERENCES profissionais (codigo_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE equipes ADD CONSTRAINT profissionais_equipes_fk
FOREIGN KEY (codigo_profissional)
REFERENCES profissionais (codigo_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
