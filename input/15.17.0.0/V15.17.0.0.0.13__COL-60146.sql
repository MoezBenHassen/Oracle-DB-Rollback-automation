DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60146_Add_Inventory_Manager_Reset_Task';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'create table ColInventoryManagerReset (
                                                             id varchar2(50),
                                                             sourceSystem varchar2(50),
                                                             SODExpectedVmNotionalT NUMBER default 0,
                                                             SODExpectedImNotionalT NUMBER default 0,
                                                             SODExpectedDfNotionalT NUMBER default 0,
                                                             SODExpectedNotionalT NUMBER default 0,
                                                             SODExpectedNativeValueT NUMBER default 0,
                                                             SODExpectedBaseValueT NUMBER default 0,
                                                             SODExpectedReportingValueT NUMBER default 0,
                                                             SODExpectedReUseT NUMBER default 0,
                                                             SODConfirmedNotionalT NUMBER default 0,
                                                             SODConfirmedNativeValueT NUMBER default 0,
                                                             SODConfirmedBaseValueT NUMBER default 0,
                                                             SODConfirmedReportingValueT NUMBER default 0,
                                                             SODConfirmedReUseT NUMBER default 0,
                                                             intraDayExpectedVmNotionalT NUMBER  default -1,
                                                             intraDayExpectedImNotionalT NUMBER  default -1,
                                                             intraDayExpectedDfNotionalT NUMBER  default -1,
                                                             intraDayExpectedNotionalT NUMBER  default -1,
                                                             intraDayExpectedNativeValueT NUMBER  default -1,
                                                             intraDayExpectedBaseValueT NUMBER  default -1,
                                                             intraDayExpectedReportingValueT NUMBER  default -1,
                                                             intraDayExpectedReUseT NUMBER  default -1,
                                                             intraDayConfirmedNotionalT NUMBER  default -1,
                                                             intraDayConfirmedNativeValueT NUMBER  default -1,
                                                             intraDayConfirmedBaseValueT NUMBER  default -1,
                                                             intraDayConfirmedReportingValueT NUMBER  default -1,
                                                             intraDayConfirmedReUseT NUMBER default -1,
                                                             resetDate TIMESTAMP)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;