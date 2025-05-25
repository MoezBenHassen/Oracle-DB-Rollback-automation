declare
results NUMBER(10);

begin

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-58227_Add_Buffer_Fields_Multimodel';

if results > 0 then
    return;
end if;

EXECUTE IMMEDIATE 'alter table ColStatementModel add adjVmMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementModel add adjVmMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementModel add adjIaMarginReqPrinc float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementModel add adjIaMarginReqCtpy float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementModel add adjVMNetED float(126) default 0';
EXECUTE IMMEDIATE 'alter table ColStatementModel add adjIMNetED float(126) default 0';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer
    ADD statementmodelId NUMBER(19, 0)';

EXECUTE IMMEDIATE 'ALTER TABLE ColStatementBuffer
    ADD CONSTRAINT fk_statement
        FOREIGN KEY (statementmodelId)
            REFERENCES ColStatementModel(Id)';


insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-58227_Add_Buffer_Fields_Multimodel');
commit;
end;