DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-60495_update_statement_archive';
BEGIN

SELECT count(1)
INTO results
FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
  THEN
    RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN vmLowerLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN imLowerLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN vmLowerLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN imLowerLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN vmUpperLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN imUpperLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN vmUpperLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement DROP COLUMN imUpperLimitCpty';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN vmLowerLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN imLowerLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN vmLowerLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN imLowerLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN vmUpperLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN imUpperLimitPrinc';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN vmUpperLimitCpty';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementHistory DROP COLUMN imUpperLimitCpty';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBufferHistory ADD vmBufferTypePrinc varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBufferHistory ADD vmBufferTypeCpty varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBufferHistory ADD imbufferTypePrinc varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBufferHistory ADD imbufferTypeCpty varchar(250)';

EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjVmMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjVmMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjIaMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjIaMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjVMNetED float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementHistory add adjIMNetED float(126) default 0';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;