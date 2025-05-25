  --START
declare
  results NUMBER(10);

  s_count                NUMBER(10);
  v_next_val             NUMBER(19):=1;
  v_max_id               NUMBER(19);
  v_select_sequence_sql  VARCHAR(2000);
  v_select_next_val_sql  VARCHAR(2000);
  v_select_max_id_sql    VARCHAR(2000);
begin

  select count(1)
    into results
    from lrsschemaproperties l
  where l.modulename = 'collateral'
    and l.propertyname = 'COL-61191_add_benchmark';

  if results > 0 then
    return;
  end if;

  v_select_sequence_sql := 'SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''RefData_SEQ'')';
  EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
  IF s_count > 0
  THEN
    v_select_next_val_sql := 'SELECT RefData_SEQ.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
  END IF;

  v_select_max_id_sql := 'SELECT nvl(MAX (id),0) FROM RefData';
  EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;

  IF (v_max_id > v_next_val)
    THEN
      v_next_val := v_max_id+1;
  END IF;

    INSERT INTO RefData (id, scheme, refdatavalue, description, status, category, flag, searchable, swiftRefId, substitutionCanceled , isLongBox ,inventoryDG ,inventoryManagerSS)
     VALUES (v_next_val, 'Scheme', 'Acadia Interest Benchmark', 'Acadia Interest Benchmark', 11,0, 0, 0,0,0,0,null,0);

    insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-61191_add_benchmark');
  commit;
end;
/
--END