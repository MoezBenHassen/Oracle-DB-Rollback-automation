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
  and l.propertyname = 'COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc';

if results > 0 then
     return;
end if;


insert into moezTest values (2, 'Smith', 'Jane', '456 Oak St', 'Springfield');


insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc');

commit;
end;
/
--END