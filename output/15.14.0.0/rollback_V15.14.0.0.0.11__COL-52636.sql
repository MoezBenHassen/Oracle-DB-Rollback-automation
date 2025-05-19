-- 🔁 Rollback of V15.14.0.0.0.11__COL-52636.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE v_select_max_id_sql INTO v_max_id;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52636_Update_Substitution_AMP_Statuses' ;
