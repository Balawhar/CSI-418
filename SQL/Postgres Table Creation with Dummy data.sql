-- Postgres Table Creation with Dummy data

CREATE TABLE test.BalawharTest1 (
    ID SERIAL PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phonenum BIGINT
);

INSERT INTO BalawharTest1 (Fname, Lname, email, phonenum) 
VALUES 
('John', 'Doe', 'john.doe@example.com', 1234567890),
('Jane', 'Doe', 'jane.doe@example.com', 2345678901),
('Alice', 'Smith', 'alice.smith@example.com', 3456789012),
('Bob', 'Brown', 'bob.brown@example.com', 4567890123),
('John', 'Doe', 'john.doe@example.com', 1234567890),
('Jane', 'Doe', 'jane.doe@example.com', 2345678901),
('Alice', 'Smith', 'alice.smith@example.com', 3456789012),
('Bob', 'Brown', 'bob.brown@example.com', 4567890123);

--------------------------------------------------------

CREATE TABLE test.BalawharTest2 (
    ID SERIAL PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phonenum BIGINT
);

INSERT INTO BalawharTest2 (Fname, Lname, email, phonenum) 
VALUES 
('Charlie', 'Johnson', 'charlie.johnson@example.com', 5678901234),
('David', 'Williams', 'david.williams@example.com', 6789012345),
('Emma', 'Jones', 'emma.jones@example.com', 7890123456),
('Fiona', 'Garcia', 'fiona.garcia@example.com', 8901234567),
('Charlie', 'Johnson', 'charlie.johnson@example.com', 5678901234),
('David', 'Williams', 'david.williams@example.com', 6789012345),
('Emma', 'Jones', 'emma.jones@example.com', 7890123456),
('Fiona', 'Garcia', 'fiona.garcia@example.com', 8901234567);

