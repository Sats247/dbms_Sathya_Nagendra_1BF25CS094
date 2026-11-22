CREATE DATABASE bank_enterprise_1BF25CS094
USE bank_enterprise_1BF25CS094;

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

SELECT * FROM branch;
SELECT * FROM bank_account;
SELECT * FROM bank_customer;
SELECT * FROM depositor;
SELECT * FROM loan;
SELECT branch_name, assets / 100000 AS 'assets in lakhs' FROM branch;
SELECT d.customer_name
FROM depositor d
JOIN bank_account a ON d.account_number = a.account_number
WHERE a.branch_name = 'SBI_ResidencyRoad'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT d.account_number) >= 2;
SELECT d.customer_name, a.branch_name, COUNT(*) AS no_of_accounts
FROM depositor d
JOIN bank_account a ON d.account_number = a.account_number
GROUP BY d.customer_name, a.branch_name
HAVING COUNT(*) >= 2;
CREATE VIEW branch_total_loan (branch_name, total_loan_amount) AS
SELECT branch_name, SUM(amount) FROM loan GROUP BY branch_name;
SELECT * FROM branch_total_loan;
