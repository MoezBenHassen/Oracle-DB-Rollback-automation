DECLARE
    results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'Calculation_is_not_triggered_at_the_EM_screen_after_feeding_either_in_flush_or_delta_mode';
    v_first_column_exists integer;
    v_second_column_exists integer;
BEGIN

   SELECT count(1) INTO results FROM lrsschemaproperties l
                                WHERE l.modulename = v_module AND l.propertyname = v_property;

   IF results > 0
    THEN
        RETURN;
    END IF;

   SELECT COUNT(*) INTO v_first_column_exists FROM user_tab_cols
                                        WHERE upper(column_name) = 'NEGIMPOSITIONNOTIONAL' AND upper(table_name) = 'COLSUBEVENTINSTRUMENTS';

   IF (v_first_column_exists = 0) THEN
                EXECUTE IMMEDIATE 'ALTER TABLE ColSubEventInstruments ADD negIMPositionNotional FLOAT DEFAULT 0';
   END IF;

   SELECT COUNT(*) INTO v_second_column_exists FROM user_tab_cols
                                           WHERE upper(column_name) = 'NEGIMPOSITIONCOLVALUE' AND upper(table_name) = 'COLSUBEVENTINSTRUMENTS';

   IF (v_second_column_exists = 0) THEN
                   EXECUTE IMMEDIATE 'ALTER TABLE ColSubEventInstruments ADD negIMPositionColValue FLOAT DEFAULT 0';
   END IF;

   INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
   COMMIT;
END;
/