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