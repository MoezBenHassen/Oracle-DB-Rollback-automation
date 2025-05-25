-- ð Rollback of V15.14.0.0.0.11__COL-52636.sql
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_sequence_sql': SELECT count(*) FROM USER_SEQUENCES WHERE sequence_name = upper(''CommonRefData_SEQ'')
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_next_val_sql': SELECT CommonRefData_SEQ.NEXTVAL FROM DUAL
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_select_max_id_sql': SELECT nvl(MAX (id),0) FROM RefData
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'rejected' AND description = 'rejected' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'substitution accepted' AND description = 'substitution accepted' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'cancel initiated' AND description = 'cancel initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'cancel issued' AND description = 'cancel issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'substitution cancelled' AND description = 'substitution cancelled' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal initiated' AND description = 'proposal initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal issued' AND description = 'proposal issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposed' AND description = 'proposed' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal accepted' AND description = 'proposal accepted' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal rejected' AND description = 'proposal rejected' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal cancelled initiated' AND description = 'proposal cancelled initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal cancelled issued' AND description = 'proposal cancelled issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal cancelled' AND description = 'proposal cancelled' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'propose amended initiated' AND description = 'propose amended initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'proposal amended' AND description = 'proposal amended' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'replacement added' AND description = 'replacement added' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'replacement issued' AND description = 'replacement issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'create initiated' AND description = 'create initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'created issued' AND description = 'created issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'amended initiated' AND description = 'amended initiated' AND status = 11;
DELETE FROM refdata WHERE scheme = 'status_amp' AND refdatavalue = 'amended issued' AND description = 'amended issued' AND status = 11;
DELETE FROM refdata WHERE scheme = 'cancelcodes_amp' AND refdatavalue = '9201' AND description = 'replacement collateral unavailable' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
DELETE FROM refdata WHERE scheme = 'cancelcodes_amp' AND refdatavalue = '9202' AND description = 'requested collateral inaccurate' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
DELETE FROM refdata WHERE scheme = 'cancelcodes_amp' AND refdatavalue = '9203' AND description = 'asset recall not required' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
DELETE FROM refdata WHERE scheme = 'cancelcodes_amp' AND refdatavalue = '9204' AND description = 'duplicate request' AND status = 11 AND flag = 0 AND category = 0 AND substitutioncanceled = 1;
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
