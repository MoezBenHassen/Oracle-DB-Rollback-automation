DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-61422_RepoETFSBL_Rejected_Trades_Report_task_failed_to_run_[Postgres]';
  rowCount NUMBER;
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

  -- Check if there are any non-null values in the cleanPrice column
  SELECT COUNT(*) INTO rowCount FROM ColRptOutRejectedTradesRepo WHERE cleanPrice IS NOT NULL;

  IF rowCount = 0 THEN
    -- If no data, modify the existing column directly
    EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutRejectedTradesRepo MODIFY cleanPrice VARCHAR2(250)';
  ELSE
    -- If cleanPrice column has data, create a new column and copy data over
    EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutRejectedTradesRepo ADD cleanPrice_new VARCHAR2(250)';
    EXECUTE IMMEDIATE 'UPDATE ColRptOutRejectedTradesRepo SET cleanPrice_new = cleanPrice';
    EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutRejectedTradesRepo DROP COLUMN cleanPrice';
    EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutRejectedTradesRepo RENAME COLUMN cleanPrice_new TO cleanPrice';
  END IF;

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;