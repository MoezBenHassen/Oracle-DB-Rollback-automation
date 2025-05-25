-- 🔁 Rollback for PL/SQL  V15.16.0.0.0.0__COL51522.sql
DELETE FROM preferences WHERE PARENT = 7 AND PREFTYPE = '(global)' AND NAME = 'REPO OR TBA CONFIG' AND PREFVALUE IS NULL AND PREFCLASS IS NULL;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-51522_Adding_repo_or_tba_field_on_Configuration>Preferences';


-- 🔁 Rollback for PL/SQL V15.16.0.0.0.1__COL-56214.sql 
DELETE FROM preferences WHERE PARENT = 7 AND PREFTYPE = '(global)' AND NAME = 'Enable_Booking_At_Parent_Level' AND PREFVALUE = 'false' AND PREFCLASS IS NULL;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-56214_Add_Enable_Booking_At_Parent_Level';

-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 
-- 🔁 Rollback for PL/SQL 

