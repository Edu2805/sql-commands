--- Criando funcoes com retorno
-- o select retorna o valor
create function primeira_funcao() returns integer as '
	select (5 - 3) * 2
' language sql;

select * from primeira_funcao() as "Resultado";

create function soma_dois_numeros(numero_1 integer, numero_2 integer) returns integer as '
	select numero_1 + numero_2;
'language sql;

select soma_dois_numeros(2,2) as "Resultado";
select soma_dois_numeros(3,17) as "Resultado";

-- sem informar os parametros
create function soma_dois_numeros2(integer, integer) returns integer as '
	select $1 + $2;
'language sql;

select soma_dois_numeros2(2,2) as "Resultado";
select soma_dois_numeros2(3,17) as "Resultado";

-- deletar uma function
drop function soma_dois_numeros2

--- Inserindo valores em uma tabela utilizando funcoes
create table tabela (
	nome varchar(255) not null
)

create function cria_valor_texto(nome varchar) returns varchar as '
	insert into tabela(nome) values(cria_valor_texto.nome);

	select nome;
' language sql;

select cria_valor_texto('Eduardo') as "Nome";

-- usando o create or replace 
create or replace function cria_valor_texto(nome varchar) returns varchar as '
	insert into tabela(nome) values(cria_valor_texto.nome);

	select nome;
' language sql;


--- Criando funcoes sem retorno
drop function cria_valor_texto;
create or replace function cria_valor_texto(nome varchar) returns void as '
	insert into tabela(nome) values(cria_valor_texto.nome);
' language sql;

select cria_valor_texto('Eduardo') as "Nome"; -- devolve nulo

select * from tabela

--- Inserindo texto direto dentro da funcao
create or replace function cria_valor_texto2(nome varchar) returns void as $$
	insert into tabela(nome) values('João');
$$ language sql;

select * from tabela

-- funcao que retorna o dobro do salário do instrutor
create table instrutor (
	id serial primary key,
	nome varchar(255) not null,
	salario decimal(10,2)
)

insert into instrutor (nome, salario) values('Vinícius Dias', 100);

create function dobro_salario(instrutor) returns decimal as $$
	select $1.salario * 2 as dobro;
$$ language sql;

select nome as "Nome instrutor", dobro_salario(instrutor.*) as "Salário dobrado"from instrutor 

--- Retornar uma tabela na funcao (retornar um valor que não existe na tabela)
-- sem inserir alias e sem from no select retorna os dados em uma única coluna
create or replace function cria_instrutor_falso() returns instrutor as $$
	select 22, 'Nome falso', 200::decimal;
$$ language sql;

select cria_instrutor_falso();

-- inserindo o from no select e sem alias, ele separa por coluna
create or replace function cria_instrutor_falso() returns instrutor as $$
	select 22, 'Nome falso', 200::decimal;
$$ language sql;

select * from cria_instrutor_falso();


-- passando os alias corretamente sem passar o from, ele separada as colunas
create or replace function cria_instrutor_falso() returns instrutor as $$
	select 22 as id, 'Nome falso' as nome, 200::decimal as salario;
$$ language sql;

select cria_instrutor_falso();

-- retornando colunas específicas
select id, salario from cria_instrutor_falso();

--- Retornar mais de um valor em uma funcao usando o setof
--retornando os salários acima de 300
insert into instrutor (nome, salario) values('Carlos José', 200);
insert into instrutor (nome, salario) values('Ricardo Almeida', 150);
insert into instrutor (nome, salario) values('Maria Regina', 400);
insert into instrutor (nome, salario) values('Juliana faria', 500);

create function instrutores_bem_pagos(valor_salario decimal) returns setof instrutor as $$
	select * from instrutor where salario > valor_salario;
$$ language sql;

select * from instrutores_bem_pagos(300);

-- usando o retorno da funcao como record, retorno genérico passando o out
drop function instrutores_bem_pagos;
create function instrutores_bem_pagos(valor_salario decimal, out nome varchar, out salario decimal) returns setof record as $$
	select nome, salario from instrutor where salario > valor_salario;
$$ language sql;

select * from instrutores_bem_pagos(300);

-- usando o out como retorno da funcao
create function soma_e_produto (in numero_1 integer, in numero_2 integer, out soma integer, out produto integer) as $$
	select numero_1 + numero_2 as soma, numero_1 * numero_2 as produto;
$$ language sql;

select * from soma_e_produto(3,3);

-- enxugando a escrita do retorno da funcao criando antes um type
create type dois_valores as (soma integer, produto integer);

drop function soma_e_produto;

create function soma_e_produto (in numero_1 integer, in numero_2 integer) returns dois_valores as $$
	select numero_1 + numero_2 as soma, numero_1 * numero_2 as produto;
$$ language sql;

select * from soma_e_produto(3,3);