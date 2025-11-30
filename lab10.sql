CREATE TABLE accounts (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          balance DECIMAL(10, 2) DEFAULT 0.00
);
CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          shop VARCHAR(100) NOT NULL,
                          product VARCHAR(100) NOT NULL,
                          price DECIMAL(10, 2) NOT NULL
);
-- Insert test data
INSERT INTO accounts (name, balance) VALUES
                                         ('Alice', 1000.00),
                                         ('Bob', 500.00),
                                         ('Wally', 750.00);
INSERT INTO products (shop, product, price)
VALUES
    ('Joe''s Shop', 'Coke', 2.50),
    ('Joe''s Shop', 'Pepsi', 3.00);

-- TASK 1
BEGIN;
UPDATE accounts SET balance = balance - 100.00
                WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 100.00
                WHERE name = 'Bob';
COMMIT;

-- a) ALICE 900  1000 - 100 = 900
-- BOB 600 500+100 = 600

-- b) Because it is one logical operation
-- c)  money disappears , database becomes inconsisten.

-- TASK 2
BEGIN;
UPDATE accounts SET balance = balance - 500.00
                WHERE name = 'Alice';
SELECT * FROM accounts WHERE name = 'Alice';
ROLLBACK;
SELECT * FROM accounts WHERE name = 'Alice';

--a) 1000 - 500 = 500
-- b ) Alice balance after Rollaback
-- c) Wrong amount entered and Logical mistake in code


-- TASK 3
BEGIN;
UPDATE accounts SET balance = balance - 100.00
                WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
                WHERE name = 'Bob';
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
                WHERE name = 'Wally';
COMMIT;

-- A) Alice 900  bob 500  wally 850
-- b) because operation SAVEPOINT after ROLLBACK
-- c) Allows partial rollback inside a large transaction.

-- Task 4

-- Terminal 1:

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;

-- Terminal 2
BEGIN;
DELETE FROM products WHERE shop = 'Joe''s Shop';
INSERT INTO products (shop, product, price)
VALUES ('Joe''s Shop', 'Fanta', 3.50);
COMMIT;

-- a ) Before commit: Coke, Pepsi . After commit: Fanta
-- b) Before: Coke, Pepsi . After: Coke, Pepsi
-- c) READ COMMITTED - sees new committed changes
-- SERIALIZABLE - prevents such interference, no phantoms

-- task 5
--  Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price), MIN(price) FROM products
                              WHERE shop = 'Joe''s Shop';

SELECT MAX(price), MIN(price) FROM products
WHERE shop = 'Joe''s Shop';
COMMIT;

--Terminal 2:
BEGIN;
INSERT INTO products (shop, product, price)
VALUES ('Joe''s Shop', 'Sprite', 4.00);
COMMIT;

-- a) NO
-- B) A transaction re-runs a SELECT with a condition and new rows appear that match the condition
-- C) SERIALIZABLE


-- TASK 6
-- Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to UPDATE but NOT commit
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to ROLLBACK
SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;
-- Terminal 2:
BEGIN;
UPDATE products SET price = 99.99
WHERE product = 'Fanta';
-- Wait here (don't commit yet)
-- Then:
ROLLBACK;

-- a) Yes
-- Because READ UNCOMMITTED allows reading uncommitted changes.
-- b) Reading data that was modified but not committed by another transaction.
-- c) Because it incorrect values and inconsistent reports

-- Exercise 1

BEGIN;

DO $$
    DECLARE
        bob_balance DECIMAL(10,2);
    BEGIN
        SELECT balance INTO bob_balance FROM accounts WHERE name = 'Bob';
        IF bob_balance < 200 THEN
            RAISE EXCEPTION 'Insufficient funds';
        END IF;
        UPDATE accounts SET balance = balance - 200 WHERE name = 'Bob';
        UPDATE accounts SET balance = balance + 200 WHERE name = 'Wally';
    END $$;

COMMIT;


-- Exercise 2

BEGIN;

INSERT INTO products (shop, product, price)
VALUES ('Joe''s Shop', 'Tea', 2.00);
SAVEPOINT sp1;
UPDATE products SET price = 3.00
WHERE product = 'Tea';
SAVEPOINT sp2;
DELETE FROM products WHERE product = 'Tea';
ROLLBACK TO sp1;
COMMIT;





