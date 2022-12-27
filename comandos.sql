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
values('UX Designer'), ('Desenvolvimento'), 
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

--- Operador IN
-- busca tradicional
select * from categoria c where c.id = 1 or c.id = 3

-- busca com o IN
select * from categoria c where c.id in (1,3)

-- com subquery que não contenha espaços no nome

select * from categoria c where c.nome not like '% %'
select * from categoria c2 

select * from curso c where c.categoria_id in (
	select id from categoria cat where cat.nome not like '% %'
);

-- subquery para trazer somente a categoria de banco de dados

select categoria
	from (
		select categoria.nome as categoria,
			count(curso.id) as numero_cursos
		from categoria
		join curso on curso.categoria_id = categoria.id 
		group by categoria
	) as  categoria_cursos
where numero_cursos >= 2

-- poderia ser usado também
select categoria.nome as categoria,
	count(curso.id) as numero_cursos
	from categoria
	join curso on curso.categoria_id = categoria.id 
group by categoria
having count(curso.id) >= 2 

--- Unir elemento na consulta

select (primeiro_nome || ' ' || ultimo_nome) from aluno

-- Lidando com o null quando queremos unir (concat)
select concat('Eduardo', ' ', null, 'De', ' ', 'Amorim' ) as "Nome completo"

-- Em letras maiúsculas
select upper(concat('Eduardo', ' ', null, 'De', ' ', 'Amorim' )) as "Nome completo"

-- Em letras minúsculas
select lower(concat('Eduardo', ' ', null, 'De', ' ', 'Amorim' )) as "Nome completo"

-- Remover espaços do início e do fim da função (trim)
select trim(upper(concat('Eduardo', ' ', null, 'De', ' ', 'Amorim' ))) as "Nome completo"

--- Calcular a idade dos alunos
-- pegando a data atual, fazendo a formação para data usando (::)
select (primeiro_nome || ' ' || ultimo_nome) as "Nome completo", now()::date , data_nascimento as "Data de nascimento" 
from aluno

-- Calculando a idade dos alunos
select (primeiro_nome || ' ' || ultimo_nome) as "Nome completo", 
		(now()::date - data_nascimento) / 365 as "Idade" 
from aluno

-- Simplificando, usando o AGE()
select (primeiro_nome || ' ' || ultimo_nome) as "Nome completo", 
		age(data_nascimento) as "Idade" 
from aluno

-- Extraindo somente o ano (extract(year from ...)
select (primeiro_nome || ' ' || ultimo_nome) as "Nome completo", 
		extract(year from age(data_nascimento)) as "Idade" 
from aluno

--- Funções de conversão de tipos
-- Data 
select now()::date

-- converter data para DD/MM/YYYY
select to_char(now(), 'DD/MM/YYYY') as "Data atual"

-- Outras maneiras
select to_char(now(), 'DAY, MONTH, YYYY') as "Data atual"
select to_char(now(), 'DAY DD, MONTH MM, YYYY') as "Data atual"

-- Números reais
select 128.3
select 128.3::real 

-- Inserindo dois dígitos (transformando em string)
select to_char(128.3::real, '999D99') 

--Criar banco e dados

create database database_name;

--Excluir banco de dados

drop database database_name;

--Criar tabela
create table student (
	id SERIAL,
	name VARCHAR (255),
	cpf CHAR(11),
	observation text,
	age INTEGER,
	money NUMERIC(10,2),
	height real,
	is_active BOOLEAN,
	birth_date DATE,
	class_time TIME,
	registration TIMESTAMP
);

--Listar tabela
select * from student s 

--Inserir valores na tabela
insert into student (name, cpf, observation, age, "money", height, is_active, birth_date, class_time, registration)
values('Eduardo', '12345678901', 'Aluno', 35, 100.99, 1.70, true, '1087-05-28', '17:30:00', '2022-11-27 09:27:00')

--Alterar um dado de uma coluna da tabela
update student 
set birth_date = '1987-05-28'
where id = 1

update student 
set birth_date = '1987-05-28'
where id = 1

select birth_date from student s
where id = 1

--Deletar um registro da tabela
select * from student s 
where "name" = 'Eduardo'

delete from student s 
where "name" = 'Eduardo'

--Selecionar colunas específicas
select "name", age, "height"
from student s 

--Selecionar com alias
select "name" as "Nome do aluno", 
		age as "Idade do aluno", 
		"height" as "Altura do aluno"
from student s 

select "name" as "Nome do aluno", 
		age as "Idade do aluno", 
		"height" as "Altura do aluno"
from student s 
where "name" = 'Maria'

---Filtros
--Igual
select * from student s 
where name = 'José'

--Diferente
select * from student s 
where name <> 'José'
--ou
select * from student s 
where name != 'José'

--Parecido
select * from student s 
where name like 'José'

--Finalizado como OSÉ
select * from student s 
where name like '_osé'

--Não Parecido
select * from student s 
where name not like 'José'

--Não finalizado como OSÉ
select * from student s 
where name like '_osé'

--Qualquer nome que comece com E
select * from student s 
where name like 'E%'

--Qualquer nome que termine com A
select * from student s 
where name like '%a'

--Qualquer nome que tem espaço
select * from student s 
where name like '% %'

--Que contem qualquer antes e depois do I e qualquer coisa antes e depois do A
select * from student s 
where name like '%i%a%'

--Filtrar por colunas null, só funciona com o IS null
select * from student s 
where registration is null

--Filtrar por colunas não null, só funciona com o IS NOT NULL
select * from student s 
where registration is not null

--Filtrar entre uma idade e outra
select * from student s 
where age between 30 and 35

--Filtrar com mais de uma condição AND
select * from student s 
where name like '%i%a%'
and registration is not null

--Filtrar com mais de uma condição OR
select * from student s 
where name like 'Maria%'
or name like 'Diego'
or name like 'E%'

---Chaves primárias
create table alunos (
	id SERIAL primary key,
	nome VARCHAR(255) not NULL
);

insert into alunos (nome) values ('Carlos');
insert into alunos (nome) values ('JOsé');
insert into alunos (nome) values ('Maria');
insert into alunos (nome) values ('Joana');

select * from alunos

create table cursos (
	id SERIAL primary key,
	nome VARCHAR(255) not null
)

insert into cursos (nome) values ('Java');
insert into cursos (nome) values ('TypeScript');
insert into cursos (nome) values ('CSharp');
insert into cursos (nome) values ('C++');

select * from cursos

-- Primary key composta
create table alunos_cursos (
	aluno_id INTEGER,
	curso_id INTEGER,
	primary key (aluno_id, curso_id)
)

insert into alunos_cursos (aluno_id, curso_id) values (1,1);
insert into alunos_cursos (aluno_id, curso_id) values (2,1);
insert into alunos_cursos (aluno_id, curso_id) values (2,1);

select * from alunos_cursos 
	
-- Foreing key
create table alunos_cursos (
	aluno_id INTEGER,
	curso_id INTEGER,
	primary key (aluno_id, curso_id),
	foreign key (aluno_id) references alunos (id),
	foreign key (curso_id) references cursos (id)
)

insert into alunos_cursos (aluno_id, curso_id) values (1,1);
insert into alunos_cursos (aluno_id, curso_id) values (2,1);

select * from alunos_cursos 

--- Joins
select * from alunos 
join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
join cursos 
on cursos.id = alunos_cursos.curso_id

insert into alunos_cursos (aluno_id, curso_id) values (2,2);

select alunos.nome as alunos,
	   cursos.nome as cursos
from alunos 
join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
join cursos 
on cursos.id = alunos_cursos.curso_id

-- Left join
insert into alunos (nome) values ('Mário');
insert into cursos (nome) values ('Python')

select alunos.nome as alunos,
	   cursos.nome as cursos
from alunos 
left join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
left join cursos 
on cursos.id = alunos_cursos.curso_id

-- Right join
select alunos.nome as alunos,
	   cursos.nome as cursos
from alunos 
right join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
right join cursos 
on cursos.id = alunos_cursos.curso_id

-- Full join
select alunos.nome as alunos,
	   cursos.nome as cursos
from alunos 
full join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
full join cursos 
on cursos.id = alunos_cursos.curso_id

-- Cross join 
select alunos.nome as "Nome do aluno",
	   cursos.nome as "Nome do curso"
from alunos
cross join cursos

--- Cascade delete
drop table alunos_cursos 

create table alunos_cursos (
	aluno_id INTEGER,
	curso_id INTEGER,
	primary key (aluno_id, curso_id),
	foreign key (aluno_id) references alunos (id)
	on delete cascade,
	foreign key (curso_id) references cursos (id)
)

insert into alunos_cursos (aluno_id, curso_id) values (1,1);
insert into alunos_cursos (aluno_id, curso_id) values (1,2);
insert into alunos_cursos (aluno_id, curso_id) values (2,1);
insert into alunos_cursos (aluno_id, curso_id) values (2,2);

delete from alunos where id = 1;

select alunos.nome as "Nome do aluno",
	   cursos.nome as "Nome do curso"
from alunos 
join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
join cursos 
on cursos.id = alunos_cursos.curso_id

--- Cascade update
drop table alunos_cursos 

create table alunos_cursos (
	aluno_id INTEGER,
	curso_id INTEGER,
	primary key (aluno_id, curso_id),
	foreign key (aluno_id) references alunos (id)
	on delete cascade
	on update cascade,
	foreign key (curso_id) references cursos (id)
)

insert into alunos_cursos (aluno_id, curso_id) values (1,1);
insert into alunos_cursos (aluno_id, curso_id) values (1,2);
insert into alunos_cursos (aluno_id, curso_id) values (2,1);
insert into alunos_cursos (aluno_id, curso_id) values (2,2);
insert into alunos_cursos (aluno_id, curso_id) values (3,4);
insert into alunos_cursos (aluno_id, curso_id) values (4,4);

delete from alunos where id = 1;

select alunos.id as "Id do aluno",
	   alunos.nome as "Nome do aluno",
	   cursos.id as "Id do curso",
	   cursos.nome as "Nome do curso"
from alunos 
join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
join cursos 
on cursos.id = alunos_cursos.curso_id

update alunos set id = 10
where id = 2

--- Consultas
drop table funcionarios 

create table funcionarios (
	id serial primary key,
	matricula varchar(10),
	nome varchar(100),
	sobrenome varchar(100)
	
);

insert into funcionarios (matricula, nome, sobrenome) values('M001', 'Diego', 'Nogueira');
insert into funcionarios (matricula, nome, sobrenome) values('M002', 'Marcela', 'Faria');
insert into funcionarios (matricula, nome, sobrenome) values('M003', 'Ricardo', 'Amorim');
insert into funcionarios (matricula, nome, sobrenome) values('M004', 'Maria', 'Mathias');
insert into funcionarios (matricula, nome, sobrenome) values('M005', 'Graziele', 'Amorim');
insert into funcionarios (matricula, nome, sobrenome) values('M006', 'Luiz', 'Roberto');

-- Ascendente por padrão
select * from funcionarios 
order by nome

-- Descendente
select * from funcionarios 
order by nome desc

-- Descendente
select * from funcionarios 
order by nome asc 

-- Ordenação com duas colunas
select * from funcionarios 
order by nome, sobrenome asc 

-- Ordenação pela posição do campo (4 - sobrenome)
select * from funcionarios 
order by 4

-- Ordenação por várias posições
select * from funcionarios 
order by 3, 4, 2

-- Ordenação específica
select * from funcionarios 
order by 4 desc, nome desc, 2

-- Evitando referência ambígua
select alunos.id as "Id do aluno",
	   alunos.nome as "Nome do aluno",
	   cursos.id as "Id do curso",
	   cursos.nome as "Nome do curso"
from alunos 
join alunos_cursos 
on alunos_cursos.aluno_id = alunos.id
join cursos 
on cursos.id = alunos_cursos.curso_id
order by alunos.nome desc, cursos.id 

--- Limite de dados
select * from funcionarios limit 3

-- ordenado
select * from funcionarios 
order by nome
limit 3

-- Paginação (trazendo desde o segundo registro limitado a 3)
select * from funcionarios 
order by nome
limit 3
offset 1

-- Paginação (trazendo desde o primeiro registro limitado a 3)
select * from funcionarios 
order by nome
limit 3
offset 0

--- Funções de agregação
-- Count 
select count(*) from funcionarios  

-- Count especificando o campo
select count(id) from funcionarios 

-- SUM Somando os ids
select count(id), 
sum(id)
from funcionarios 

-- MAX retornar o maior valor da coluna id
select count(id), 
sum(id),
max(id)
from funcionarios 

-- MIN retornar o menor valor da coluna id
select count(id), 
sum(id),
max(id),
min(id)
from funcionarios 

-- AVG retornar a média do valor da coluna id
select count(id), 
sum(id),
max(id),
min(id),
round(avg(id), 2)
from funcionarios 

--- Agrupamento de consultas
-- Evitar repetição de dados
select distinct sobrenome
from funcionarios 
order by sobrenome

-- Quando precisa de uma funcao de agregação (usar o group by)
select nome, sobrenome, count(id)
from funcionarios
group by nome, sobrenome
order by sobrenome

-- Indicando a posição da coluna na tabela
select nome, sobrenome, count(id)
from funcionarios
group by 1, 2
order by sobrenome

--- Filtros em consultas agrupadas
-- Saber se tem alunos matriculados
select * from cursos
left join alunos_cursos
on alunos_cursos.aluno_id = cursos.id 
left join alunos on alunos.id = alunos_cursos.aluno_id

-- Quantos alunos matriculados em cada curso
select cursos.nome, count(alunos.id) 
from cursos
left join alunos_cursos
on alunos_cursos.aluno_id = cursos.id 
left join alunos on alunos.id = alunos_cursos.aluno_id
group by 1

-- Usando o having cursos sem alunos
select cursos.nome, count(alunos.id) 
from cursos
left join alunos_cursos
on alunos_cursos.aluno_id = cursos.id 
left join alunos on alunos.id = alunos_cursos.aluno_id
group by 1
having count (alunos.id) = 0

-- Usando o having cursos com alunos
select cursos.nome, count(alunos.id) 
from cursos
left join alunos_cursos
on alunos_cursos.aluno_id = cursos.id 
left join alunos on alunos.id = alunos_cursos.aluno_id
group by 1
having count (alunos.id) > 0

/*
O comando TRUNCATE remove rapidamente todas as linhas de um conjunto de tabelas. Possui o mesmo efeito do comando DELETE 
não qualificado (sem a cláusula WHERE), mas como na verdade não varre a tabela é mais rápido. É mais útil em tabelas grandes.
*/

truncate test_01.department cascade;

truncate test_01.employee cascade;

truncate test_01.establishment cascade;  

truncate test_01.job_position cascade;  

truncate test_01.main_section cascade; 

truncate test_01.person cascade; 

truncate test_01.product_data cascade;  

truncate test_01.salary cascade; 

truncate test_01.subsection cascade; 

truncate test_01.user_data cascade;
