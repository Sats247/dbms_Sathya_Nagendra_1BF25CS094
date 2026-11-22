CREATE DATABASE supplier_db_1BF25CS094;
USE supplier_db;

CREATE TABLE suppliers (
  sid INT PRIMARY KEY,
  sname VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL
);

CREATE TABLE parts (
  pid INT PRIMARY KEY,
  pname VARCHAR(50) NOT NULL,
  color VARCHAR(20) NOT NULL
);

CREATE TABLE catalog (
  sid INT,
  pid INT,
  cost DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
  PRIMARY KEY (sid, pid),
  FOREIGN KEY (sid) REFERENCES suppliers(sid) ON DELETE RESTRICT,
  FOREIGN KEY (pid) REFERENCES parts(pid) ON DELETE RESTRICT
);

INSERT INTO suppliers VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

SELECT DISTINCT p.pname
FROM parts p
JOIN catalog c ON p.pid = c.pid
ORDER BY p.pname;

SELECT s.sname
FROM suppliers s
JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM parts)
ORDER BY s.sname;

SELECT s.sname
FROM suppliers s
JOIN catalog c ON s.sid = c.sid
JOIN parts p ON c.pid = p.pid
WHERE p.color = 'Red'
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT p.pid) = (SELECT COUNT(*) FROM parts WHERE color = 'Red')
ORDER BY s.sname;

SELECT p.pname
FROM parts p
JOIN catalog c ON p.pid = c.pid
JOIN suppliers s ON c.sid = s.sid
WHERE s.sname = 'Acme Widget'
  AND NOT EXISTS (SELECT 1 FROM catalog c2
                  WHERE c2.pid = p.pid AND c2.sid <> s.sid)
ORDER BY p.pid;

SELECT DISTINCT c.sid
FROM catalog c
WHERE c.cost > (SELECT AVG(c2.cost) FROM catalog c2 WHERE c2.pid = c.pid)
ORDER BY c.sid;

SELECT c.pid, s.sname
FROM catalog c
JOIN suppliers s ON c.sid = s.sid
WHERE c.cost = (SELECT MAX(c2.cost) FROM catalog c2 WHERE c2.pid = c.pid)
ORDER BY s.sname, c.pid;
