--START
declare
results varchar2(10);
begin

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-52623_Add3_fields_to_Family_statement';

if results > 0 then
     return;
end if;

EXECUTE IMMEDIATE 'ALTER TABLE colstatement ADD FUTURESETTLEMENTDEBIT FLOAT(126) DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE colstatement ADD FUTURESETTLEMENTCREDIT FLOAT(126) DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE colstatement ADD BOOKINGSETTLEMENTTODAY FLOAT(126) DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE colstatement ADD BOOKINGSETTLEMENTTODAYCASH FLOAT(126) DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE colstatement ADD BOOKINGSETTLEMENTTODAYNOCASH FLOAT(126) DEFAULT 0';

insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-52623_Add3_fields_to_Family_statement');

commit;
end;
/
--END