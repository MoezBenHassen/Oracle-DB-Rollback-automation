-- ð Rollback of V15.14.0.0.0.11__COL-52636.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     and l.propertyname = 'COL-52636_Update_Substitution_AMP_Statuses';
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_sequence_sql': SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''CommonRefData_SEQ'')
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   IF s_count > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   THEN
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_next_val_sql': SELECT CommonRefData_SEQ.NEXTVAL FROM DUAL
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_max_id_sql': SELECT nvl(MAX (id),0) FROM RefData
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   IF (v_max_id > v_next_val)
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     THEN
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Rejected' AND description = 'Rejected' AND status = 11;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Accepted' AND description = 'Substitution Accepted' AND status = 11;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Cancelled' AND description = 'Substitution Cancelled' AND status = 11;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposed' AND description = 'Proposed' AND status = 11;
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Reject Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Initiated';
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Sent';
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Accept';
-- â ï¸ MANUAL CHECK REQUIRED: Delete statement needs manual rollback.
-- ORIGINAL:   DELETE FROM RefData WHERE SCHEME = 'STATUS_AMP' AND refDataValue ='Substitution Cancel';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52636_Update_Substitution_AMP_Statuses';
