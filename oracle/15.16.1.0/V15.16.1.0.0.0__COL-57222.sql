declare
  results varchar2(10);
  s_count                Number(10);
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
    and l.propertyname = 'COL57222_Third_Party_Approval';

  if results > 0 then
    return;
  end if;

  v_select_sequence_sql := 'SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''COLRefData_SEQ'')';
  EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
  IF s_count > 0
  THEN
    v_select_next_val_sql := 'SELECT COLRefData_SEQ.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
  END IF;

  v_select_max_id_sql := 'SELECT nvl(MAX (id),0) FROM ColRefData';
  EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;

  IF (v_max_id > v_next_val)
    THEN
      v_next_val := v_max_id+1;
  END IF;


    INSERT INTO ColRefData (ID, SCHEME, REFDATAVALUE, DESCRIPTION, STATUS, CATEGORY, FLAG,SWIFTREFID) VALUES (v_next_val, 'Scheme', 'Third Party Approval', 'Depot Bank', 11,0, 0, 0);
    v_next_val := v_next_val+1;

      insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL57222_Third_Party_Approval');
      commit;
    end;