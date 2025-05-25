DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64772_All_the_bookings_on_the_rehypo_agreement_are_tagged_as_rehypothecated';
BEGIN
    SELECT count(1) INTO results FROM lrsschemaproperties l
    WHERE l.modulename = v_module
      AND l.propertyname = v_property;

    IF results > 0
        THEN
            RETURN;
    END IF;


    EXECUTE IMMEDIATE '
    CREATE TABLE colSecurityParamountRehypothecated (
                        securityParamountDeliveryId NUMBER(19,0),
                        securityParamounCallId NUMBER(19,0),
                        rehypoToDeliveryAmount FLOAT,
                        recalledAmount FLOAT,
                        CONSTRAINT fk_col_securityparamount_delivery FOREIGN KEY (securityParamountDeliveryId) REFERENCES colsecurityparamount(id),
                        CONSTRAINT fk_col_securityparamount_call FOREIGN KEY (securityParamounCallId) REFERENCES colsecurityparamount(id),
                        CONSTRAINT pk_col_securityparamount PRIMARY KEY (securityParamountDeliveryId, securityParamounCallId)
    )';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_col_securityparamount_delivery ON colSecurityParamountRehypothecated (securityParamountDeliveryId)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_col_securityparamount_call ON colSecurityParamountRehypothecated (securityParamounCallId)';


    INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
    COMMIT;
END;
