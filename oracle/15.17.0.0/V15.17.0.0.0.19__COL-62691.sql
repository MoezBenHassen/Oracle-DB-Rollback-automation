DECLARE
    results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-62691-AddtriggerForColfirmpositionWhenDelete';
    v_sql       VARCHAR2(2000);
BEGIN
    SELECT
        COUNT(1)
    INTO results
    FROM
        lrsschemaproperties l
    WHERE
            l.modulename = v_module
        AND l.propertyname = v_property;

    IF results > 0 THEN
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'create table colfirmpositionDelete(id NUMBER(19,0), deletedDate DATE ,lastUpdatedDate DATE)';
    EXECUTE IMMEDIATE 'create unique INDEX IDX_FIRMPOSITION_DEL_ID on colfirmpositionDelete(ID)';
    EXECUTE IMMEDIATE 'create INDEX IDX_FIRMPOSITION_DEL_DATE on colfirmpositionDelete(deletedDate)';
    v_sql := 'CREATE OR REPLACE TRIGGER colfirmposition_trig_del AFTER
                DELETE ON colfirmposition
                FOR EACH ROW
            DECLARE
                now DATE := sysdate;
            BEGIN
                INSERT INTO colfirmpositionDelete VALUES (:old.ID,  now, :old.XXX_DAT_UPD);
            END;';
    EXECUTE IMMEDIATE v_sql;

    INSERT INTO lrsschemaproperties (modulename,propertyname) VALUES ( v_module,v_property );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating delete trigger for colfirmposition table - ' || sqlerrm);
END;