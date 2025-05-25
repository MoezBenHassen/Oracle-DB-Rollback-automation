DECLARE
        results    NUMBER;
        v_module   VARCHAR2(100) := 'collateral';
        v_property VARCHAR2(100) := 'COL-63186-AddAuditColumnsFor_OSA_inter_Tables_v3';
TYPE table_name_array
IS
        TABLE OF VARCHAR2(100);
        table_names table_name_array := table_name_array('colagreementassets', 'colassets');
        column_count NUMBER;
          id_column_count NUMBER;
        v_sql        VARCHAR2(2000);
BEGIN
        SELECT
                COUNT(1)
        INTO
                results
        FROM
                lrsschemaproperties l
        WHERE
                l.modulename   = v_module
        AND     l.propertyname = v_property;

        IF results > 0 THEN
                RETURN;
        END IF;


        v_sql := 'create or replace  view auditTrail_view as
                     select  upper(beanname) as beanName, objectid,
                         TO_TIMESTAMP(''1970-01-01 00:00:00'', ''YYYY-MM-DD HH24:MI:SS'') + NUMTODSINTERVAL(C1.creationdate / 1000, ''SECOND'') AS creationdate,
                         TO_TIMESTAMP(''1970-01-01 00:00:00'', ''YYYY-MM-DD HH24:MI:SS'') + NUMTODSINTERVAL(C1.updateddate / 1000, ''SECOND'') AS updateddate
                         from(
                     SELECT
                         audittrail.beanname,
                         audittrail.objectid,
                         MIN(audittrail.ts) AS creationdate,
                         MAX(audittrail.ts) AS updateddate
                     FROM
                         audittrail
                     GROUP BY
                         beanname,objectid)C1';
        EXECUTE IMMEDIATE v_sql;

        FOR i IN 1..table_names.count
        LOOP
                BEGIN
                        --0- Check if the column exists
                        SELECT
                                COUNT(1)
                        INTO
                                column_count
                        FROM
                                user_tab_columns
                        WHERE
                                table_name  = UPPER(table_names(i))
                        AND     column_name = 'XXX_DAT_CRE';

                        IF column_count = 0 THEN
                                --1- add columns to the table
                                v_sql := 'alter table '|| table_names(i)|| ' add XXX_DAT_CRE DATE';
                                EXECUTE IMMEDIATE v_sql;
                                v_sql := 'alter table ' || table_names(i)|| ' add XXX_DAT_UPD DATE';
                                EXECUTE IMMEDIATE v_sql;

								--2-initialize new columns with sysdate
                                v_sql :='update ' || table_names(i)|| ' set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE';
                                EXECUTE IMMEDIATE v_sql;

                                SELECT COUNT(1) INTO
                                                id_column_count
                                        FROM
                                                user_tab_columns
                                        WHERE
                                                table_name  = UPPER(table_names(i))
                                        AND     column_name = 'ID';
                                    IF id_column_count> 0 THEN
                                                --3-update new columns from auditTrail
                                                v_sql := 'MERGE INTO '
                                                || table_names(i)
                                                || ' t using (select * from auditTrail_view where beanname='''
                                                || UPPER(table_names(i))
                                                || ''') s ON (t.id = s.objectid)
                                            WHEN MATCHED THEN
                                            UPDATE SET t.XXX_DAT_CRE = s.CREATIONDATE, t.XXX_DAT_UPD = s.updateddate';
                                             EXECUTE IMMEDIATE v_sql;
                                END IF;
                                --4- modify columns to not null
                                v_sql := 'ALTER TABLE ' || table_names(i) || '  MODIFY (XXX_DAT_CRE DATE NOT NULL)';
                                EXECUTE IMMEDIATE v_sql;

                                v_sql := 'ALTER TABLE ' || table_names(i) || '  MODIFY (XXX_DAT_UPD NOT NULL)';
                                EXECUTE IMMEDIATE v_sql;

                               dbms_output.put_line( '--5-creating audit trigger for ' || table_names(i) );
                               create_table_audit_trigger(table_names(i));

                               dbms_output.put_line( table_names(i) || ' migration is done');
                        END IF;
				EXCEPTION
                        WHEN OTHERS THEN
                                dbms_output.put_line('Error creating audit columns for table: '
                                || table_names(i)
                                || ' - '
                                || SQLERRM);
               END;
        END LOOP;

       INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
       COMMIT;
END;