DECLARE
    results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-62691-AddtriggerForColfirmpositionNotionalWhenDelete';
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

    EXECUTE IMMEDIATE 'create table colfirmpositionNotionalDelete(id NUMBER(19,0), deletedDate DATE ,lastUpdatedDate DATE)';
    EXECUTE IMMEDIATE 'create unique INDEX IDX_Frm_NOTION_DEL_ID on colfirmpositionNotionalDelete(ID)';
    EXECUTE IMMEDIATE 'create INDEX IDX_Frm_NOTION_DEL_DATE on colfirmpositionNotionalDelete(deletedDate)';

    IF NOT check_index_exists('idx_colfirmpositionNotional_dat_upd') THEN
                v_sql := 'create index idx_colfirmpositionNotional_dat_upd on colfirmpositionNotional(xxx_dat_upd)';
               EXECUTE IMMEDIATE v_sql;
      END IF;

    v_sql := 'CREATE OR REPLACE TRIGGER colfirmpositionNotional_trig_del AFTER
                DELETE ON colfirmpositionNotional
                FOR EACH ROW
            DECLARE
                now DATE := sysdate;
            BEGIN
                INSERT INTO colfirmpositionNotionalDelete VALUES (:old.ID,  now, :old.XXX_DAT_UPD);
            END;';
    EXECUTE IMMEDIATE v_sql;

    INSERT INTO lrsschemaproperties (modulename,propertyname) VALUES ( v_module,v_property );

    COMMIT;
END;