DECLARE
    results     NUMBER;
    v_module    VARCHAR2(100) := 'collateral';
    v_property  VARCHAR2(100) := 'COL-62691-AddindexesonAuditColumnsFor_OSA_inter_Tables';
    TYPE curtyp IS REF CURSOR;
    tablecursor curtyp;
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
     IF check_index_exists('IDX_SEC_dat_upd') THEN
        EXECUTE IMMEDIATE 'DROP INDEX IDX_SEC_dat_upd';
     END IF;


    FOR curtables IN (
        SELECT DISTINCT
            table_name
        FROM
            user_tab_columns
        WHERE
            column_name = 'XXX_DAT_UPD'
    ) LOOP
        BEGIN
            IF NOT check_index_exists('idx_'
                                      || curtables.table_name
                                      || '_dat_upd') THEN
                v_sql := 'create index idx_'
                         || curtables.table_name
                         || '_dat_upd on '
                         || curtables.table_name
                         || '(xxx_dat_upd)';

                EXECUTE IMMEDIATE v_sql;
            END IF;

        END;
    END LOOP;

    INSERT INTO lrsschemaproperties (modulename,propertyname) VALUES ( v_module,v_property );

    COMMIT;
END;