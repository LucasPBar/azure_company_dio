USE azure_company;

-- -----------------------------------------------------
-- INSERÇÕES EM employee (ordem respeita foreign keys)
-- Inserimos primeiro gestores sem supervisor (NULL), depois quem referencia esses gestores.
-- -----------------------------------------------------

-- 1) Inserir o top-level manager (James Borg) que tem Super_ssn = NULL
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES
('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000.00, NULL, 1);

-- 2) Inserir gestores que referenciam o top manager
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000.00, '888665555', 5),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000.00, '888665555', 4);

-- 3) Inserir demais empregados que referenciam os gestores já existentes
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000.00, '333445555', 5),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000.00, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000.00, '333445555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000.00, '987654321', 4),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000.00, '987654321', 4);

-- -----------------------------------------------------
-- Inserir dependents (referenciam employee.Ssn) - todos os employees já existem
-- -----------------------------------------------------
INSERT INTO dependent (Essn, Dependent_name, Sex, Bdate, Relationship)
VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- -----------------------------------------------------
-- Inserir departament (managers já existem)
-- -----------------------------------------------------
INSERT INTO departament (Dname, Dnumber, Mgr_ssn, Mgr_start_date, Dept_create_date)
VALUES
('Research', 5, '333445555', '1988-05-22', '1986-05-22'),
('Administration', 4, '987654321', '1995-01-01', '1994-01-01'),
('Headquarters', 1, '888665555', '1981-06-19', '1980-06-19');

-- -----------------------------------------------------
-- Inserir dept_locations (departament já existe)
-- -----------------------------------------------------
INSERT INTO dept_locations (Dnumber, Dlocation)
VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- -----------------------------------------------------
-- Inserir project (departament já existe)
-- -----------------------------------------------------
INSERT INTO project (Pname, Pnumber, Plocation, Dnum)
VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

-- -----------------------------------------------------
-- Inserir works_on (employees e projects já existem)
-- -----------------------------------------------------
INSERT INTO works_on (Essn, Pno, Hours)
VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 0.0);

-- -----------------------------------------------------
-- CONSULTAS (corrigidas)
-- -----------------------------------------------------

-- 1) listar todos os employees
SELECT * FROM employee;

-- 2) contar dependentes por empregado (corrigida e com alias)
SELECT e.Ssn, COUNT(d.Essn) AS num_dependents
FROM employee e
JOIN dependent d ON e.Ssn = d.Essn
GROUP BY e.Ssn;

-- 3) listar dependents
SELECT * FROM dependent;

-- 4) buscar John B Smith
SELECT Bdate, Address
FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

-- 5) buscar departamento Research
SELECT * FROM departament WHERE Dname = 'Research';

-- 6) nomes e endereços dos empregados do departamento Research
SELECT e.Fname, e.Lname, e.Address
FROM employee e
JOIN departament d ON e.Dno = d.Dnumber
WHERE d.Dname = 'Research';

-- 7) listar projects
SELECT * FROM project;

-- 8) departamentos presentes em Stafford (usando JOIN explicito)
SELECT d.Dname AS Department, d.Mgr_ssn AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
WHERE l.Dlocation = 'Stafford';

-- 9) departamento + nome do manager (concat)
SELECT d.Dname AS Department, CONCAT(e.Fname, ' ', e.Lname) AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- 10) projects em Stafford
SELECT p.*
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
WHERE p.Plocation = 'Stafford';

-- 11) info departamentos e projetos em Stafford (join explícito)
SELECT p.Pnumber, p.Dnum, e.Lname, e.Address, e.Bdate
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn
WHERE p.Plocation = 'Stafford';

-- 12) exemplo IN (mantido)
SELECT * FROM employee WHERE Dno IN (3,6,9);

-- 13) removidas queries com aspas tipográficas (corrigidas acima)

-- 14) expressões e alias (INSS)
SELECT Fname, Lname, Salary, ROUND(Salary * 0.011, 2) AS INSS FROM employee;

-- 15) aumento hipotético para empregados que trabalham no projeto 'ProductX'
SELECT e.Fname, e.Lname, 1.1 * e.Salary AS increased_sal
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'ProductX';

-- 16) recuperar empregados do departamento Research (duas versões)
SELECT Fname, Lname, Address
FROM employee e
JOIN departament d ON e.Dno = d.Dnumber
WHERE d.Dname = 'Research';

-- fim do script
