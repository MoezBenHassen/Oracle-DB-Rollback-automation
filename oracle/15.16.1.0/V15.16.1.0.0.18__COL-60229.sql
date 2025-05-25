declare
results NUMBER(10);
    v_constraint_name VARCHAR2(255);

begin

select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
  and l.propertyname = 'COL-60229_Colline_Crashes_when_update_Not_Net';

if results > 0 then
    return;
end if;

SELECT constraint_name
INTO v_constraint_name
FROM user_constraints
WHERE table_name = 'COLBUFFERITEM'
  AND constraint_type = 'R';

EXECUTE IMMEDIATE 'ALTER TABLE ColBufferItem DROP CONSTRAINT ' || v_constraint_name;
EXECUTE IMMEDIATE 'ALTER TABLE ColBufferItem ADD CONSTRAINT fk_colbufferitem_colrating '
    || 'FOREIGN KEY (ColRatingContingentParametersId) '
    || 'REFERENCES ColRatingContingentParameters(Id) ON DELETE CASCADE';


insert into lrsSchemaProperties(moduleName, propertyName) values('collateral', 'COL-60229_Colline_Crashes_when_update_Not_Net');
commit;
end;