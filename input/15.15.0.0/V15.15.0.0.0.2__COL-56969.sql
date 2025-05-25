DECLARE
v_sequenceDaily VARCHAR2(2000) := 'COLINTERESTCOUNTERPARTYDAILYDETAILS_SEQ';
v_sequenceDetails VARCHAR2(2000) := 'COLINTERESTCOUNTERPARTYDETAILS_SEQ';
v_result NUMBER(10);
max_id NUMBER;
max_id_details NUMBER;
BEGIN
BEGIN
-- Drop sequence if it exists
EXECUTE IMMEDIATE 'DROP SEQUENCE ' || v_sequenceDaily;
EXCEPTION
WHEN OTHERS THEN
NULL; -- Ignore if sequence doesn't exist
END;
BEGIN
-- Drop sequence if it exists
EXECUTE IMMEDIATE 'DROP SEQUENCE ' || v_sequenceDetails;
EXCEPTION
WHEN OTHERS THEN
NULL; -- Ignore if sequence doesn't exist
END;
-- Find the maximum ID for each table
SELECT COALESCE(MAX(id), 0) INTO max_id FROM ColInterestCounterpartyDailyDetails;
SELECT COALESCE(MAX(id), 0) INTO max_id_details FROM ColInterestCounterpartyDetails;
-- Create sequences starting with the next available ID
EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_sequenceDaily || ' increment by 50 cache 1000 start with ' || (max_id + 1) || ' maxvalue 999999999999999999999999999';
EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_sequenceDetails || ' increment by 50 cache 1000 start with ' || (max_id_details + 1) || ' maxvalue 999999999999999999999999999';
-- Update IDs in the tables using the sequences
EXECUTE IMMEDIATE 'UPDATE ColInterestCounterpartyDetails SET ID = ' || v_sequenceDetails || '.NEXTVAL WHERE ID NOT IN (SELECT ID FROM ColInterestCounterpartyDetails WHERE ROWNUM = 1)';
EXECUTE IMMEDIATE 'UPDATE ColInterestCounterpartyDailyDetails SET ID = ' || v_sequenceDaily || '.NEXTVAL WHERE ID NOT IN (SELECT ID FROM ColInterestCounterpartyDailyDetails WHERE ROWNUM = 1)';
-- Add primary key constraints if they don't exist
BEGIN
SELECT COUNT(*) INTO v_result FROM all_constraints WHERE table_name = 'ColInterestCounterpartyDetails' AND constraint_type = 'P';
IF v_result = 0 THEN
EXECUTE IMMEDIATE 'ALTER TABLE ColInterestCounterpartyDetails ADD CONSTRAINT pk_ColInterestCounterpartyDetails PRIMARY KEY (id)';
END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
BEGIN
SELECT COUNT(*) INTO v_result FROM all_constraints WHERE table_name = 'ColInterestCounterpartyDailyDetails' AND constraint_type = 'P';
IF v_result = 0 THEN
EXECUTE IMMEDIATE 'ALTER TABLE ColInterestCounterpartyDailyDetails ADD CONSTRAINT pk_ColInterestCounterpartyDailyDetails PRIMARY KEY (id)';
END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
END;