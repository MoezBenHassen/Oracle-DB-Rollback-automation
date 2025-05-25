DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-58231_Logic_for_Calculating_Margin_events_with_Dual_Buffer_Types';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement  ADD appliedTargetBuffer float(126) DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatement  ADD imAppliedTargetBuffer float(126) DEFAULT 0';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD netEdOrMarginReqAppliedPrinc float(126)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD netEdOrMarginReqAppliedCpty float(126)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD imNetEdOrMarginReqAppliedPrinc float(126)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD imNetEdOrMarginReqAppliedCpty float(126)';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD vmBufferTypePrinc  varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD vmBufferTypeCpty  varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD imbufferTypePrinc  varchar(250)';
EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer  ADD imbufferTypeCpty  varchar(250)';
INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
