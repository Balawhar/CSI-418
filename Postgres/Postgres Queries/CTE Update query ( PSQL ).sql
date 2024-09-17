-- CTE Update query

WITH numbered_rows AS (
    SELECT k.*,
           ROW_NUMBER() OVER (ORDER BY 1) AS rn
    FROM ssdx_eng.v_mechanic_info k
    WHERE equipment_model_name IS NOT NULL -- Optional: filter to avoid updating NULL values
)
UPDATE ssdx_eng.v_mechanic_info a
SET equipment_model_name = CASE
    WHEN rn % 20 = 1 THEN 'TOY'
    WHEN rn % 20 = 2 THEN 'HON'
    WHEN rn % 20 = 3 THEN 'FOR'
    WHEN rn % 20 = 4 THEN 'CHE'
    WHEN rn % 20 = 5 THEN 'BMW'
    WHEN rn % 20 = 6 THEN 'MB'
    WHEN rn % 20 = 7 THEN 'AUD'
    WHEN rn % 20 = 8 THEN 'VW'
    WHEN rn % 20 = 9 THEN 'NIS'
    WHEN rn % 20 = 10 THEN 'HYU'
    WHEN rn % 20 = 11 THEN 'KIA'
    WHEN rn % 20 = 12 THEN 'SUB'
    WHEN rn % 20 = 13 THEN 'MAZ'
    WHEN rn % 20 = 14 THEN 'LEX'
    WHEN rn % 20 = 15 THEN 'JAG'
    WHEN rn % 20 = 16 THEN 'POR'
    WHEN rn % 20 = 17 THEN 'TES'
    WHEN rn % 20 = 18 THEN 'VOL'
    WHEN rn % 20 = 19 THEN 'LR'
    WHEN rn % 20 = 0 THEN 'MIT'
END
FROM numbered_rows nr
WHERE a.transaction_id = nr.transaction_id -- Assuming 'id' is the primary key
AND nr.rn <= 200;
