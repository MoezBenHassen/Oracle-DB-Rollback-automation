DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64645_OSA_Delta_refresh_conclimitrule';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;


EXECUTE IMMEDIATE 'CREATE TABLE colconclimitclassruleDel (AGREEMENTID NUMBER(19,0) NOT NULL,
                    ruleid NUMBER(19,0) NOT NULL,
                   	assetclassid NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (AGREEMENTID, ruleid, assetclassid))';

EXECUTE IMMEDIATE 'CREATE TABLE colconclimitruleDel (ruleid NUMBER(19,0) NOT NULL,
                   	agreementpartyassetid NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (ruleid, agreementpartyassetid))';

EXECUTE IMMEDIATE 'CREATE TABLE coleligrulesdetailsDel (id NUMBER(19,0) NOT NULL,
                   	ELIGIBILITYASSETID NUMBER(19,0),
                   	DELETEDDATE DATE,
                   	PRIMARY KEY (id))';


EXECUTE IMMEDIATE 'CREATE TABLE coleligrulesassetsDel (id NUMBER(19,0) NOT NULL,
                    ELIGIBILITYRULEID NUMBER(19,0),
                    ASSETID NUMBER(19,0),
                    DELETEDDATE DATE,
                    PRIMARY KEY (id))';

EXECUTE IMMEDIATE 'CREATE TABLE coleligconclimitclassruleDel (id NUMBER(19,0) NOT NULL,
                    ELIGIBILITYRULEID NUMBER(19,0),
                    ASSETCLASSID NUMBER(19,0),
                    DELETEDDATE DATE,
                    PRIMARY KEY (id))';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;