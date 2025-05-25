-- ð Rollback of V15.14.0.0.0.11__COL-52636.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: s_count                NUMBER(10);
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val             NUMBER(19):=1;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_max_id               NUMBER(19);
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_select_sequence_sql  VARCHAR(2000);
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_select_next_val_sql  VARCHAR(2000);
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_select_max_id_sql    VARCHAR(2000);
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_sequence_sql': SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name =  upper(''CommonRefData_SEQ'')
-- â ï¸ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable 'v_select_next_val_sql'
-- ORIGINAL: EXECUTE IMMEDIATE v_select_next_val_sql INTO v_next_val;
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_max_id_sql': SELECT nvl(MAX (id),0) FROM RefData
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Rejected' AND description = 'Rejected' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Accepted' AND description = 'Substitution Accepted' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Cancel Initiated' AND description = 'Cancel Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Cancel Issued' AND description = 'Cancel Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Substitution Cancelled' AND description = 'Substitution Cancelled' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Initiated' AND description = 'Proposal Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Issued' AND description = 'Proposal Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposed' AND description = 'Proposed' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Accepted' AND description = 'Proposal Accepted' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Rejected' AND description = 'Proposal Rejected' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Cancelled Initiated' AND description = 'Proposal Cancelled Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Cancelled Issued' AND description = 'Proposal Cancelled Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Cancelled' AND description = 'Proposal Cancelled' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Propose Amended Initiated' AND description = 'Propose Amended Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Proposal Amended' AND description = 'Proposal Amended' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Replacement Added' AND description = 'Replacement Added' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Replacement Issued' AND description = 'Replacement Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Create Initiated' AND description = 'Create Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Created Issued' AND description = 'Created Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Amended Initiated' AND description = 'Amended Initiated' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'STATUS_AMP' AND refdatavalue = 'Amended Issued' AND description = 'Amended Issued' AND status = 11;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'CANCELCODES_AMP' AND refdatavalue = '9201' AND description = 'Replacement Collateral Unavailable' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'CANCELCODES_AMP' AND refdatavalue = '9202' AND description = 'Requested Collateral Inaccurate' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'CANCELCODES_AMP' AND refdatavalue = '9203' AND description = 'Asset Recall Not Required' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_next_val := v_next_val+1;
DELETE FROM refdata WHERE scheme = 'CANCELCODES_AMP' AND refdatavalue = '9204' AND description = 'Duplicate Request' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
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
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52636_Update_Substitution_AMP_Statuses';
