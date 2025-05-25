DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-66372-add-subReasonCorpAction_to_Workflow';
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

EXECUTE IMMEDIATE 'CREATE TABLE colWorkflowSubreasonCorpAction (id NUMBER(19) PRIMARY key,
                        workflowid NUMBER(19) NOT NULL,
                        corpactionid NUMBER(19) DEFAULT 0)';
EXECUTE IMMEDIATE 'create index IDX_wfSubReasonCorpAction on colWorkflowSubreasonCorpAction   (workflowid,corpactionid)';

EXECUTE IMMEDIATE 'CREATE TABLE colWorkflowSubreasonCorpActionHist (id NUMBER(19) PRIMARY key,
                        historyid NUMBER(19) NOT NULL,
                        corpactionid NUMBER(19) DEFAULT 0)';
EXECUTE IMMEDIATE 'create index IDX_wfSubReasonCorpActionHist on colWorkflowSubreasonCorpActionHist  (historyid,corpactionid)';

EXECUTE IMMEDIATE 'create sequence WorkflowSubreasonCorpAction_seq  minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 100';
EXECUTE IMMEDIATE 'create sequence WorkflowSubreasonCorpActionHist_seq  minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 100';

    INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;