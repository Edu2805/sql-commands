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
