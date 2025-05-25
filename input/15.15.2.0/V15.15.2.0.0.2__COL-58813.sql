DECLARE
    results    NUMBER;
    v_module   VARCHAR2(100) := 'task_scheduler';
    v_property VARCHAR2(100) := 'COL_9999_add_archive_data_column';
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

    EXECUTE IMMEDIATE 'alter table F3JOB add archiveData NUMBER(1,0)';
    EXECUTE IMMEDIATE 'update  F3JOB set archivedata = 0 where archivedata is null';

    insert into lrsSchemaProperties(moduleName, propertyName) values(v_module, v_property);

    COMMIT;
END;
/