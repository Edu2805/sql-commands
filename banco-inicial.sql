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


-----------------------------------------------------------------------

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

insert into aluno_curso values (1,5), (5, 4), (2, 2), (3, 5), (4, 3);

select * from aluno_curso 

-- Update

select * from categoria c 

update categoria set nome = 'Ciência de dados' where id = 3

--- Relatório de alunos por curso

-- Geral
select * from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
join curso c on c.id = ac.curso_id 

-- Específico informando as colunas no group by
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (c.id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
join curso c on c.id = ac.curso_id 
group by a.primeiro_nome, a.ultimo_nome 

-- Específico informando as posições das colunas no group by
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (c.id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
join curso c on c.id = ac.curso_id 
group by 1,2 

-- Ordenado pelo pelo alias (numero de cursos)
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (c.id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
join curso c on c.id = ac.curso_id 
group by 1,2 
order by "Número de cursos" desc  

-- Limpando a query, deixando somente os dados necessários sem aterar o resultado
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (ac.curso_id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
group by 1,2 
order by "Número de cursos" desc  

-- Limitando pelo aluno que fez mais cursos
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (ac.curso_id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
group by 1,2 
order by "Número de cursos" desc  
limit 1

-- Limitando a três alunos
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (ac.curso_id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
group by 1,2 
order by "Número de cursos" desc  
limit 3

-- Limitando a três alunos a partir do registo 1
select a.primeiro_nome as "Primeiro nome", 
	   a.ultimo_nome as "Segundo nome",
	   count (ac.curso_id) as "Número de cursos"
from aluno a 
join aluno_curso ac on ac.aluno_id = a.id 
group by 1,2 
order by "Número de cursos" desc  
limit 3
offset 1

-- Pelos cursos mais requisitados (incluindo os que não tem alunos)
select c.nome as "Nome do curso",
	   count(ac.aluno_id) as "Numero de alunos"
from curso c 
left join aluno_curso ac on ac.curso_id = c.id 
group by 1
order by "Numero de alunos" desc 

-- Pelo curso mais requisitado
select c.nome as "Nome do curso",
	   count(ac.aluno_id) as "Numero de alunos"
from curso c 
left join aluno_curso ac on ac.curso_id = c.id 
group by 1
order by "Numero de alunos" desc 
limit 1
