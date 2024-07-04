-- Full-Text search

SELECT
    product_id,
    name,
    description,
    ts_rank_cd(to_tsvector(description), to_tsquery('search_term')) AS rank
FROM
    products
WHERE
    to_tsvector(description) @@ to_tsquery('search_term')
ORDER BY
    rank DESC;

-- This query performs a full-text search on the description field and ranks the results based on relevance.

