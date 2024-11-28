CREATE TABLE users (
    id integer primary key autoincrement,
    email varchar(320),
    senha varchar(255),
    dataNascimento date,
    constInsulinica real,
    nome varchar(255),
    sobrenome varchar(255),
    glicemiaMinima integer,
    glicemiaMaxima integer
);

create table glicemia (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	idUser INTEGER,
    idRefeicao INTEGER,
  	glicemia double,
  	data DATE,
    doseInsulina INTEGER,
  	FOREIGN KEY (idUser) REFERENCES users(id),
    FOREIGN KEY (idRefeicao) REFERENCES refeicao(id)
);

create table alimento_referencia (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	nome VARCHAR(255),
  	porcao VARCHAR(255),
  	gramasPorPorcao VARCHAR(255),
  	carbosPorPorcao VARCHAR(255),
    caloriasPorPorcao VARCHAR(255),
    favCafe INTEGER,
    favAlmoco INTEGER,
    favJanta INTEGER,
    favLanche INTEGER
);

CREATE TABLE refeicao (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
    idUser INTEGER,
    tipoRefeicao VARCHAR(255),
    data DATE,
    isActive INTEGER,
    totalCarbos INTEGER,
    totalCalorias INTEGER,
    FOREIGN KEY (idUser) REFERENCES users(id)
);

CREATE TABLE alimento_ingerido (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	idAlimentoReferencia INTEGER,
  	idRefeicao INTEGER,
  	qtdIngerida double,
  	FOREIGN KEY (idAlimentoReferencia) REFERENCES alimento_referencia(id),
  	FOREIGN KEY (idRefeicao) REFERENCES refeicao(id)
);