--START
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-52014_AddApprovalStatusColumn_To_RunResult';
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


EXECUTE IMMEDIATE 'alter table OPT_RUNRESULT add bookingApprovalStatus number(1) default 0 ';

EXECUTE IMMEDIATE 'alter table OPT_RUNRESULT add latestrun number(1) default 0 ';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
--END