DECLARE
results    NUMBER;
v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-58220_BUFFER_S1';
maxBufferid NUMBER;
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

EXECUTE IMMEDIATE 'CREATE TABLE ColBufferItem ('
    || 'id NUMBER(19, 0) NOT NULL PRIMARY KEY,'
    || 'bffrType NUMBER(19) default 0 not null,'
    || 'bffrLowerLimit float(126),'
    || 'bffrUpperLimit float(126),'
    || 'bffrCurrency NUMBER(19),'
    || 'targetBffr float(126),'
    || 'ColRatingContingentParametersId NUMBER(19),'
    || 'FOREIGN KEY (ColRatingContingentParametersId) REFERENCES ColRatingContingentParameters(Id))';

EXECUTE IMMEDIATE 'CREATE SEQUENCE COLBUFFERITEM_SEQ START WITH 1 INCREMENT BY 1';

EXECUTE IMMEDIATE 'INSERT INTO ColBufferItem (id, bffrType, bffrLowerLimit, bffrUpperLimit, bffrCurrency,ColRatingContingentParametersId)'
    || 'SELECT COLBUFFERITEM_SEQ.NEXTVAL, bffrType, bffrLowerLimit, bffrUpperLimit, bffrCurrency,id FROM ColRatingContingentParameters';
EXECUTE IMMEDIATE 'update colbufferitem set bffrUpperLimit = bffrLowerLimit , targetBffr= bffrLowerLimit ,bffrLowerLimit = 0
                   where bffrLowerLimit is not null and bffrUpperLimit is null';
EXECUTE IMMEDIATE 'update colbufferitem set targetBffr= bffrLowerLimit ,bffrLowerLimit = 0
                   where bffrLowerLimit is not null and bffrUpperLimit is not null';
EXECUTE IMMEDIATE 'CREATE INDEX ColBufferItemIndex ON ColBufferItem(colRatingContingentParametersId)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/