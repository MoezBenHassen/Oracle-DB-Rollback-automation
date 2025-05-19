-- 🔁 Rollback of V15.14.0.0.0.10__COL-53061.sql
ALTER TABLE refdata DROP COLUMN substitutioncanceled;
ALTER TABLE colrefdata DROP COLUMN substitutioncanceled;
ALTER TABLE orgrefdata DROP COLUMN substitutioncanceled;
ALTER TABLE udfvaluesrefdata DROP COLUMN substitutioncanceled;
ALTER TABLE tradingrefdata DROP COLUMN substitutioncanceled;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-53061_cancellation_code' ;
