/*

Pregunta
===========================================================================

Escriba una consulta que retorne la primera columna, la cantidad de 
elementos en la columna 2 y la cantidad de elementos en la columna 3

Apache Hive se ejecutará en modo local (sin HDFS).

Escriba el resultado a la carpeta `output` de directorio de trabajo.

*/

DROP TABLE IF EXISTS t0;
CREATE TABLE t0 (
    c1 STRING,
    c2 ARRAY<CHAR(1)>, 
    c3 MAP<STRING, INT>
    )
    ROW FORMAT DELIMITED 
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY ','
        MAP KEYS TERMINATED BY '#'
        LINES TERMINATED BY '\n';
LOAD DATA LOCAL INPATH 'data.tsv' INTO TABLE t0;

/*
    >>> Escriba su respuesta a partir de este punto <<<
*/


-- INSERT OVERWRITE LOCAL DIRECTORY './output'
-- ROW FORMAT DELIMITED
-- FIELDS TERMINATED BY ','
SELECT c1, c2, count_c3
FROM (
    SELECT c1, c2, COUNT(map_value_c3) as count_c3
    FROM t0 
    LATERAL VIEW explode(c3) t0 AS map_key_c3, map_value_c3 
    GROUP BY c1, c2
) t0
LATERAL VIEW 
    explode(c2) t0
    ;
--GROUP BY c1;