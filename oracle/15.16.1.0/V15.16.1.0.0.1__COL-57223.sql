DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'f3';
  v_property VARCHAR2(100) := 'COL-57223_thirdPartyApproval_S2_User_Profile';
BEGIN

SELECT count(1) INTO results
    FROM lrsschemaproperties l WHERE l.modulename = v_module AND l.propertyname = v_property;

IF results > 0
  THEN
    RETURN;
END IF;

EXECUTE IMMEDIATE 'Alter table F3UserProfile add thirdPartyApproval number(1,0) default 0 not null';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
