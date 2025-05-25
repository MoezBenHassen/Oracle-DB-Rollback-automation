DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-58225_Add_Buffer_Tables_Update_Statement';

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

EXECUTE IMMEDIATE 'CREATE TABLE ColStatementBuffer ('
    || 'id NUMBER(19, 0) NOT NULL PRIMARY KEY,'
    || 'vmLowerLimitPrinc float(126),'
    || 'vmUpperLimitPrinc float(126),'
    || 'vmTargetPrinc float(126),'
    || 'vmLowerLimitCpty float(126),'
    || 'vmUpperLimitCpty float(126),'
    || 'vmTargetCpty float(126),'
    || 'imLowerLimitPrinc float(126),'
    || 'imUpperLimitPrinc float(126),'
    || 'imTargetPrinc float(126),'
    || 'imLowerLimitCpty float(126),'
    || 'imUpperLimitCpty float(126),'
    || 'imTargetCpty float(126),'
    || 'statementId NUMBER(19, 0),'
    || 'FOREIGN KEY (statementId) REFERENCES ColStatement(Id))';

EXECUTE IMMEDIATE 'CREATE SEQUENCE ColStatementBuffer_SEQ START WITH 1 INCREMENT BY 1';

EXECUTE IMMEDIATE 'INSERT INTO ColStatementBuffer (id, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || ' imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, statementId)'
   || 'SELECT ColStatementBuffer_SEQ.NEXTVAL, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || 'imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, id FROM ColStatement';


EXECUTE IMMEDIATE 'CREATE TABLE ColStatementBufferHistory ('
    || 'id NUMBER(19, 0) NOT NULL PRIMARY KEY,'
    || 'vmLowerLimitPrinc float(126),'
    || 'vmUpperLimitPrinc float(126),'
    || 'vmTargetPrinc float(126),'
    || 'vmLowerLimitCpty float(126),'
    || 'vmUpperLimitCpty float(126),'
    || 'vmTargetCpty float(126),'
    || 'imLowerLimitPrinc float(126),'
    || 'imUpperLimitPrinc float(126),'
    || 'imTargetPrinc float(126),'
    || 'imLowerLimitCpty float(126),'
    || 'imUpperLimitCpty float(126),'
    || 'imTargetCpty float(126),'
    || 'statementHistoryId NUMBER(19, 0),'
    || 'FOREIGN KEY (statementHistoryId) REFERENCES ColStatementHistory(HistoryId))';

EXECUTE IMMEDIATE 'CREATE SEQUENCE ColStatementBufferHistory_SEQ START WITH 1 INCREMENT BY 1';

EXECUTE IMMEDIATE 'INSERT INTO ColStatementBufferHistory (id, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || ' imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, statementHistoryId)'
   || 'SELECT ColStatementBufferHistory_SEQ.NEXTVAL, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || 'imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, HistoryId FROM ColStatementHistory';


EXECUTE IMMEDIATE 'CREATE TABLE ColStatementModelBuffer ('
    || 'id NUMBER(19, 0) NOT NULL PRIMARY KEY,'
    || 'vmLowerLimitPrinc float(126),'
    || 'vmUpperLimitPrinc float(126),'
    || 'vmTargetPrinc float(126),'
    || 'vmLowerLimitCpty float(126),'
    || 'vmUpperLimitCpty float(126),'
    || 'vmTargetCpty float(126),'
    || 'imLowerLimitPrinc float(126),'
    || 'imUpperLimitPrinc float(126),'
    || 'imTargetPrinc float(126),'
    || 'imLowerLimitCpty float(126),'
    || 'imUpperLimitCpty float(126),'
    || 'imTargetCpty float(126),'
    || 'statementId NUMBER(19, 0),'
    || 'FOREIGN KEY (statementId) REFERENCES ColStatementModel(Id))';


EXECUTE IMMEDIATE 'CREATE SEQUENCE ColStatementModelBuffer_SEQ START WITH  1 INCREMENT BY 1';

EXECUTE IMMEDIATE 'INSERT INTO ColStatementModelBuffer (id, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || ' imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, statementId)'
   || 'SELECT ColStatementModelBuffer_SEQ.NEXTVAL, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || 'imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, id FROM ColStatementModel';

EXECUTE IMMEDIATE 'CREATE TABLE ColStatementModelBufferHistory ('
    || 'id NUMBER(19, 0) NOT NULL PRIMARY KEY,'
    || 'vmLowerLimitPrinc float(126),'
    || 'vmUpperLimitPrinc float(126),'
    || 'vmTargetPrinc float(126),'
    || 'vmLowerLimitCpty float(126),'
    || 'vmUpperLimitCpty float(126),'
    || 'vmTargetCpty float(126),'
    || 'imLowerLimitPrinc float(126),'
    || 'imUpperLimitPrinc float(126),'
    || 'imTargetPrinc float(126),'
    || 'imLowerLimitCpty float(126),'
    || 'imUpperLimitCpty float(126),'
    || 'imTargetCpty float(126),'
    || 'statementId NUMBER(19, 0),'
    || 'FOREIGN KEY (statementId) REFERENCES ColStatementModelHistory(Id))';

EXECUTE IMMEDIATE 'CREATE SEQUENCE ColStatementModelBufferHistory_SEQ START WITH 1 INCREMENT BY 1';

EXECUTE IMMEDIATE 'INSERT INTO ColStatementModelBufferHistory (id, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || ' imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, statementId)'
   || 'SELECT ColStatementModelBufferHistory_SEQ.NEXTVAL, vmLowerLimitPrinc, vmUpperLimitPrinc, vmLowerLimitCpty, vmUpperLimitCpty,imLowerLimitPrinc,'
   || 'imUpperLimitPrinc,imLowerLimitCpty, imUpperLimitCpty, id FROM ColStatementModelHistory';


EXECUTE IMMEDIATE 'alter table ColStatement add adjVmMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatement add adjVmMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatement add adjIaMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatement add adjIaMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatement add adjVMNetED float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatement add adjIMNetED float(126) default 0';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
