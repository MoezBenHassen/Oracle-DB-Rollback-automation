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
INSERT into preferences VALUES (LASTID , 7, '(global)', 'Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc', 'false', null);

insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc');

commit;
end;
/
--END