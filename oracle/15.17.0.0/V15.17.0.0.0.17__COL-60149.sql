DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'reports';
    v_property VARCHAR2(100) := 'COL-60149_Inventory_Manager_Report';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutFirmPosition ADD (
                                            confirmedNotionalT NUMBER,
                                            confirmedNativeValueT NUMBER,
                                            confirmedReUseT NUMBER,
                                            confirmedReportingValueT NUMBER,
                                            confirmedPositionT VARCHAR2(50),
                                            EODConfirmedNotionalT NUMBER,
                                            EODConfirmedReUseT NUMBER,
                                            EODConfirmedNativeValueT NUMBER,
                                            EODConfirmedReportingValueT NUMBER,
                                            EODExpectedNotionalT NUMBER,
                                            EODExpectedReUseT NUMBER,
                                            EODExpectedNativeValueT NUMBER,
                                            EODExpectedReportingValueT NUMBER,
                                            SODConfirmedNotionalT NUMBER,
                                            SODConfirmedReUseT NUMBER,
                                            SODConfirmedNativeValueT NUMBER,
                                            SODConfirmedReportingValueT NUMBER,
                                            SODExpectedNotionalT NUMBER,
                                            SODExpectedNativeValueT NUMBER,
                                            SODExpectedReUseT NUMBER,
                                            SODExpectedReportingValueT NUMBER,
                                            intraDayConfirmedNotionalT NUMBER,
                                            intraDayConfirmedReUseT NUMBER,
                                            intraDayConfirmedNativeValueT NUMBER,
                                            intraDayConfirmedReportingValueT NUMBER,
                                            intraDayExpectedNotionalT NUMBER,
                                            intraDayExpectedReUseT NUMBER,
                                            intraDayExpectedNativeValueT NUMBER,
                                            intraDayExpectedReportingValueT NUMBER,
                                            pendingNotionalT NUMBER,
                                            pendingNativeValueT NUMBER,
                                            pendingReUseT NUMBER,
                                            pendingReportingValueT NUMBER,
                                            isSettled NUMBER)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
