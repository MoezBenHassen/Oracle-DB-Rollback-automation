declare
  results varchar2(10);

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
    and l.propertyname = 'COL-52636_Update_Substitution_AMP_Statuses';

  if results > 0 then
    return;
  end if;

  v_select_sequence_sql := 'SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''CommonRefData_SEQ'')';
  EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
  IF s_count > 0
  THEN
    v_select_next_val_sql := 'SELECT CommonRefData_SEQ.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
  END IF;

  v_select_max_id_sql := 'SELECT nvl(MAX (id),0) FROM RefData';
  EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;

  IF (v_max_id > v_next_val)
    THEN
      v_next_val := v_max_id+1;
  END IF;

  insert into RefData(id, scheme, refDataValue, description, status) VALUES (v_next_val,'STATUS_AMP', 'Rejected', 'Rejected', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status) VALUES (v_next_val,'STATUS_AMP', 'Substitution Accepted', 'Substitution Accepted', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Cancel Initiated', 'Cancel Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Cancel Issued', 'Cancel Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status) VALUES (v_next_val,'STATUS_AMP', 'Substitution Cancelled', 'Substitution Cancelled', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Initiated', 'Proposal Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Issued', 'Proposal Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status) VALUES (v_next_val,'STATUS_AMP', 'Proposed', 'Proposed', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Accepted', 'Proposal Accepted', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Rejected', 'Proposal Rejected', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Cancelled Initiated', 'Proposal Cancelled Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Cancelled Issued', 'Proposal Cancelled Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Cancelled', 'Proposal Cancelled', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Propose Amended Initiated', 'Propose Amended Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Proposal Amended', 'Proposal Amended', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Replacement Added', 'Replacement Added', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Replacement Issued', 'Replacement Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Create Initiated', 'Create Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Created Issued', 'Created Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Amended Initiated', 'Amended Initiated', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status)
    VALUES (v_next_val,'STATUS_AMP', 'Amended Issued', 'Amended Issued', 11);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status, flag, category, substitutionCanceled)
    VALUES (v_next_val,'CANCELCODES_AMP', '9201', 'Replacement Collateral Unavailable', 11, 0, 0, 1);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status, flag, category, substitutionCanceled)
    VALUES (v_next_val,'CANCELCODES_AMP', '9202', 'Requested Collateral Inaccurate', 11, 0, 0, 1);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status, flag, category, substitutionCanceled)
    VALUES (v_next_val,'CANCELCODES_AMP', '9203', 'Asset Recall Not Required', 11, 0, 0, 1);
  v_next_val := v_next_val+1;

  insert into RefData(id, scheme, refDataValue, description, status, flag, category, substitutionCanceled)
    VALUES (v_next_val,'CANCELCODES_AMP', '9204', 'Duplicate Request', 11, 0, 0, 1);

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Reject Initiated';

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept Initiated';

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Initiated';

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Sent';

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept';

  DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Cancel';

  insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-52636_Update_Substitution_AMP_Statuses');
  commit;
end;
/
