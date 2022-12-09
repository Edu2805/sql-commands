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

--- Estruturas de repetição usando o next(setof - conjunto de inteiros)
drop function tabuada;
create or replace function tabuada(numero integer) returns setof integer as $$
	declare
	begin
		
		return next numero * 1;
		return next numero * 2;
		return next numero * 3;
		return next numero * 4;
		return next numero * 5;
		return next numero * 6;
		return next numero * 7;
		return next numero * 8;
		return next numero * 9;
		return next numero * 10;
	end;
	
$$ language plpgsql;

select tabuada(2);

--- Estruturas de repetição usando o loop(setof - conjunto de inteiros)
drop function tabuada;
create or replace function tabuada(numero integer) returns setof integer as $$
	declare
		multiplicador integer default 1;
	begin
		loop
			return next numero * multiplicador;
			multiplicador := multiplicador + 1;
			exit when multiplicador = 11;
		end loop;
	end;
	
$$ language plpgsql;

select tabuada(2);

--- Formatando a saída (9 x 1 = 9)
drop function tabuada;
create or replace function tabuada(numero integer) returns setof varchar as $$
	declare
		multiplicador integer default 1;
	begin
		loop
			return next numero || ' * ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
			exit when multiplicador = 11;
		end loop;
	end;
	
$$ language plpgsql;

select tabuada(2);

--- Estruturas de repetição usando o while loop(setof - conjunto de inteiros)
drop function tabuada;
create or replace function tabuada(numero integer) returns setof varchar as $$
	declare
		multiplicador integer default 1;
	begin
		while multiplicador <= 10 loop
			return next numero || ' * ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
		end loop;
	end;
	
$$ language plpgsql;

select tabuada(2);

--- Estruturas de repetição usando o for in loop(setof - conjunto de inteiros)
drop function tabuada;
create or replace function tabuada(numero integer) returns setof varchar as $$
	begin
		for multiplicador in 1..10 loop
			return next numero || ' * ' || multiplicador || ' = ' || numero * multiplicador;
		end loop;
	end;
	
$$ language plpgsql;

select tabuada(5);

--- Ciando um loop em uma query e chamando uma plpgsql dentro de outra (salario_ok)
drop function instrutor_com_salario;
create or replace function instrutor_com_salario(out nome varchar, out salario_ok varchar) returns setof record as $$
	declare 
		instrutor instrutor;
	begin 
		for instrutor in select * from instrutor loop
			nome := instrutor.nome;
			salario_ok = salario_ok(instrutor.id);
			return next;
		end loop;
	end;
$$ language plpgsql;

select * from instrutor_com_salario();

---- Inserindo valores nas tabelas com funcoes

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

-- usando o found (verifica se algum resultado foi retornado pela query)
create function cria_curso(nome_curso varchar, nome_categoria varchar) returns void as $$
	declare
		id_categoria integer;
	begin
		select id into id_categoria from categoria where nome = nome_categoria;
	
		if not found then
			insert into categoria (nome) values (nome_categoria) returning id into id_categoria;
		end if;
		
		insert into curso (nome, categoria_id) values (nome_curso, id_categoria);
	end;
$$ language plpgsql;

select cria_curso('PHP', 'Programação');
select cria_curso('Java', 'Programação');
select cria_curso('PHP', 'Programação');
select cria_curso('PHP', 'Programação');

select * from curso;
select * from categoria;

/**
 * Inserindo dados na tabela instrutores, lógica para verificar se o salário for maior que a média, 
 * salva um log e salva outro log dizendo que fulano recebe mais de x% da grade de instrutores
 */

create table log_instrutores (
	id serial primary key,
	informacao varchar(255),
	momento_criado timestamp default current_timestamp
);

create or replace function cria_instrutor (nome_instrutor varchar, salario_instrutor decimal) returns void as $$
	declare 
		id_instrutor_inserido integer;
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		insert into instrutor (nome, salario) values (nome_instrutor, salario_instrutor) returning id into id_instrutor_inserido;
	
		select avg(instrutor.salario) into media_salarial from instrutor where id <> id_instrutor_inserido;
		if salario_instrutor > media_salarial then
			insert into log_instrutores (informacao) values (nome_instrutor || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> id_instrutor_inserido loop
			total_instrutores := total_instrutores + 1;
			
			if salario_instrutor > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao) 
			values (nome_instrutor || ' recebe mais do que ' || percentual || '% da grade de instrutores');
	end;
$$ language plpgsql;

select * from instrutor i;
select cria_instrutor('Carlos', 400);
select * from log_instrutores;

--- Evitando que seja feito um insert sem executada a funcao, sem passar pelos logs usando Triggers
-- editando a funcao anterior
drop function cria_instrutor;

create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao) 
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	end;
$$ language plpgsql;

-- criando uma trigger
create trigger cria_log_instrutores after insert on instrutor 
	for each row execute function cria_instrutor();

-- inserindo dados na tabela instrutor onde irá disparar a trigger pra criar os logs
select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Charles', 700);

--- Otimizando os logs (caso alguma coisa acontecer no meio do caminho, rollback)
-- O postgres faz begin, commit e rollback sozinho
create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao) 
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	end;
$$ language plpgsql;

select * from log_instrutores;
select * from instrutor i;

-- postgres faz sozinho
begin;
insert into instrutor (nome, salario) values ('Guimaraes', 600);
rollback;

--- Capturar erros
create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	exception
		when undefined_column then -- tipo do erro (pesquisar na documentacao do postgres)
			return new; -- opcional
		
	end;
$$ language plpgsql;

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Gilberto', 1500);

--- Exibindo mensagem de erro para as exceções
create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	exception
		when undefined_column then -- tipo do erro (pesquisar na documentacao do postgres)
			raise notice 'Atenção! Devido a um erro na função de inserção, registro não será inserido na tabela de logs! Consulte o administrador do DB.';
			return new; -- opcional
		
	end;
$$ language plpgsql;

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Ana Roberta', 1500);

--- Exibindo mensagem de erro para as exceções e interrompendo a execução
create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	exception
		when undefined_column then -- tipo do erro (pesquisar na documentacao do postgres)
			raise notice 'Atenção! Devido a um erro na função de inserção, registro não será inserido na tabela de logs! Consulte o administrador do DB.';
			raise exception 'Falal error!'; -- interrompe o processo fazendo o rollback
		
	end;
$$ language plpgsql;

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Jair', 1200);

--- Cancelando a inserção de um instrutor caso o salário atinja um percentual
drop trigger cria_log_instrutores on instrutor;

create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
		assert percentual < 100::decimal, 'Instrutores novos não podem receber mais do que os antigos'; -- lanca a condição pra barrar a insercao junto de uma mensagem
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	end;
$$ language plpgsql;

create trigger cria_log_instrutores before insert on instrutor 
	for each row execute function cria_instrutor(); -- ANTES de inserir o instrutor, será feita a verificacao

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Jair José', 1600);

--- "Debugar" a funcao com Raise notice passando as variáveis
drop trigger cria_log_instrutores on instrutor;

create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		for salario in select instrutor.salario from instrutor where id <> new.id loop
			total_instrutores := total_instrutores + 1;
			
			raise notice 'Salario inserido: % Salário do instrutor existente: %', new.salario, salario; -- insere na mensagem os valores do for para serem exibidos no console
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
		assert percentual < 100::decimal, 'Instrutores novos não podem receber mais do que os antigos'; -- lanca a condição pra barrar a insercao junto de uma mensagem
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	end;
$$ language plpgsql;

create trigger cria_log_instrutores before insert on instrutor 
	for each row execute function cria_instrutor(); -- ANTES de inserir o instrutor, será feita a verificacao

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Jair José', 500);

--- Cursores (encapsula uma query e melhora o desempenho da funcao) postgres já faz por de trás dos panos no for
-- supondo que uma determinada query seja muito grande
create function instrutores_internos(id_instrutor integer) returns refcursor as $$
	declare
		cursor_salario refcursor;
	begin
		open cursor_salario for select instrutor.salario 
									from instrutor 
									where id <> id_instrutor 
									and salario > 0;
		
		return cursor_salario;
	end;
$$ language plpgsql;

-- chamando o cursor na funcao principal
create or replace function cria_instrutor () returns trigger as $$
	declare 
		media_salarial decimal;
		instrutores_recebem_menos integer default 0;
		total_instrutores integer default 0;
		salario decimal;
		percentual decimal(5, 2);
		cursor_salario refcursor;
	begin 
		select avg(instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
		if new.salario > media_salarial then
			insert into log_instrutores (informacao) values (new.nome || ' recebe acima da média');
		end if;
	
		select instrutores_internos(new.id) into cursor_salario;
		loop
			fetch cursor_salario into salario;
			exit when not found;
			total_instrutores := total_instrutores + 1;
			
			if new.salario > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
	
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
		assert percentual < 100::decimal, 'Instrutores novos não podem receber mais do que os antigos'; -- lanca a condição pra barrar a insercao junto de uma mensagem
	
		insert into log_instrutores (informacao, teste) -- coluna que não existe pra forçar o erro, com o exception essa parte será ignorada
			values (new.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		return new;
	end;
$$ language plpgsql;

select * from log_instrutores;
select * from instrutor i;

insert into instrutor (nome, salario) values ('Camila', 5000);