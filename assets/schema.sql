CREATE TABLE users (
    id integer primary key autoincrement,
    email varchar(320),
    senha varchar(255), -- talvez mudar pq o hash talvez tenha mais de 255 caracteres
    peso real,
    data_nascimento date,
    const_insulinica real,
    nome varchar(255),
    sobrenome varchar(255),
    altura real
);

create table glicemia (
	id integer PRIMARY KEY AUTOINCREMENT,
  	idUser integer,
  	glicemia double,
  	data date,
  	FOREIGN KEY (idUser) references users(id)
);

create table alimento_referencia (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	nome VARCHAR(255),
  	porcao VARCHAR(255),
  	gramas_por_porcao VARCHAR(255),
  	carbos_por_porcao VARCHAR(255),
  	carbos_por_grama VARCHAR(255),
    favCafe INTEGER,
    favAlmoco INTEGER,
    favJanta INTEGER,
    favLanche INTEGER
);

CREATE TABLE refeicao (
	id integer PRIMARY KEY AUTOINCREMENT,
    idUser integer,
    tipoRefeicao varchar(255),
    data date,
    isActive integer,
    FOREIGN KEY (idUser) REFERENCES users(id)
);

CREATE TABLE alimento_ingerido (
	id integer primary key AUTOINCREMENT,
  	idAlimentoReferencia integer,
  	idRefeicao integer,
  	qtdIngerida double,
  	FOREIGN KEY (idAlimentoReferencia) REFERENCES alimento_referencia(id),
  	FOREIGN KEY (idRefeicao) REFERENCES refeicao(id)
);