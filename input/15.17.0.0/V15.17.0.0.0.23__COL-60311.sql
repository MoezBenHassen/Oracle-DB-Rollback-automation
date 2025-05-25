declare
  results varchar2(10);
begin

  select count(1)
    into results
    from lrsschemaproperties l
  where l.modulename = 'collateral'
    and l.propertyname = 'COL-60311_idg_match';

  if results > 0 then
    return;
  end if;


  EXECUTE IMMEDIATE 'ALTER TABLE colrefdata ADD match NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE orgrefdata ADD match NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE refdata ADD match NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE udfvaluesrefdata ADD match NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE TRADINGREFDATA ADD match NUMBER(19,0) DEFAULT 0';

  insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-60311_idg_match');
  commit;
end;
/