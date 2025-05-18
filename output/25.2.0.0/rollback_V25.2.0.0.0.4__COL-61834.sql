-- 🔁 Rollback of V25.2.0.0.0.4__COL-61834.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN agreementia;
ALTER TABLE feed_staging_good_agreement DROP COLUMN independentamount;
ALTER TABLE feed_staging_good_agreement DROP COLUMN upfrontcalculmethodology;
ALTER TABLE feed_staging_good_agreement DROP COLUMN principleupfronts;
ALTER TABLE feed_staging_good_agreement DROP COLUMN fixedvalue;
ALTER TABLE feed_staging_good_agreement DROP COLUMN fixedperc;
