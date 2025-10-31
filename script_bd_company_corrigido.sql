-- ======================================================
-- SCHEMA / DATABASE
-- ======================================================
CREATE DATABASE IF NOT EXISTS azure_company
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE azure_company;

-- ======================================================
-- TABELA: EMPLOYEE
-- ======================================================
CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_employee PRIMARY KEY (Ssn),
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.00)
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

ALTER TABLE employee 
    ADD CONSTRAINT fk_employee_supervisor 
    FOREIGN KEY (Super_ssn) REFERENCES employee (Ssn)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- ======================================================
-- TABELA: DEPARTAMENT
-- ======================================================
CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CONSTRAINT pk_departament PRIMARY KEY (Dnumber),
    CONSTRAINT uq_departament_name UNIQUE (Dname),
    CONSTRAINT chk_departament_dates CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT fk_departament_manager FOREIGN KEY (Mgr_ssn) 
        REFERENCES employee (Ssn)
        ON UPDATE CASCADE
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- TABELA: DEPT_LOCATIONS
-- ======================================================
CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations_departament FOREIGN KEY (Dnumber)
        REFERENCES departament (Dnumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- TABELA: PROJECT
-- ======================================================
CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (Pnumber),
    CONSTRAINT uq_project_name UNIQUE (Pname),
    CONSTRAINT fk_project_departament FOREIGN KEY (Dnum)
        REFERENCES departament (Dnumber)
        ON UPDATE CASCADE
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- TABELA: WORKS_ON
-- ======================================================
CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_works_on_employee FOREIGN KEY (Essn)
        REFERENCES employee (Ssn)
        ON UPDATE CASCADE,
    CONSTRAINT fk_works_on_project FOREIGN KEY (Pno)
        REFERENCES project (Pnumber)
        ON UPDATE CASCADE
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- TABELA: DEPENDENT
-- ======================================================
CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent_employee FOREIGN KEY (Essn)
        REFERENCES employee (Ssn)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- VERIFICAÇÃO FINAL
-- ======================================================
SHOW TABLES;
