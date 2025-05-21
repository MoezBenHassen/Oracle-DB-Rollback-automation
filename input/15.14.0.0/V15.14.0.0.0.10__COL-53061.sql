declare
  results varchar2(10);
begin

  select count(1)
    into results
    from lrsschemaproperties l
  where l.modulename = 'collateral'
    and l.propertyname = 'COL-53061_cancellation_code';

  if results > 0 then
    return;
  end if;

  EXECUTE IMMEDIATE 'ALTER TABLE refdata ADD substitutionCanceled NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE colrefdata ADD substitutionCanceled NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE orgrefdata ADD substitutionCanceled NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE UDFValuesRefData ADD substitutionCanceled NUMBER(19,0) DEFAULT 0';
  EXECUTE IMMEDIATE 'ALTER TABLE tradingrefdata ADD substitutionCanceled NUMBER(19,0) DEFAULT 0';

  insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-53061_cancellation_code');
  commit;
end;
/
