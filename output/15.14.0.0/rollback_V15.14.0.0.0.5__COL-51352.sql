-- 🔁 Rollback of V15.14.0.0.0.5__COL-51352.sql
ALTER TABLE colstatement DROP COLUMN futuresettlementdebit;
ALTER TABLE colstatement DROP COLUMN futuresettlementcredit;
ALTER TABLE colstatement DROP COLUMN bookingsettlementtoday;
ALTER TABLE colstatement DROP COLUMN bookingsettlementtodaycash;
ALTER TABLE colstatement DROP COLUMN bookingsettlementtodaynocash;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52623_Add3_fields_to_Family_statement' ;
