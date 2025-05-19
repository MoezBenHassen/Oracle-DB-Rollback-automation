 --START
declare
results varchar2(10);
LASTID NUMBER;
MAXID NUMBER;
begin
select MAX(id) INTO MAXID from preferences ;
LASTID := MAXID + 1;

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-51455_Add_field_Stale_Approve_to_Preferences';

if results > 0 then
     return;
end if;
INSERT into preferences VALUES (LASTID , 7, '(global)', 'Stale_Approval_Restriction', 'false', null);

insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-51455_Add_field_Stale_Approve_to_Preferences');

commit;
end;
/
--END