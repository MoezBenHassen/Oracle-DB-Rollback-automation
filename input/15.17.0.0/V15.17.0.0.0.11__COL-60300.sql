DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60300_Add_LB_Bookings_Fields_To_ColSecParamount';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColSecurityParamount ADD (linkedTicketIdLB NUMBER(19) DEFAULT 0, linkedTicketResultLB NUMBER(1) DEFAULT 0, linkedLongBoxId NUMBER(19) DEFAULT 0)';
EXECUTE IMMEDIATE 'CREATE INDEX IDX_linkedTicketIdLB ON ColSecurityParamount (linkedTicketIdLB)';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
