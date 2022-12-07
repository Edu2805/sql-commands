---- DDL ----

--- Criar database
create database modelagem_dados;

--- Criar schema
create schema academico;

create table academico.aluno (
	id serial primary key,
	primeiro_nome varchar(255) not null,
	ultimo_nome varchar(255) not null,
	data_nascimento date not null
);

create table academico.categoria (
	id serial primary key,
	nome varchar(255) not null unique
);

create table academico.curso (
	id serial primary key,
	nome varchar(255) not null,
	categoria_id integer not null references academico.categoria(id)
);

create table academico.aluno_curso (
	aluno_id integer not null references academico.aluno(id),
	curso_id integer not null references academico.curso(id),
	primary key (aluno_id, curso_id)
);


--- Sintaxe CREATE TABLE 
-- Criar a tabela caso existir
create table if not exists academico.aluno (
	id serial primary key,
	primeiro_nome varchar(255) not null,
	ultimo_nome varchar(255) not null,
	data_nascimento date not null
);

-- Criar com valores default
create table if not exists academico.aluno (
	id serial primary key,
	primeiro_nome varchar(255) not null default 'Sem nome',
	ultimo_nome varchar(255) not null default 'Sem sobrenome',
	data_nascimento date not null default now()::date
);

-- Check (verifica algo, no caso, verifica se o primeiro nome é vazio)
create table if not exists academico.aluno (
	id serial primary key,
	primeiro_nome varchar(255) not null check (primeiro_nome <> ''),
	ultimo_nome varchar(255) not null default 'Sem sobrenome',
	data_nascimento date not null default now()::date
);

-- Criar uma tabela temporária
create temporary table academico.aluno (
	id serial primary key,
	primeiro_nome varchar(255) not null,
	ultimo_nome varchar(255) not null,
	data_nascimento date not null
);

insert into academico.aluno (primeiro_nome, ultimo_nome, data_nascimento) 
values ('Carlos', 'Alberto', '1980-10-11'),
('José', 'Ricardo', '1985-02-15'),
('Maria', 'Roberta', '1990-11-11'),
('Vânia', 'Mathias', '1995-05-20'),
('Diogo', 'Nogueira', '1988-06-28');

select * from academico.aluno a 

insert into academico.categoria (nome) 
values('UX Designer'), ('Desenvolvimento'), 
('DevOps'), ('Data Science'), 
('Backend'), ('Frontend');

select * from academico.categoria 

insert into academico.curso (nome, categoria_id) 
values ('Java', 4), ('TypeScript', 5), ('GitLab', 2),
('Banco de dados', 2), ('Desenvolvimento FullStack', 1);

select * from academico.curso 

insert into academico.aluno_curso values (1,5), (5, 4), (2, 2), (3, 5), (4, 3);

--- Renomear uma tabela
alter table a rename to teste;

--- Renomear uma coluna
alter table teste rename coluna1 to primeira_coluna;

--- Criar um relatório com tabela temporária
create temporary table cursos_programacao (
	id_curso integer primary key,
	nome_curso varchar(255) not null
);

-- Inserindo valores através de um select (no select dos parametros precisam estar na mesma ordem)
insert into cursos_programacao
select c.id, c.nome 
	from academico.curso c 
	where c.categoria_id = 2;

select * from cursos_programacao

--- Importação de arquivos Obs: usar o arquivo cursos.csv neste repositório, encontrar no seu gerenciador de banco de dados a opção import e escolher para importar como CSV
create schema teste;

create table teste.cursos_programacao (
	id_curso integer primary key,
	nome_curso varchar(255) not null
);

insert into teste.cursos_programacao
select c.id, c.nome 
	from academico.curso c 
	where c.categoria_id = 2;

select * from teste.cursos_programacao

--- Exportação de dados. Obs: usar os recursos de exportação do seu gerenciador de banco de dados, o arquivo exemplo é exportado.txt

--- Comandos UPDATE
select * from academico.curso c order by 1
select * from teste.cursos_programacao cp order by 1

update academico.curso set nome = 'Java Avançado' where id = 1;
update academico.curso set nome = 'TypeScript Avançado' where id = 2;
update academico.curso set nome = 'GitLab Avançado' where id = 3;
update academico.curso set nome = 'Banco de dados Avançado' where id = 4;

-- sincronizar as artualizações com a tabela cursos_programacao do schema teste
update teste.cursos_programacao set nome_curso = nome
	from academico.curso where teste.cursos_programacao .id_curso = academico.curso.id 

--- Transações (o postgres já faz isso por de trás dos panos)
-- Começando e comitando uma transação (begin commit)
-- Durante o begin, é possível voltar atrás na transação com o rollback
begin 
	delete from teste.cursos_programacao cp 
	rollback;

select * from teste.cursos_programacao cp 

-- o commit efetiva a transação
begin 
	delete from teste.cursos_programacao cp 
	commit;

select * from teste.cursos_programacao cp 


--- Criar um id sequencial (postgres já faz isso por de trás dos panos)
create sequence sequencia; -- da inicio a sequencia

select nextval('sequencia'); -- avança na sequencia

select currval('sequencia'); -- mostra a sequencia atual

create temporary table auto (
	id integer primary key default nextval('sequencia'), -- insere o nextval
	nome varchar(30) not null
);

insert into auto (nome) values ('Teste auto');

select * from auto -- Obs: se o sequence já rodou individualmente, a sequencia irá começar de onde parou a ultima execução do sequence


--- Criar tipo ENUM
create type CLASSIFICACAO
as enum ('LIVRE', '12_ANOS', '14_ANOS', '16_ANOS', '18_ANOS');


create temporary table filme (
	id serial primary key,
	nome varchar(255) not null,
	classificacao CLASSIFICACAO
);

insert into filme (nome, classificacao) values ('Um filme', '14_ANOS');

select * from filme
