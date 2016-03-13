DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp WITHOUT TIME ZONE,
    g geometry
);


DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (
    id int,
    s_time TIMESTAMP WITHOUT TIME ZONE,
    e_time TIMESTAMP WITHOUT TIME ZONE,
    bbox GEOMETRY,
    tr_data tg_pair[]);

DROP FUNCTION IF EXISTS _trajectory(int, tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory(int, tg_pair[]) RETURNS trajectory AS
$BODY$
DECLARE
  t trajectory;
BEGIN
    t.id = $1;
    t.bbox = findMbr($2);
    t.e_time = findendtime($2);
    t.s_time = findstarttime($2);
    t.tr_data = array_sort($2);
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';