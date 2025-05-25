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
  and l.propertyname = 'COL-56214_Add_Enable_Booking_At_Parent_Level';

if results > 0 then
     return;
end if;
INSERT into preferences VALUES (LASTID , 7, '(global)', 'Enable_Booking_At_Parent_Level', 'false', null);

insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-56214_Add_Enable_Booking_At_Parent_Level');

commit;
end;
/
--END