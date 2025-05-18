-- 🔁 Rollback of V25.2.0.0.0.1__COL-66227.sql
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
  -- Revert: DELETE inserted row (dynamic column resolution at runtime)
DECLARE
  v_sql VARCHAR2(4000);
BEGIN
  SELECT 'DELETE FROM preferences WHERE ' ||
         LISTAGG(column_name || ' = ' || '/* map value here */', ' AND ')
         WITHIN GROUP (ORDER BY column_id)
  INTO v_sql
  FROM all_tab_columns
  WHERE table_name = UPPER('preferences')
    AND owner = USER;

  -- Print or execute
  DBMS_OUTPUT.PUT_LINE(v_sql);
  -- EXECUTE IMMEDIATE v_sql;
END;
/

insert into lrsschemaproperties(modulename, propertyname) values('collateral','COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc');

commit;
end;
/
