DECLARE
    results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'Substitution_Request_Generated_via_Inventory_Manager_Feed';
    v_column_exists integer;
BEGIN

   SELECT count(1) INTO results FROM lrsschemaproperties l
                                WHERE l.modulename = v_module AND l.propertyname = v_property;

   IF results > 0
    THEN
        RETURN;
    END IF;

   SELECT COUNT(*) INTO v_column_exists FROM user_tab_cols
                                        WHERE upper(column_name) = 'NEGATIVEINVENTORYPOSITIONAMT' AND upper(table_name) = 'COLSECURITYPARAMOUNT';

   IF (v_column_exists = 0) THEN
                EXECUTE IMMEDIATE 'ALTER TABLE COLSECURITYPARAMOUNT ADD negativeInventoryPositionAmt FLOAT DEFAULT 0 NOT NULL';
   END IF;

   INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
   COMMIT;
END;
/