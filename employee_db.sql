DROP DATABASE IF EXISTS Employee;
CREATE DATABASE Employee;
USE Employee;

CREATE TABLE dept (
  deptno INT PRIMARY KEY,
  dname  VARCHAR(30),
  dloc   VARCHAR(30)
);

CREATE TABLE employee (
  empno    INT PRIMARY KEY,
  ename    VARCHAR(30),
  mgr_no   INT,
  hiredate DATE,
  sal      DECIMAL(10,2),
  deptno   INT,
  FOREIGN KEY (mgr_no) REFERENCES employee(empno),
  FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

CREATE TABLE project (
  pno   INT PRIMARY KEY,
  ploc  VARCHAR(30),
  pname VARCHAR(30)
);

CREATE TABLE assigned_to (
  empno    INT,
  pno      INT,
  job_role VARCHAR(30),
  PRIMARY KEY (empno, pno),
  FOREIGN KEY (empno) REFERENCES employee(empno),
  FOREIGN KEY (pno)   REFERENCES project(pno)
);

CREATE TABLE incentives (
  empno            INT,
  incentive_date   DATE,
  incentive_amount DECIMAL(10,2),
  PRIMARY KEY (empno, incentive_date),
  FOREIGN KEY (empno) REFERENCES employee(empno)
);

INSERT INTO dept VALUES (10,'Sales','Bengaluru');
INSERT INTO dept VALUES (20,'Research','Hyderabad');
INSERT INTO dept VALUES (30,'HR','Mysuru');
INSERT INTO dept VALUES (40,'Finance','Chennai');
INSERT INTO dept VALUES (50,'IT','Bengaluru');
INSERT INTO dept VALUES (60,'Marketing','Mumbai');

INSERT INTO employee VALUES (101,'Kiran',  NULL,DATE '2010-01-15',120000,10);
INSERT INTO employee VALUES (102,'Asha',   101, DATE '2012-03-10', 90000,10);
INSERT INTO employee VALUES (103,'Ravi',   101, DATE '2013-06-20', 85000,20);
INSERT INTO employee VALUES (108,'Lakshmi',101, DATE '2014-11-11', 45000,40);
INSERT INTO employee VALUES (104,'Meena',  102, DATE '2015-07-01', 50000,10);
INSERT INTO employee VALUES (105,'Suresh', 102, DATE '2016-08-15', 55000,20);
INSERT INTO employee VALUES (111,'Pooja',  102, DATE '2018-04-23', 52000,10);
INSERT INTO employee VALUES (106,'Divya',  103, DATE '2017-09-12', 45000,30);
INSERT INTO employee VALUES (107,'Arjun',  103, DATE '2018-01-05', 48000,20);
INSERT INTO employee VALUES (109,'Rohit',  108, DATE '2019-02-02', 52000,40);
INSERT INTO employee VALUES (110,'Neha',   108, DATE '2019-05-19', 54000,50);

INSERT INTO project VALUES (201,'Bengaluru','Payroll System');
INSERT INTO project VALUES (202,'Hyderabad','Inventory Tracker');
INSERT INTO project VALUES (203,'Mysuru',   'Student Portal');
INSERT INTO project VALUES (204,'Chennai',  'Billing Engine');
INSERT INTO project VALUES (205,'Mumbai',   'Ad Analytics');
INSERT INTO project VALUES (206,'Bengaluru','Cloud Migration');

INSERT INTO assigned_to VALUES (101,206,'Sponsor');
INSERT INTO assigned_to VALUES (102,201,'Team Lead');
INSERT INTO assigned_to VALUES (103,202,'Manager');
INSERT INTO assigned_to VALUES (104,201,'Developer');
INSERT INTO assigned_to VALUES (105,202,'Tester');
INSERT INTO assigned_to VALUES (106,203,'Analyst');
INSERT INTO assigned_to VALUES (107,204,'Developer');
INSERT INTO assigned_to VALUES (108,204,'Manager');
INSERT INTO assigned_to VALUES (109,205,'Designer');
INSERT INTO assigned_to VALUES (110,206,'Developer');
INSERT INTO assigned_to VALUES (111,201,'Tester');

INSERT INTO incentives VALUES (102,DATE '2019-01-10',5000);
INSERT INTO incentives VALUES (103,DATE '2019-01-15',8000);
INSERT INTO incentives VALUES (104,DATE '2019-01-20',3000);
INSERT INTO incentives VALUES (106,DATE '2019-01-25',6000);
INSERT INTO incentives VALUES (105,DATE '2019-02-05',7000);
INSERT INTO incentives VALUES (108,DATE '2019-03-01',4000);
INSERT INTO incentives VALUES (109,DATE '2018-12-20',9000);

SELECT DISTINCT a.empno
FROM assigned_to a
JOIN project p ON a.pno = p.pno
WHERE p.ploc IN ('Bengaluru','Hyderabad','Mysuru');

SELECT empno
FROM employee
WHERE empno NOT IN (SELECT empno FROM incentives);

SELECT e.ename, e.empno, d.dname, a.job_role,
       d.dloc AS dept_location, p.ploc AS project_location
FROM employee e
JOIN dept d        ON e.deptno = d.deptno
JOIN assigned_to a ON e.empno  = a.empno
JOIN project p     ON a.pno    = p.pno
WHERE d.dloc = p.ploc;

SELECT m.ename
FROM employee m
WHERE m.empno IN (
  SELECT mgr_no
  FROM employee
  WHERE mgr_no IS NOT NULL
  GROUP BY mgr_no
  HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt
          FROM employee
          WHERE mgr_no IS NOT NULL
          GROUP BY mgr_no) t
  )
);

SELECT m.empno, m.ename, m.sal, AVG(e.sal) AS avg_emp_sal
FROM employee e
JOIN employee m ON e.mgr_no = m.empno
GROUP BY m.empno, m.ename, m.sal
HAVING m.sal > AVG(e.sal);

SELECT DISTINCT e.ename, d.dname
FROM employee e
JOIN dept d ON e.deptno = d.deptno
WHERE e.mgr_no IN (SELECT empno FROM employee WHERE mgr_no IS NULL)
  AND e.empno  IN (SELECT mgr_no FROM employee WHERE mgr_no IS NOT NULL)
ORDER BY d.dname;

SELECT e.*
FROM employee e
JOIN incentives i ON e.empno = i.empno
WHERE i.incentive_date BETWEEN DATE '2019-01-01' AND DATE '2019-01-31'
  AND i.incentive_amount = (
    SELECT MAX(incentive_amount)
    FROM incentives
    WHERE incentive_date BETWEEN DATE '2019-01-01' AND DATE '2019-01-31'
      AND incentive_amount < (
        SELECT MAX(incentive_amount)
        FROM incentives
        WHERE incentive_date BETWEEN DATE '2019-01-01' AND DATE '2019-01-31'
      )
  );

SELECT e.empno, e.ename, e.deptno
FROM employee e
JOIN employee m ON e.mgr_no = m.empno
WHERE e.deptno = m.deptno;
