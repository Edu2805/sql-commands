CREATE DATABASE alura_estudos2;

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);


insert into aluno (primeiro_nome, ultimo_nome, data_nascimento) 
values ('Carlos', 'Alberto', '1980-10-11'),
('José', 'Ricardo', '1985-02-15'),
('Maria', 'Roberta', '1990-11-11'),
('Vânia', 'Mathias', '1995-05-20'),
('Diogo', 'Nogueira', '1988-06-28');

select * from aluno a 

insert into categoria (nome) 
values('Desenvolvimento'), 
('DevOps'), ('Data Science'), 
('Backend'), ('Frontend');

select * from categoria 

insert into curso (nome, categoria_id) 
values ('Java', 4), ('TypeScript', 5), ('GitLab', 2),
('Banco de dados', 2), ('Desenvolvimento FullStack', 1);

select * from curso 

insert into aluno_curso (aluno_id, curso_id) 
values (1,5), (5, 4), 
(2, 2), (3, 5), (4, 3);

select * from aluno_curso 

