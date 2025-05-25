--START
declare
results varchar2(10);
v_max_id NUMBER(19);

begin

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-51522_Adding_repo_or_tba_field_on_Configuration>Preferences';

if results > 0 then
    return;
end if;
    select max(id) into v_max_id from preferences;
    v_max_id := v_max_id+1;

INSERT INTO preferences (ID, PARENT, PREFTYPE, NAME, PREFVALUE, PREFCLASS) VALUES (v_max_id, 7, '(global)','REPO OR TBA CONFIG',NULL,NULL);

insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-51522_Adding_repo_or_tba_field_on_Configuration>Preferences');
commit;
end;
/
--END