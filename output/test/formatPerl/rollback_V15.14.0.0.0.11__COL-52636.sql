-- ð Rollback of V15.14.0.0.0.11__COL-52636.sql
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_sequence_sql': SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''CommonRefData_SEQ'')
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_next_val_sql': SELECT CommonRefData_SEQ.NEXTVAL FROM DUAL
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_max_id_sql': SELECT nvl(MAX (id),0) FROM RefData
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'rejected' AND description = 'rejected' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'substitution accepted' AND description = 'substitution accepted' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'substitution cancelled' AND description = 'substitution cancelled' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposed' AND description = 'proposed' AND status = 11;
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Reject Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Sent';
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept';
-- â ï¸ MANUAL CHECK REQUIRED: delete statement needs manual rollback.
-- ORIGINAL: DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Cancel';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'col-52636_update_substitution_amp_statuses';
