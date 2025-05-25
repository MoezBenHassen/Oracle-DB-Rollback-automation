declare
  results varchar2(10);
  v_max_id               NUMBER(19);
  v_select_max_id_sql    VARCHAR(2000);

begin

  select count(1)
    into results
    from lrsschemaproperties l
  where l.modulename = 'collateral'
    and l.propertyname = 'COL60429_Purge_Archived_Statements_task';

  if results > 0 then
    return;
  end if;

  v_select_max_id_sql := 'SELECT nvl(MAX (table_sequence),0) FROM col_purge_tables where table_name =''ColStatementHistory''';
  EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;
  update col_purge_tables set table_sequence = table_sequence+1 where table_sequence > v_max_id-1;

    INSERT INTO COL_PURGE_TABLES (TABLE_SEQUENCE, TABLE_NAME, COLUMN_DEL, DOMAIN, OFFDAYS, RECORD_SIZE)
    VALUES (v_max_id, 'ColStatementBufferHistory', 'statementHistoryId', 'StatementHistory', '0', '200000');

      insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL60429_Purge_Archived_Statements_task');
      commit;
    end;