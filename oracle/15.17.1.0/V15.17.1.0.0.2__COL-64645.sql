DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64645_OSA_Delta_refresh_org_fxrates';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE ORGHEADERDEL (ID NUMBER(19,0) NOT NULL ENABLE,
                   	LONGNAME VARCHAR2(255 BYTE),
                   	SHORTNAME VARCHAR2(250 BYTE),
                   	ORGCODE VARCHAR2(250 BYTE),
                   	ORGSTATUSID NUMBER(19,0),
                   	STATUS NUMBER(19,0),
                   	LASTUPDATEBY VARCHAR2(50 BYTE),
                   	LASTUPDATETIME DATE,
                   	LEI VARCHAR2(250 BYTE),
                   	DELETEDDATE DATE,
                   	 PRIMARY KEY (ID))';

EXECUTE IMMEDIATE 'CREATE TABLE marketdataheaderhistorydel (
    historyid       NUMBER(19, 0) NOT NULL ENABLE,
    marketdataid    NUMBER(19, 0),
    name            VARCHAR2(250 BYTE),
    marketdatatype  VARCHAR2(50 BYTE),
    loaderclass     VARCHAR2(128 BYTE),
    iseod           NUMBER(1, 0) DEFAULT 0 NOT NULL ENABLE,
    ts              NUMBER(19, 0),
    entereddatetime NUMBER(19, 0),
    deleteddate     DATE,
    PRIMARY KEY ( historyid )
)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
