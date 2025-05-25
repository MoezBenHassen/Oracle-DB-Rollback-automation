-- ð Rollback of V15.14.0.0.0.7__COL-52829.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   and l.propertyname = 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences';
DELETE FROM preferences WHERE parent = 7 AND preftype = '(global)' AND name = 'MTA BUSINESS LINES CONFIG' AND prefvalue = '41,22' AND prefclass IS NULL;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences';
