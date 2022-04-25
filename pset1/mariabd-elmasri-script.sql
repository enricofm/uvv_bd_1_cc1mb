CREATE USER 'enrico'@'%' IDENTIFIED BY 'enrico';
GRANT Reload ON *.* TO 'enrico'@'%';
GRANT Process ON *.* TO 'enrico'@'%';
GRANT File ON *.* TO 'enrico'@'%';
GRANT Event ON *.* TO 'enrico'@'%';
GRANT Create user ON *.* TO 'enrico'@'%';
GRANT Create tablespace ON *.* TO 'enrico'@'%';
GRANT Alter ON *.* TO 'enrico'@'%';
GRANT Create ON *.* TO 'enrico'@'%';
GRANT Index ON *.* TO 'enrico'@'%';
GRANT Insert ON *.* TO 'enrico'@'%';
GRANT Update ON *.* TO 'enrico'@'%';

CREATE DATABASE `uvv` /*!40100 DEFAULT CHARACTER SET latin1 */;
GRANT ALL PRIVILEGES ON uvv.* TO 'enrico'@'%';
use uvv;

-- uvv.departamento definition

CREATE TABLE departamento (
	numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento. É a PK desta tabela.',
	nome_departamento VARCHAR(15) NOT NULL COMMENT 'Nome do departamento. Deve ser único.',
	cpf_gerente CHAR(11) NOT NULL COMMENT 'CPF do gerente do departamento. É uma FK para a tabela funcionários.',
	data_inicio_gerente DATE NULL COMMENT 'Data do início do gerente no departamento.',
	CONSTRAINT departamento_PK PRIMARY KEY (numero_departamento),
	CONSTRAINT departamento_FK FOREIGN KEY (cpf_gerente) REFERENCES funcionario(cpf)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_hungarian_ci
COMMENT='Tabela que armazena as informaçoẽs dos departamentos.';

-- uvv.dependente definition

CREATE TABLE dependente (
	cpf_funcionario CHAR(11) NOT NULL COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.',
	nome_dependente VARCHAR(15) NOT NULL COMMENT 'Nome do dependente. Faz parte da PK desta tabela.',
	sexo CHAR(1) NULL COMMENT 'Sexo do dependente.',
	data_nascimento DATE NULL COMMENT 'Data de nascimento do dependente.',
	parentesco VARCHAR(15) NULL COMMENT 'Descrição do parentesco do dependente com o funcionário.',
	CONSTRAINT dependente_PK PRIMARY KEY (cpf_funcionario,nome_dependente),
	CONSTRAINT departamento_UN UNIQUE KEY (nome_departamento),
	CONSTRAINT dependente_FK FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Tabela que armazena as informações dos dependentes dos funcionários.';

-- uvv.funcionario definition

CREATE TABLE `funcionario` (
	cpf CHAR(11) NOT NULL COMMENT 'CPF do funcionário. Será a PK da tabela.',
	primeiro_nome VARCHAR(15) NOT NULL COMMENT 'Primeiro nome do funcionário.',
	nome_meio CHAR(1) NULL COMMENT 'Inicial do nome do meio.',
	ultimo_nome VARCHAR(15) NOT NULL COMMENT 'Sobrenome do funcionário.',
	data_nascimento DATE NULL COMMENT 'Data de nascimento do funcionário.',
	endereco VARCHAR(50) NULL COMMENT 'Endereço do funcionário.',
	sexo CHAR(1) NULL COMMENT 'Sexo do funcionário.',
	salario DECIMAL(10,2) NULL COMMENT 'Salário do funcionário.',
	cpf_supervisor CHAR(11) NOT NULL COMMENT 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).',
	numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento do funcionário.',
	CONSTRAINT funcionario_PK PRIMARY KEY (cpf),
	CONSTRAINT funcionario_FK FOREIGN KEY (cpf_supervisor) REFERENCES funcionario(cpf)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Tabela que armazena as informações dos funcionários.';

-- uvv.localizacoes_departamento definition

CREATE TABLE localizacoes_departamento (
	numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.',
	`local` VARCHAR(15) NOT NULL COMMENT 'Localização do departamento. Faz parte da PK desta tabela.',
	CONSTRAINT localizacoes_departamento_PK PRIMARY KEY (numero_departamento,`local`),
	CONSTRAINT localizacoes_departamento_FK FOREIGN KEY (numero_departamento) REFERENCES departamento(numero_departamento)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Tabela que armazena as possíveis localizações dos departamentos.';

-- uvv.projeto definition

CREATE TABLE projeto (
	numero_projeto INTEGER NOT NULL COMMENT 'Número do projeto. É a PK desta tabela.',
	nome_projeto VARCHAR(20) NOT NULL COMMENT 'Nome do projeto. Deve ser único.',
	local_projeto VARCHAR(15) NULL COMMENT 'Localização do projeto.',
	numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento. É uma FK para a tabela departamento.',
	CONSTRAINT projeto_PK PRIMARY KEY (numero_projeto),
	CONSTRAINT projeto_UN UNIQUE KEY (nome_projeto),
	CONSTRAINT projeto_FK FOREIGN KEY (numero_departamento) REFERENCES departamento(numero_departamento)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Tabela que armazena as informações sobre os projetos dos departamentos.';

-- uvv.trabalha_em definition

CREATE TABLE trabalha_em (
	cpf_funcionario CHAR(11) NOT NULL COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.',
	numero_projeto INTEGER NOT NULL COMMENT 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.',
	horas DECIMAL(3,1) NOT NULL COMMENT 'Horas trabalhadas pelo funcionário neste projeto.',
	CONSTRAINT trabalha_em_PK PRIMARY KEY (cpf_funcionario,numero_projeto),
	CONSTRAINT trabalha_em_FK FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf),
	CONSTRAINT trabalha_em_FK_1 FOREIGN KEY (numero_projeto) REFERENCES projeto(numero_projeto)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='Tabela para armazenar quais funcionários trabalham em quais projetos.';

INSERT INTO departamento (numero_departamento,nome_departamento,cpf_gerente,data_inicio_gerente) VALUES
	(4,'Admininstração','98765432168','1995-01-01'),
	(1,'Matriz','88866555576','1981-06-19'),
	(5,'Pesquisa','33344555587','1988-05-22');

INSERT INTO funcionario (cpf,primeiro_nome,nome_meio,ultimo_nome,data_nascimento,endereco,sexo,salario,cpf_supervisor,numero_departamento) VALUES
	('98765432168','Jennifer','D','Souza','1946-06-20','Av.Arthur de Lima, 54 , Santo André , SP','f',43000.00,'88866555576',4),
	('66688444476','Ronaldo','K','Lima','1962-09-15','Rua Rebouças, 65, Piracicaba, SP','m',38000.00,'33344555587',5),
	('45345345376','Joice','A','Leite','1972-07-31','Av.Lucas Obes, 74 , São Paulo, SP','f',25000.00,'33344555587',5),
	('98798798733','André','V','Pereira','1969-03-29','Rua Timbira, 35, São Paulo, SP','m',25000.00,'98765432168',4),
	('12345678966','João','B','Silva','1965-01-09','Rua das Flores, 751, São Paulo, SP','m',30000.00,'33344555587',5),
	('33344555587','Fernando','T','Wong','1955-12-08','Rua da Lapa, 34, São Paulo, SP','m',40000.00,'88866555576',5),
	('88866555576','Jorge','E','Brito','1937-11-10','Rua do Horto, 35, São Paulo','m',55000.00,NULL,1),
	('99988777767','Alice','J','Zelaya','1968-01-19','Rua Souza Lima, 35, Curitiba, PR','f',25000.00,'98765432168',4);
	 
INSERT INTO localizacoes_departamento (`local`,numero_departamento) VALUES
	('São Paulo',1),
	('Mauá',4),
	('Santo André',5),
	('Itu',5),
	('Sao Paulo',5);

INSERT INTO projeto (numero_projeto,nome_projeto,local_projeto,numero_departamento) VALUES
	(1,'ProdutoX','Santo André',5),
	(2,'ProdutoY','Itu',5),
	(3,'ProdutoZ','São Paulo',5),
	(10,'Informatização','Mauá',4),
	(20,'Reorganização','Sao Paulo',1),
	(30,'Novos Benefícios','Mauá',4);

INSERT INTO dependente (cpf_funcionario,nome_dependente,sexo,data_nascimento,parentesco) VALUES
	('33344555587','Alicia','f','1986-04-05','Filha'),
	('33344555587','Tiago','m','1983-10-25','Filho'),
	('33344555587','Janaína','f','1958-05-03','Esposa'),
	('98765432168','Antonio','m','1942-02-28','Marido'),
	('12345678966','Michael','m','1988-01-04','Filho'),
	('12345678966','Alícia','f','1988-12-30','Filha'),
	('12345678966','Elizabeth','f','1967-05-05','Esposa');

INSERT INTO trabalha_em (cpf_funcionario,numero_projeto,horas) VALUES
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