DECLARE
    results NUMBER;
BEGIN
    SELECT COUNT(1)
    INTO results
    FROM lrsschemaproperties l
    WHERE l.modulename = 'collateral'
      AND l.propertyname = 'COL57234_third_party';

    IF results > 0 THEN
        NULL; -- Do nothing
    ELSE
        EXECUTE IMMEDIATE 'ALTER TABLE ColScheduler ADD ThirdPartyApproval VARCHAR2(200) DEFAULT ''0''';

        INSERT INTO lrsschemaproperties (modulename, propertyname)
        VALUES ('collateral', 'COL57234_third_party');
    END IF;
END;