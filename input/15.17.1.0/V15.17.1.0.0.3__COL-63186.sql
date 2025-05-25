DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64645_OSA_Delta_refresh_event';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE colagreementinstrumentscalcDel (AGREEMENTID NUMBER(19,0) NOT NULL,
                   	SECURITYID NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (AGREEMENTID, SECURITYID))';

EXECUTE IMMEDIATE 'CREATE TABLE colstatementcategorydel (AGREEMENTID NUMBER(19,0) NOT NULL,
                   	eventid NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (AGREEMENTID, eventid))';

EXECUTE IMMEDIATE 'CREATE TABLE colworkflowdel (AGREEMENTID NUMBER(19,0) NOT NULL,
                   	eventid NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (AGREEMENTID, eventid))';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;