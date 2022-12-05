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
