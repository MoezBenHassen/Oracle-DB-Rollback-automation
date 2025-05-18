-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
DECLARE
        results    NUMBER;
        v_module   VARCHAR2(100) := 'collateral';
        v_property VARCHAR2(100) := 'COL-67825-AddAuditColumnsFor_agreementcrossgroup';
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

         --0- Check if the column exists
        SELECT
                COUNT(1)
        INTO
                column_count
        FROM
                user_tab_columns
        WHERE
                table_name  = 'COLAGREEMENTCROSSGROUP'
        AND     column_name = 'XXX_DAT_CRE';

        IF column_count = 0 THEN

        --1- add columns to the table
    v_sql := 'alter table colagreementcrossgroup add XXX_DAT_CRE DATE';
    EXECUTE IMMEDIATE v_sql;
    v_sql := 'alter table colagreementcrossgroup add XXX_DAT_UPD DATE';
    EXECUTE IMMEDIATE v_sql;

    --2-initialize new columns with sysdate
    v_sql :='update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE';
    EXECUTE IMMEDIATE v_sql;

    --4- modify columns to not null
  -- MODIFY detected, manual revert required
  -- v_sql := 'ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_CRE DATE NOT NULL)';
    EXECUTE IMMEDIATE v_sql;

  -- MODIFY detected, manual revert required
  -- v_sql := 'ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_UPD NOT NULL)';
    EXECUTE IMMEDIATE v_sql;

   dbms_output.put_line( '--5-creating audit trigger for colagreementcrossgroup'  );
   create_table_audit_trigger('colagreementcrossgroup');

   dbms_output.put_line( '--6-creating index for colagreementcrossgroup'  );

   IF NOT check_index_exists('idx_colAgrCrossGroup_dat_upd') THEN
        v_sql := 'create index idx_colAgrCrossGroup_dat_upd on colagreementcrossgroup(xxx_dat_upd)';
        EXECUTE IMMEDIATE v_sql;
    END IF;
   END IF;
   dbms_output.put_line( 'colagreementcrossgroup migration is done');

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
   COMMIT;
