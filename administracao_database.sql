--- Vacuum - Postgres já faz por de trás dos panos

DROP TABLE instrutor;
CREATE TABLE instrutor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    salario DECIMAL(10, 2)
);
SELECT COUNT(*) FROM instrutor;
DO $$
    DECLARE
    BEGIN
        FOR i IN 1..1000000 LOOP
            INSERT INTO instrutor (nome, salario) VALUES ('Instrutor(a) ' || i, random() * 1000 + 1);
        END LOOP;
    END;
$$;
UPDATE instrutor SET salario = salario * 2 WHERE id % 2 = 1;
DELETE FROM instrutor WHERE id % 2 = 0;
VACUUM ANALYSE instrutor;

SELECT relname, n_dead_tup FROM pg_stat_user_tables;
SELECT pg_size_pretty(pg_relation_size('instrutor'));

/*
O VACUUM normalmente só é utilizado quando o autovacuum por algum motivo não fizer seu trabalho. 
Já o VACUUM FULL é utilizado quando temos muito desperdício de espaço. 
Normalmente quando a maioria dos registros de uma tabela já foram excluídos ou alterados. 
Agora o ANALYSE é um comando a parte. Então o VACUUM faz seu trabalho e depois 
chama esse outro comando para que ele possa analisar a estrutura e os dados das tabelas 
e atualizar as estatísticas para o planejador de query.
*/

--- Atualização dos indices de tabela (reindexação do banco de dados)

reindex table instrutor

/*
 * uando temos muita modificação sendo feita numa tabela ou na base de dados como um todo, 
 * é interessante reindexar. É um processo relativamente demorado, mas que atualiza a tabela de 
 * índices do PostgreSQL. Ou seja, basicamente ele está dizendo “dá uma limpada no que temos de 
 * informação, não só nas estatísticas, mas como está armazenado a relação entre uma chave 
 * primária e sua linha”. 
 */

--- Realizando backup
/* Ferramentas gráficas fazem o backup, porém é recomendado fazer pela linha de comando usando o pg_dump
 * Esse comando é seguido do caminho onde vc deseja salvar esse backup + o nome do arquivo e extensão + o banco de dados
 * 
 * usar o pg_dump --help para verificar as opções
 */

-- comando
-- pg_dump -f /tmp/dump.sql database_name

/* É possível agendar backup na linha de comando
 */

--- Resturar um backup (comando pg_restore), duvidas pd_restore --help
-- pg_restore -d database_name /caminho_do_backup.sql
--Obs: o restore não funciona para arquivos sql, se o backup for sql, usar o comando abaixo

-- na linha de comando usar (psql database_name < /caminho_do_backup.sql)

--############################################
--- Performance com muitos dados
-- Fazendo o postgres "Explicar" como ele executa uma query (explain)

explain select * from instrutor i where salario > 500;

/* com a informação dessa query, podemos ter resposta se o postgres está realizando consultas de forma performática
 * fazendo que possamos tomar ações para tornar consultas mais rápidas
 */

--- Criando indices
create index idx_salario on instrutor(salario);
drop index idx_salario

-- se fizermos uma nova consulta com select em uma tabela que levava mais tempo para mostrar os dados, agora com indices vai mostrar mais rápido
select * from instrutor i where salario > 500;

explain select * from instrutor i where salario > 500;

/* Sobre indices
Em queries simples, índices podem acabar informando ao PostgreSQL que mais trabalho precisa ser feito, 
deixando a query mais custosa. Use índices com moderação.
Sempre que eu inserir, atualizar ou remover um registro, os índices precisar ser reorganizados. 
Isso custa tempo e processamento.
*/

