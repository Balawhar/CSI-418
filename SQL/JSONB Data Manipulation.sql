-- JSONB Data Manipulation

SELECT
    id,
    data->>'name' AS name,
    data->>'age' AS age,
    jsonb_array_elements(data->'hobbies') AS hobby
FROM
    users
WHERE
    data->'address'->>'city' = 'New York';

-- This query extracts and manipulates data stored in JSONB format,
-- filtering users based in New York and expanding their hobbies into separate rows