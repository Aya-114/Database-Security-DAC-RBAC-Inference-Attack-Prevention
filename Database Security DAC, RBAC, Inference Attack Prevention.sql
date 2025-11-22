create database GIVE_US_BONUS;

DROP USER IF EXISTS admin11;
GO

CREATE TABLE dbo.Employees_2 (
    EmpID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Salary INT
);

INSERT INTO dbo.Employees_2 (EmpID, FullName, Salary) VALUES
(1,'Ali',120000),
(2,'Asser',110000),
(3,'Mona',100000),
(4,'Fatma',90000),
(5,'Gehad',80000),
(6,'Ahmed',70000);

USE master;
CREATE LOGIN user_public11 WITH PASSWORD = '1111';
CREATE LOGIN user_admin11 WITH PASSWORD = '2222';
CREATE LOGIN FD_general WITH PASSWORD = '1111'
USE GIVE_US_BONUS;
CREATE USER general11 FOR LOGIN user_public11;
CREATE USER generalkk FOR LOGIN FD_general;
CREATE USER admin11 FOR LOGIN user_admin11;
revert;

use GIVE_US_BONUS;
CREATE ROLE admin_role;
CREATE ROLE public_role;

ALTER ROLE public_role ADD MEMBER general11;
ALTER ROLE admin_role  ADD MEMBER admin11;

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Employees_2 TO admin_role;

CREATE VIEW vPublicEmployeeeeees AS
SELECT EmpID, FullName
FROM Employees_2;

GRANT SELECT ON vPublicEmployeeeeees TO public_role;

EXECUTE AS USER = 'admin11';
SELECT * FROM dbo.Employees_2;
REVERT;
EXECUTE AS USER = 'general11';
SELECT * FROM dbo.vPublicEmployeeeeees;

CREATE SCHEMA general11 AUTHORIZATION general11;
GO
ALTER USER general11 WITH DEFAULT_SCHEMA = general11;
GO

CREATE TABLE dbo.PublicID2ND (
    EmpID INT PRIMARY KEY,
);

INSERT INTO dbo.PublicID2ND  (EmpID)
VALUES (1),(2),(3),
       (4),(5),(6);

CREATE VIEW dbo.HACK1 AS
SELECT p.EmpID, e.Salary
FROM dbo.PublicID2ND p
JOIN dbo.Employees e ON p.EmpID = e.EmpID;

GRANT SELECT ON dbo.HACK1 TO public_role;
SELECT * FROM dbo.HACK1;

REVOKE SELECT ON dbo.HACK1 FROM public_role;
 
----------------------------------------------------------------------
CREATE ROLE read_onlyXX;
CREATE ROLE insert_onlyXX;
CREATE LOGIN user_readerX WITH PASSWORD = '1111';
CREATE LOGIN user_inserterX WITH PASSWORD = '1111';

CREATE USER readerX FOR LOGIN user_readerX;
CREATE USER inserterX FOR LOGIN user_inserterX;

ALTER ROLE read_onlyXX ADD MEMBER readerX;
ALTER ROLE insert_onlyXX ADD MEMBER inserterX;

GRANT SELECT ON dbo.Employees_2 TO read_onlyXX;
GRANT INSERT ON dbo.Employees_2 TO insert_onlyXX;

REVOKE UPDATE, DELETE, ALTER ON dbo.Employees_2 FROM read_onlyXX;
REVOKE UPDATE, DELETE, ALTER ON dbo.Employees_2 FROM insert_onlyXX;
--TEST READERX
EXECUTE AS USER = 'readerX';

SELECT TOP(10) * FROM dbo.Employees_2;
INSERT INTO dbo.Employees_2 (EmpID,FullName,Salary) VALUES (99,'LOLO',1);
UPDATE dbo.Employees_2 SET FullName = 'X' WHERE EmpID = 1;
DELETE FROM dbo.Employees_2 WHERE EmpID = 99;

--TEAST INSERTERX
EXECUTE AS USER = 'inserterX';
SELECT TOP(5) * FROM dbo.Employees_2;
INSERT INTO dbo.Employees_2 (EmpID,FullName,Salary) VALUES (98,'KOKO',2222);
UPDATE dbo.Employees_2 SET FullName = 'X2' WHERE EmpID = 98;
REVERT;

CREATE ROLE Batman_user;

ALTER ROLE read_onlyXX ADD MEMBER Batman_user;
ALTER ROLE insert_onlyXX ADD MEMBER Batman_user;
use master;
use GIVE_US_BONUS;
CREATE LOGIN Batman_user WITH PASSWORD = '1111';
CREATE USER BigBatman FOR LOGIN Batman_user;
ALTER ROLE Batman_user ADD MEMBER BigBatman;

EXECUTE AS USER = 'BigBatman';
SELECT TOP(3) * FROM dbo.Employees_2;
INSERT INTO dbo.Employees_2 (EmpID, FullName, Salary)VALUES (400, 'TestUser', 50000);
UPDATE dbo.Employees_2 SET FullName='Bruce Wayne' WHERE EmpID=2;
DELETE FROM dbo.Employees_2 WHERE EmpID=300;

REVOKE SELECT ON OBJECT::dbo.Employees FROM read_onlyXX;
SELECT TOP(3) * FROM dbo.Employees_2;
----------------------------------------------------------------------
USE GIVE_US_BONUS;
GO

DROP VIEW IF EXISTS dbo.vPublicNames;
DROP VIEW IF EXISTS dbo.vPublicSalaries;
DROP TABLE IF EXISTS dbo.AdminMaPP;

------------------------------------------------------------------
CREATE VIEW dbo.vPublicNames AS
SELECT ROW_NUMBER() OVER (ORDER BY FullName) AS rn, FullName
FROM dbo.Employees_2;
revert;

CREATE VIEW dbo.vPublicSalaries AS
SELECT ROW_NUMBER() OVER (ORDER BY FullName) AS rn, Salary
FROM dbo.Employees_2;
GRANT SELECT ON dbo.vPublicNames TO public_role;
GRANT SELECT ON dbo.vPublicSalaries TO public_role;
GO
-----------------------------------------------------------------
EXECUTE AS USER = 'general11';
SELECT * FROM dbo.vPublicNames ORDER BY rn;
SELECT * FROM dbo.vPublicSalaries ORDER BY rn;

SELECT n.rn, n.FullName, s.Salary
FROM dbo.vPublicNames AS n
JOIN dbo.vPublicSalaries AS s
  ON n.rn = s.rn
ORDER BY n.rn;
REVERT;
GO
----------------------------------------------------------------

CREATE TABLE dbo.AdminMaPP (
    RealEmpID INT PRIMARY KEY,
    PublicEmpID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID()
);
GO

INSERT INTO dbo.AdminMaPP (RealEmpID)
SELECT EmpID FROM dbo.Employees_2;
GO

SELECT * FROM dbo.AdminMaPP;
GO
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.AdminMaPP FROM PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.AdminMaPP TO admin_role;
DENY SELECT ON dbo.AdminMaPP TO public_role;
GO

EXECUTE AS USER = 'general11';
SELECT * FROM dbo.AdminMaPP; 
REVERT;
GO

DENY CREATE VIEW TO public_role;
GO
DENY SELECT ON dbo.AdminMaPP TO public_role;

DENY SELECT ON OBJECT::dbo.vPublicNames TO public_role;
DENY SELECT ON OBJECT::dbo.vPublicSalaries TO public_role;

------------------------------
CREATE TABLE dbo.Employees_Dept (
    EmpID INT PRIMARY KEY,
    Dept NVARCHAR(50)
);
GO

INSERT INTO dbo.Employees_Dept (EmpID, Dept) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'IT'),
(5, 'Finance');
GO

CREATE TABLE dbo.Employees_GradeTitle (
    Title NVARCHAR(50) PRIMARY KEY,
    Grade NVARCHAR(10)
);


INSERT INTO dbo.Employees_GradeTitle (Title, Grade) VALUES
('Engineer', 'B1'),
('Manager', 'A1'),
('Officer', 'B2'),
('Accountant', 'B1'),
('Analyst', 'B2');

CREATE TABLE dbo.Employees_Bonus (
    Grade NVARCHAR(10),
    Dept NVARCHAR(50),
    Bonus INT,
    EmpID INT
);


INSERT INTO dbo.Employees_Bonus (Grade, Dept, Bonus, EmpID) VALUES
('B1', 'IT', 5000, 1),
('A1', 'HR', 9000, 2),
('B2', 'Finance', 4500, 3),
('B1', 'IT', 5200, 4),
('A1', 'Finance', 9500, 5);

CREATE ROLE  FD_general_role;
EXEC sp_addrolemember 'FD_general_role','generalkk';

ALTER ROLE FD_general_role ADD MEMBER generalkk;



GRANT SELECT ON OBJECT::dbo.Employees_Dept TO FD_general_role;
DENY  SELECT ON OBJECT::dbo.Employees_GradeTitle  TO FD_general_role;        -- <— block FD lookup
GRANT SELECT ON OBJECT::dbo.Employees_Bonus TO FD_general_role;     -- <— block FD lookup
DENY  SELECT ON OBJECT::dbo.Employees_Bonus (bonus) TO FD_general_role;  -- <- sensitive values

CREATE VIEW dbo.v_safe_2 AS
SELECT Dept, COUNT(*) AS n
FROM dbo.Employees_Dept
GROUP BY Dept;
GRANT SELECT ON dbo.v_safe_2 TO FD_general_role;



GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Employees_Dept TO admin_role;      -- <— block FD lookup
GRANT SELECT ON OBJECT::dbo.Employees_Bonus TO admin_role;     -- <— block FD lookup

EXECUTE AS USER='general11';
EXECUTE AS USER='admin1';

REVERT;
use GIVE_US_BONUS;
SELECT * FROM dbo.v_safe_2;         --accept


use GIVE_US_BONUS;
-- AS student: Direct Bonus access is BLOCKED 

  SELECT Bonus FROM dbo.Employees_Bonus; -- deny

-- Part 6: K-Anonymity Implementation (Using EmpDetails)
USE Week4DB;
GO

-- Create a view to calculate average Bonus per Department from EmpDetails
IF OBJECT_ID('dbo.vAvgSalary', 'V') IS NOT NULL DROP VIEW dbo.vAvgSalary;
GO
CREATE VIEW dbo.vAvgSalary AS
SELECT Dept, AVG(Bonus) AS AvgBonus
FROM dbo.EmpDetails
GROUP BY Dept;
GO

PRINT '--- Inference attempt (before K-anonymity) ---';
SELECT * FROM dbo.vAvgSalary;
GO

-- Apply K-anonymity (K=3): exclude departments with fewer than 3 employees
IF OBJECT_ID('dbo.vKAnonSalary', 'V') IS NOT NULL DROP VIEW dbo.vKAnonSalary;
GO
CREATE VIEW dbo.vKAnonSalary AS
SELECT Dept, AVG(Bonus) AS AvgBonus, COUNT(*) AS EmployeeCount
FROM dbo.EmpDetails
GROUP BY Dept
HAVING COUNT(*) >= 3;
GO

PRINT '--- After applying K-anonymity: inference blocked ---';
SELECT * FROM dbo.vKAnonSalary;
GO

-------------------------------------


-- Final test of all security measures
PRINT '=== FINAL SECURITY VALIDATION ===';

PRINT '1. Public user access test:';
EXECUTE AS USER = 'general';
BEGIN TRY
    SELECT 'Access to vPublicNames:' AS Test, COUNT(*) AS Count FROM dbo.vPublicNames;
END TRY BEGIN CATCH SELECT 'vPublicNames access failed' AS Test, ERROR_MESSAGE() AS Error; END CATCH

BEGIN TRY
    SELECT 'Access to vPublicSalaries:' AS Test, COUNT(*) AS Count FROM dbo.vPublicSalaries;
END TRY BEGIN CATCH SELECT 'vPublicSalaries access failed' AS Test, ERROR_MESSAGE() AS Error; END CATCH

BEGIN TRY
    SELECT 'Attempt to access AdminMap:' AS Test, COUNT(*) AS Count FROM dbo.AdminMap;
END TRY BEGIN CATCH SELECT 'AdminMap access correctly blocked' AS Test, ERROR_MESSAGE() AS Error; END CATCH

BEGIN TRY
    SELECT 'Attempt to create view:' AS Test;
    EXEC('CREATE VIEW dbo.HackView AS SELECT 1 AS Data');
END TRY BEGIN CATCH SELECT 'View creation correctly blocked' AS Test, ERROR_MESSAGE() AS Error; END CATCH

REVERT;
GO

PRINT '2. Admin user access test:';
EXECUTE AS USER = 'admin1';
BEGIN TRY
    SELECT 'Admin access to Employees:' AS Test, COUNT(*) AS Count FROM dbo.Employees;
    SELECT 'Admin access to AdminMap:' AS Test, COUNT(*) AS Count FROM dbo.AdminMap;
    SELECT 'Admin access to vAdminMapping:' AS Test, COUNT(*) AS Count FROM dbo.vAdminMapping;
END TRY BEGIN CATCH SELECT 'Admin access failed' AS Test, ERROR_MESSAGE() AS Error; END CATCH
REVERT;
GO





