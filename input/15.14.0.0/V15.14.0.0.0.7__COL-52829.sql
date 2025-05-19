--START
declare
results varchar2(10);
v_max_id NUMBER(19);

begin

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences';

if results > 0 then
    return;
end if;

select max(id) into v_max_id from preferences;
v_max_id := v_max_id+1;

INSERT INTO preferences (ID, PARENT, PREFTYPE, NAME, PREFVALUE, PREFCLASS) VALUES (v_max_id, 7, '(global)','MTA BUSINESS LINES CONFIG','41,22',NULL);

insert into lrsSchemaProperties(moduleName, propertyName) values ('collateral', 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences');
commit;
end;
/
--END