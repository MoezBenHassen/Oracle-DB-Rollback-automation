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
    and l.propertyname = 'COL59470_Approve_Settlement_Instructions_Task';

  if results > 0 then
    return;
  end if;

  v_select_sequence_sql := 'SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''F3Job_SEQ'')';
  EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
  IF s_count > 0
  THEN
    v_select_next_val_sql := 'SELECT F3Job_SEQ.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
  END IF;

  v_select_max_id_sql := 'SELECT nvl(MAX (id),0) FROM F3Job';
  EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;

  IF (v_max_id > v_next_val)
    THEN
      v_next_val := v_max_id+1;
  END IF;

INSERT INTO f3job (id,jobname,groupname,freqperiod,starttime,repeatinterval,timezone,startjob,jobclassname,additionalinfo,prescript,postscript,misc1,misc2,duplicated,lastmodifiedby,lastmodifiedtime,priority,endtime,misc3,misc4,misc5,sept,issystem,taskregion,taskgroup,taskbusinessline,category,misc6,genlock,misc7,archiveData)
SELECT v_next_val,'Approve Settlement Instructions','Workflow',0,0,0,0,0,'com.lombardrisk.colline.asset.service.impl.job.ColApproveSettlementInstructionsJob',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,5,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,10,NULL,0,NULL,0 FROM JBM_DUAL
where NOT EXISTS (select * from F3Job where JOBNAME like 'Approve Settlement Instructions');

    insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL59470_Approve_Settlement_Instructions_Task');
  commit;
end;