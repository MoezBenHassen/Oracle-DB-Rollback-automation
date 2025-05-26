-- 🔁 Rollback for PL/SQL V15.17.1.0.0.0__COL-64218.sql
-- ⚠️ MANUAL CHECK REQUIRED: previously dropped column maxReuseAvailable from ColAgreementInstrument
-- ⚠️ MANUAL CHECK REQUIRED: previously dropped column maxReuseHolding from ColAgreementInstrument
DELETE FROM lrsschemaproperties
WHERE modulename = 'COLLATERAL'
  AND propertyname = 'COL-64218_Delete_MaxReuse_Available_Holding';

-- 🔁 Rollback for PL/SQL V15.17.1.0.0.1__COL-64639.sql
ALTER TABLE COLINVENTORYMANAGERRESET DROP COLUMN isDeltaFeed;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-64639_UPDATE_INVENTORY_MANAGER_RESET_WITH_IS_DELTA_FEED';

  -- 🔁 Rollback for PL/SQL V15.17.1.0.0.2__COL-64645.sql
  DROP TABLE ORGHEADERDEL;
DROP TABLE marketdataheaderhistorydel;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-64645_OSA_Delta_refresh_org_fxrates';

  -- 🔁 Rollback for PL/SQL V15.17.1.0.0.3__COL-63186.sql
  DROP TABLE colagreementinstrumentscalcDel;
DROP TABLE colstatementcategorydel;
DROP TABLE colworkflowdel;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-64645_OSA_Delta_refresh_event';


  -- 🔁 Rollback for PL/SQL V15.17.1.0.0.4__COL-63186.sql
  DROP TABLE colconclimitclassruleDel;
DROP TABLE colconclimitruleDel;
DROP TABLE coleligrulesdetailsDel;
DROP TABLE coleligrulesassetsDel;
DROP TABLE coleligconclimitclassruleDel;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-64645_OSA_Delta_refresh_conclimitrule';


  -- 🔁 Rollback for PL/SQL V15.17.1.0.0.5__COL-60283.sql
  ALTER TABLE OPTBOOKING DROP COLUMN SOURCEID;
  ALTER TABLE OPTBOOKING DROP COLUMN INVENTORYDELIVERYGROUP;

  DELETE FROM lrsschemaproperties
  WHERE modulename = 'collateral'
    AND propertyname = 'COL-60283_Add_imSource_To_bookings';

-- 🔁 Rollback for PL/SQL V15.17.1.0.0.6__COL-65208.sql
-- Re-insert manually deleted data (manual check required to ensure id/roles consistency)
-- ⚠️ MANUAL CHECK REQUIRED: Cannot determine original roleprivileges.id or related role mapping
DELETE FROM lrsschemaproperties
WHERE modulename = 'Collateral'
  AND propertyname = 'COL-65208_Duplicated_Privilege';


-- 🔁 Rollback for PL/SQL V15.17.1.0.0.7__COL-64772.sql 
DROP INDEX idx_col_securityparamount_delivery;
DROP INDEX idx_col_securityparamount_call;
DROP TABLE colSecurityParamountRehypothecated;
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-64772_All_the_bookings_on_the_rehypo_agreement_are_tagged_as_rehypothecated';




