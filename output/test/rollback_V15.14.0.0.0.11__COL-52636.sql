-- 🔁 Rollback of V15.14.0.0.0.11__COL-52636.sql
-- ⚠️ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable v_select_sequence_sql
-- ORIGINAL: EXECUTE IMMEDIATE v_select_sequence_sql INTO s_count;
-- ⚠️ Unrecognized EXECUTE IMMEDIATE rollback from v_select_next_val_sql: SELECT CommonRefData_SEQ.NEXTVAL FROM DUAL
-- ⚠️ Unrecognized EXECUTE IMMEDIATE rollback from v_select_max_id_sql: SELECT nvl(MAX (id),0) FROM RefData
DELETE FROM refdata WHERE id = 'v_next_val' AND scheme = 'STATUS_AMP' AND refdatavalue = 'Rejected' AND description = 'Rejected' AND status = 11 ;
DELETE FROM refdata WHERE id = 'v_next_val' AND scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Accepted' AND description = 'Substitution Accepted' AND status = 11 ;
DELETE FROM refdata WHERE id = 'v_next_val' AND scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Cancelled' AND description = 'Substitution Cancelled' AND status = 11 ;
DELETE FROM refdata WHERE id = 'v_next_val' AND scheme = 'STATUS_AMP' AND refdatavalue = 'Proposed' AND description = 'Proposed' AND status = 11 ;
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Reject Initiated';
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept Initiated';
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Initiated';
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Sent';
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept';
-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Cancel';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52636_Update_Substitution_AMP_Statuses' ;
