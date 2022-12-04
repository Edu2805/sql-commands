--- Criar uma view
create view vw_cursos_por_categoria as select categoria.nome as categoria,
	count(curso.id) as numero_cursos
from categoria
join curso on curso.categoria_id = categoria.id 
group by categoria

select * from vw_cursos_por_categoria

-- Manipulando a view
select categoria 
from vw_cursos_por_categoria as categoria_cursos
where numero_cursos >= 2

--- Criando outra view
create view vw_cursos_programacao as select nome from curso
where categoria_id = 2;

select * from vw_cursos_programacao

-- refinando a busca
select * from curso c 
select * from vw_cursos_programacao where nome = 'GitLab'

-- fazendo join entre view e tabela
select categoria.id as categoria_id, vw_cursos_por_categoria.*
from vw_cursos_por_categoria
join categoria on categoria.nome = vw_cursos_por_categoria.categoria 