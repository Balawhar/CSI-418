-- Removing Duplicates with Partioning
-- test.BalawharTest1 (Id, Fname, Lname, email, phonenum)
-- test.BalawharTest2 (Id, Fname, Lname, email, phonenum)

WITH combined AS (
    SELECT t1.Id, t1.Fname, t1.Lname, t1.email, t1.phonenum
    FROM test.BalawharTest1 t1
    UNION ALL
    SELECT t2.Id, t2.Fname, t2.Lname, t2.email, t2.phonenum
    FROM test.BalawharTest2 t2
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Fname ORDER BY Id) AS rnk
    FROM combined
)
SELECT Id, Fname, Lname, email, phonenum
FROM ranked
WHERE rnk = 1
ORDER BY Id;
