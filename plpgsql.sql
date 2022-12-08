--- Linguagem procedural PLPGSQL
-- funcao que retorna um valor
create or replace function primeira_pl() returns integer as $$
	begin
		
		return 1;
	end;
	
$$ language plpgsql;

select primeira_pl();

--- Criar variáveis (declare)
create or replace function primeira_pl() returns integer as $$

	declare 
		primeira_variavel integer default 3;
	begin
		
		return primeira_variavel;
	end;
	
$$ language plpgsql;

select primeira_pl();

-- Manipulação de variável
create or replace function primeira_pl() returns integer as $$

	declare 
		primeira_variavel integer default 3;
	begin
		primeira_variavel := primeira_variavel * 2;
		return primeira_variavel;
	end;
	
$$ language plpgsql;

select primeira_pl();

-- criando subblocos (mesmo atribuindo 7 a variável primeira_variavel, o resultado continua 6, 
--pois a variável do bloco de dentro é considerada outra variável e será considerada a do bloco externo)
create or replace function primeira_pl() returns integer as $$

	declare 
		primeira_variavel integer default 3;
	begin
		primeira_variavel := primeira_variavel * 2;
	
		declare 
			primeira_variavel integer;
		begin
			
			primeira_variavel := 7;
			
		end;
	
		return primeira_variavel;
		
	end;
	
$$ language plpgsql;

select primeira_pl();

-- para considerar o 7, tiramos o declare do bloco interno
create or replace function primeira_pl() returns integer as $$

	declare 
		primeira_variavel integer default 3;
	begin
		primeira_variavel := primeira_variavel * 2;
	
		begin
			
			primeira_variavel := 7;
			
		end;
	
		return primeira_variavel;
		
	end;
	
$$ language plpgsql;

select primeira_pl();

--- Criando funcoes void
create table a (nome varchar(255) not null);
drop function if exists cria_a;
create or replace function cria_a(nome varchar) returns void as $$
	begin 
		insert into a (nome) values ('Patrícia');
	end
	
$$ language plpgsql

select * from a;
select cria_a('Vinicius Dias');

--- Retornando um tipo composto
create or replace function cria_instrutor_falso() returns instrutor as $$
	begin 
		return row(22, 'Nome falso', 200::decimal)::instrutor;
	end
	
$$ language plpgsql
select id, salario from cria_instrutor_falso(); 

--- Atribuindo o retorno a variável "retorno"
create or replace function cria_instrutor_falso() returns instrutor as $$
	declare 
		retorno instrutor;
	begin 
		select 22, 'Nome falso', 200::decimal into retorno;
		return retorno;
	end
	
$$ language plpgsql
select id, salario from cria_instrutor_falso(); 

--- Utilizando em funcoes com setof retornando todos os dados
drop function instrutores_bem_pagos;
create function instrutores_bem_pagos (valor_salario decimal) returns setof instrutor as $$
	begin
		return query select * from instrutor where salario > valor_salario;
	end;
	
$$ language plpgsql;

select * from instrutores_bem_pagos (300);

--- Utilizando if e else (mais performática)
create function salario_ok(instrutor instrutor) returns varchar as $$
	begin
		
		if instrutor.salario > 200 then
			return 'Salário está ok';
		else
			return 'Salário pode aumentar';
		end if;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor) from instrutor;

--- Outros exemplos if else (menos performática)
drop function salario_ok;
create function salario_ok(id_instrutor integer) returns varchar as $$
	declare
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 200 then
			return 'Salário está ok';
		else
			return 'Salário pode aumentar';
		end if;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

--- Trabalhando dentro do else
drop function salario_ok;
create or replace function salario_ok(id_instrutor integer) returns varchar as $$
	declare
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 200 then
			return 'Salário está ok';
		else
			if instrutor.salario = 300 then
			
				return 'Salário pode aumentar';
			else
				return 'Salário está defasado';
			end if;
		end if;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

--- Usando o elseif
drop function salario_ok;
create or replace function salario_ok(id_instrutor integer) returns varchar as $$
	declare
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 200 then
			return 'Salário está ok';
		elseif instrutor.salario = 300 then
			return 'Salário pode aumentar';
		else
			return 'Salário está defasado';
		end if;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

--- Usando o case
drop function salario_ok;
create or replace function salario_ok(id_instrutor integer) returns varchar as $$
	declare
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		case
			when instrutor.salario = 100 then
				return 'Salário muito baixo';
			when instrutor.salario = 200 then
				return 'Salário baixo';
			when instrutor.salario = 300 then
				return 'Salário ok';
			else
				return 'Salário ótimo';
			end case;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

--- Simplificando o case
drop function salario_ok;
create or replace function salario_ok(id_instrutor integer) returns varchar as $$
	declare
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		case instrutor.salario
			when 100 then
				return 'Salário muito baixo';
			when 200 then
				return 'Salário baixo';
			when 300 then
				return 'Salário ok';
			else
				return 'Salário ótimo';
			end case;
	end;
	
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;