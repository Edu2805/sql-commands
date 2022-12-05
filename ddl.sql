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

--- Renomear uma tabela
alter table a rename to teste;

--- Renomear uma coluna
alter table teste rename coluna1 to primeira_coluna;


