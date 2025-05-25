DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-52255_Add_fields_in_ColAgreementPartyAssets';
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

    execute immediate 'ALTER TABLE ColAgreementPartyAssets ADD prevInternalPolicyPermitsReuse NUMBER(1) default 0';
    execute immediate 'ALTER TABLE ColAgreementPartyAssets ADD forceChanged NUMBER(1) default 0';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
