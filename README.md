📌 Database Security: DAC, RBAC & Inference Attack Prevention
--
A hands-on database security project implementing Discretionary Access Control (DAC), Role-Based Access Control (RBAC), and multiple inference control techniques to protect sensitive employee salary data.
The project simulates real-world access-control weaknesses, inference attacks, and applies effective countermeasures to secure relational database systems.

🧩 Project Overview
--

This project focuses on securing a database containing sensitive salary data through:

Implementation of DAC & RBAC models

Simulation of unauthorized access

Inference attack demonstrations

Countermeasures using randomization, access restrictions, and K-anonymity

Functional dependency inference analysis

Aggregate-based inference prevention

The dataset includes the following sensitive employee table:

EmpID	FullName	Salary
1	Ali	120000
2	Asser	110000
3	Mona	100000
4	Fatma	90000
5	Gehad	80000
6	Ahmed	70000

🛠 Technologies Used
--

SQL Server

T-SQL

Database Security Models (DAC, RBAC)

Views, Roles, Permissions

Inference Control Techniques

K-Anonymity Concepts

🔐 Part 1 — DAC (Discretionary Access Control) Implementation
--
✔ Steps Implemented:

Created SQL Server logins (user_public, user_admin)

Mapped logins to database users

Defined roles (public_role, admin_role)

Granted limited access to public users and full access to admin users

Tested query execution across both users

✔ DAC Vulnerability Demonstration

Simulated a scenario where a public user gains indirect access to restricted data through a view or inherited PUBLIC permission.

✔ Fix Applied

Removed implicit PUBLIC permissions

Restricted view access

Properly scoped privileges to roles

🧩 Part 2 — RBAC Implementation
--
✔ Implemented:

Created read_onlyX and insert_onlyX roles

Enforced permissions using GRANT and REVOKE

Verified least-privilege behavior

Created a hierarchical role (power_user) that inherits both read and insert permissions

✔ Behavior Testing

Users assigned to power_user gained combined privileges

After revoking a base role, the inherited permissions updated accordingly

🕵️ Part 3 — Inference Attack Simulation
--

Demonstrated how a malicious user can infer individual salaries by:

Aligning ordered results from vPublicNames and vPublicSalaries

Bypassing restricted access to the mapping table

Exploiting predictable ordering in public views

➡ Result: Salary inference succeeded despite no direct access.

🛡 Part 4 — Inference Control via Randomization
--

Applied protection mechanisms:

Regenerated Public IDs using NEWID()

Restricted access to AdminMap

Denied CREATE VIEW to public_role

Re-tested inference attempts → Attack blocked successfully

🧮 Part 5 — Functional Dependency Inference
--

Given FDs:

FD1: EmpID → Dept

FD2: Title → Grade

FD3: Dept, Grade → Bonus

Tasks Completed:

Computed closure Q⁺ of {Dept, Title}

Verified Bonus ∈ Q⁺

Determined whether the query should be rejected or transformed to prevent inference

📊 Part 6 — Inference via Aggregates
--

Simulated inference attacks using:

AVG views including a target user

AVG views excluding a target user

By comparing both averages, a malicious user could derive individual salaries.

✔ Fix Applied:

Implemented K-anonymity to ensure each aggregate group contains enough users

Verified that inference is no longer possible

Summary
--

This project demonstrates practical database security concepts including:

DAC & RBAC implementation

Exploiting and fixing access-control vulnerabilities

Simulating inference attacks

Applying randomization, K-anonymity, and role restrictions

Understanding how functional dependencies lead to inference leaks

Hardening database systems against data disclosure

📥 How to Run
--

Clone the repository

Set up SQL Server

Run the SQL scripts in order (DAC → RBAC → Inference → Fixes)

Test using user login simulation

⭐ If you found this project helpful, consider giving it a star!
