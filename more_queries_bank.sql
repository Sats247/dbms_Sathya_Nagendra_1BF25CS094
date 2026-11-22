CREATE DATABASE bank_enterprise_morequeries_1BF25CS094
USE bank_enterprise;

CREATE TABLE branch (
  branch_name VARCHAR(100),
  branch_city VARCHAR(100),
  assets DECIMAL(15,2) NOT NULL CHECK (assets >= 0),
  PRIMARY KEY (branch_name)
);
CREATE TABLE bank_customer (
  customer_name VARCHAR(100),
  customer_street VARCHAR(100),
  customer_city VARCHAR(100),
  PRIMARY KEY (customer_name)
);
CREATE TABLE bank_account (
  account_number INT,
  branch_name VARCHAR(100),
  balance DECIMAL(12,2) CHECK (balance >= 0),
  PRIMARY KEY (account_number),
  FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);
CREATE TABLE depositor (
  customer_name VARCHAR(100),
  account_number INT,
  PRIMARY KEY (customer_name, account_number),
  FOREIGN KEY (customer_name) REFERENCES bank_customer(customer_name),
  FOREIGN KEY (account_number) REFERENCES bank_account(account_number)
);
CREATE TABLE loan (
  loan_number INT,
  branch_name VARCHAR(50) NOT NULL,
  amount DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
  PRIMARY KEY (loan_number),
  FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO branch VALUES
('SBI_ResidencyRoad','Bangalore',5000000),
('SBI_Jayanagar','Bangalore',7500000),
('SBI_Chamrajpet','Bangalore',3000000),
('SBI_Mantralaya','DELHI',9000000),
('SBI_parliamentstrt','DELHI',1200000);
INSERT INTO bank_account VALUES
(1001,'SBI_ResidencyRoad',15000),(1002,'SBI_ResidencyRoad',22000),
(1003,'SBI_Jayanagar',18000),(1004,'SBI_Chamrajpet',9000),
(1005,'SBI_Mantralaya',30000),(1006,'SBI_parliamentstrt',45000),
(1007,'SBI_ResidencyRoad',12000);
INSERT INTO bank_customer VALUES
('Avinash','Bull_temple_rd','Bangalore'),('Dinesh','Bannerghata_rd','Bangalore'),
('Mohan','NR Square','Bangalore'),('Nikhil','Lajpat Nagar','Delhi'),
('Ravi','Prithviraj Road','Delhi');
INSERT INTO depositor VALUES
('Avinash',1001),('Avinash',1002),('Dinesh',1003),('Nikhil',1005),
('Ravi',1006),('Mohan',1004),('Dinesh',1007),('Mohan',1007);
INSERT INTO loan VALUES
(2001,'SBI_ResidencyRoad',1000000),(2002,'SBI_Jayanagar',2000000),
(2003,'SBI_Chamrajpet',500000),(2004,'SBI_Mantralaya',3000000),
(2005,'SBI_ResidencyRoad',1500000);

CREATE TABLE borrower (
  customer_name VARCHAR(100),
  loan_number INT,
  PRIMARY KEY (customer_name, loan_number),
  FOREIGN KEY (customer_name) REFERENCES bank_customer(customer_name),
  FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
);

INSERT INTO bank_customer VALUES ('Suresh','MG Road','Bangalore');
INSERT INTO depositor VALUES ('Nikhil',1006);
INSERT INTO borrower VALUES
('Avinash',2001),('Dinesh',2002),('Suresh',2003),('Nikhil',2004),('Mohan',2005);
INSERT INTO branch VALUES ('SBI_Colaba','Bombay',2000000),('SBI_Fort','Bombay',1500000);
INSERT INTO bank_account VALUES (1008,'SBI_Colaba',8000),(1009,'SBI_Fort',6000);
INSERT INTO depositor VALUES ('Ravi',1008),('Mohan',1009);

SELECT d.customer_name
FROM depositor d
JOIN bank_account a ON d.account_number = a.account_number
JOIN branch b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Delhi'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT b.branch_name) =
       (SELECT COUNT(*) FROM branch WHERE branch_city = 'Delhi');

SELECT DISTINCT customer_name FROM borrower
WHERE customer_name NOT IN (SELECT customer_name FROM depositor);

SELECT DISTINCT d.customer_name
FROM depositor d
JOIN bank_account a ON d.account_number = a.account_number
JOIN branch b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Bangalore'
  AND d.customer_name IN (
    SELECT br.customer_name
    FROM borrower br
    JOIN loan l ON br.loan_number = l.loan_number
    JOIN branch b2 ON l.branch_name = b2.branch_name
    WHERE b2.branch_city = 'Bangalore');

SELECT branch_name FROM branch
WHERE assets > ALL (SELECT assets FROM branch WHERE branch_city = 'Bangalore');

DELETE FROM depositor
WHERE account_number IN (SELECT account_number FROM bank_account
  WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city = 'Bombay'));
DELETE FROM bank_account
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city = 'Bombay');

SET SQL_SAFE_UPDATES = 0;
UPDATE bank_account SET balance = balance * 1.05;
SELECT * FROM bank_account;
