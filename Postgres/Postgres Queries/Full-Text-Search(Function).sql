
CREATE OR REPLACE FUNCTION fts(
    schema_name text,
    tbl_name text,
    col_name text,
    search_query text
) RETURNS SETOF jsonb AS
$$
DECLARE
    search_sql text;
BEGIN
    -- Construct the dynamic SQL query for full-text search using plainto_tsquery
    search_sql := 'SELECT to_jsonb(t) FROM ' || quote_ident(schema_name) || '.' || quote_ident(tbl_name) || 
                  ' t WHERE to_tsvector(COALESCE(' || quote_ident(col_name) || ', '''')) @@ plainto_tsquery($1)';

    -- Execute the query with the provided search query
    RETURN QUERY EXECUTE search_sql USING search_query;
END;
$$ LANGUAGE plpgsql;


--

-- '''search techniques'''
SELECT *
FROM fts('sdedba', 'ref_customer', 'customer_name', '''search techniques''');
-- Schema ,		table,		column ( to be searched), search critiria

-- 'search & techniques'
SELECT *
FROM fts('sdedba', 'ref_customer', 'customer_name', 'search & techniques');

-- 'search | techniques'
SELECT *
FROM fts('sdedba', 'ref_customer', 'customer_name', 'search | techniques');

