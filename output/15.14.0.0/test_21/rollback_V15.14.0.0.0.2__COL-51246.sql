-- 🔁 Rollback of V15.14.0.0.0.2__COL-51246.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN callreturn;
ALTER TABLE feed_staging_good_agreement DROP COLUMN deliveryrecall;
ALTER TABLE feed_staging_good_agreement DROP COLUMN interestpay;
ALTER TABLE feed_staging_good_agreement DROP COLUMN interestreceive;
ALTER TABLE feed_staging_good_agreement DROP COLUMN imcallreturn;
ALTER TABLE feed_staging_good_agreement DROP COLUMN imdeliveryrecall;
ALTER TABLE feed_staging_good_agreement DROP COLUMN iminterestpay;
ALTER TABLE feed_staging_good_agreement DROP COLUMN iminterestreceive;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
