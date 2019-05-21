INSERT INTO EOR.REF_CATEGORY (REF_CATEGORY_UK, REF_CATEGORY_CODE, CAT_CODE_DESC, OPOL_IND, ADD_ALLOWED_IND, UPDATE_ALLOWED_IND, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER) VALUES (-206, 'USER_STATUS', 'User Status', 'N', 'N', 'N', 'A10231640D92D8CA5DB6268154F94B5D', TO_DATE('2012-10-15 17:19:04', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', TO_DATE('2012-10-15 17:31:50', 'YYYY-MM-DD HH24:MI:SS'), 'SYS');

INSERT INTO EOR.REF_ELEMENT (REF_ELEMENT_UK, REF_CATEGORY_CODE, REF_ELEMENT_CODE, REF_ELEMENT_CTID, REF_ELEMENT_SHORT_DESC, REF_ELEMENT_DESC, DISPLAY_SORT, START_DATE, END_DATE, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER) VALUES (-960, 'USER_STATUS', 'ACTIVE', '100', 'Active', 'Active', 10, TO_DATE('2010-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), null, 'C5B2C6FA7F1E5C5A4D4DE75BE1351547', TO_DATE('2012-10-15 17:19:08', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', TO_DATE('2012-10-15 17:31:50', 'YYYY-MM-DD HH24:MI:SS'), 'SYS');
INSERT INTO EOR.REF_ELEMENT (REF_ELEMENT_UK, REF_CATEGORY_CODE, REF_ELEMENT_CODE, REF_ELEMENT_CTID, REF_ELEMENT_SHORT_DESC, REF_ELEMENT_DESC, DISPLAY_SORT, START_DATE, END_DATE, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER) VALUES (-964, 'USER_STATUS', 'INACTIVE', '300', 'Inactive', 'Inactive', 30, TO_DATE('2010-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), null, '43583499D63BEEB50F7CF6093305D7CC', TO_DATE('2012-10-15 17:19:08', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', TO_DATE('2012-10-15 17:31:50', 'YYYY-MM-DD HH24:MI:SS'), 'SYS');
INSERT INTO EOR.REF_ELEMENT (REF_ELEMENT_UK, REF_CATEGORY_CODE, REF_ELEMENT_CODE, REF_ELEMENT_CTID, REF_ELEMENT_SHORT_DESC, REF_ELEMENT_DESC, DISPLAY_SORT, START_DATE, END_DATE, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER) VALUES (-962, 'USER_STATUS', 'LOCKED', '200', 'Locked', 'Locked', 20, TO_DATE('2010-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), null, 'EB7FF6507831BB1AD491D9EB6D9F545D', TO_DATE('2012-10-15 17:19:08', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', TO_DATE('2012-10-15 17:31:50', 'YYYY-MM-DD HH24:MI:SS'), 'SYS');

INSERT INTO EOR.OASYS_USER (OASYS_USER_UK, OASYS_USER_CODE, USER_FORENAME_1, USER_FORENAME_2, USER_FORENAME_3, USER_FAMILY_NAME, PASSWORD_ENCRYPTED, PASSWORD_CHANGE_DATE, LAST_LOGIN, FAILED_LOGIN_ATTEMPTS, SYSTEM_IND, USER_STATUS_ELM, USER_STATUS_CAT, DATE_OF_BIRTH, PASSWORD, EMAIL_ADDRESS, LEGACY_USER_CODE, MIGRATION_SOURCE_ELM, MIGRATION_SOURCE_CAT, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER, CT_AREA_EST_CODE, EXCL_DEACT_IND, DEACT_USER, DEACT_DATE, DEACT_REASON, LAST_RESET_DATE) VALUES (186077, 'ALICE', 'alice', null, null, 'aliston', 'E3C077F7914BB96C3265AB1ED56F009882190C4A', TO_DATE('2019-05-15 10:25:12', 'YYYY-MM-DD HH24:MI:SS'), null, 0, 'N', 'ACTIVE', 'USER_STATUS', null, null, 'alice.aliston@aa.com', null, null, null, 'EAB1C8D95CDAE53D6F28F4580FB8E4EB', TO_DATE('2019-05-16 10:09:41', 'YYYY-MM-DD HH24:MI:SS'), '?', TO_DATE('2019-05-16 10:25:13', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', null, 'N', null, null, null, null);
INSERT INTO EOR.OASYS_USER (OASYS_USER_UK, OASYS_USER_CODE, USER_FORENAME_1, USER_FORENAME_2, USER_FORENAME_3, USER_FAMILY_NAME, PASSWORD_ENCRYPTED, PASSWORD_CHANGE_DATE, LAST_LOGIN, FAILED_LOGIN_ATTEMPTS, SYSTEM_IND, USER_STATUS_ELM, USER_STATUS_CAT, DATE_OF_BIRTH, PASSWORD, EMAIL_ADDRESS, LEGACY_USER_CODE, MIGRATION_SOURCE_ELM, MIGRATION_SOURCE_CAT, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER, CT_AREA_EST_CODE, EXCL_DEACT_IND, DEACT_USER, DEACT_DATE, DEACT_REASON, LAST_RESET_DATE) VALUES (186078, 'BOB', 'Bob', null, null, 'bobson', 'E3C077F7914BB96C3265AB1ED56F009882190C4A', TO_DATE('2019-05-15 10:25:13', 'YYYY-MM-DD HH24:MI:SS'), null, 0, 'N', 'ACTIVE', 'USER_STATUS', null, null, 'bob.bobson@bb.com', null, null, null, '4C012F07806EE68A343E1DEF2392B3AE', TO_DATE('2019-05-16 10:11:32', 'YYYY-MM-DD HH24:MI:SS'), '?', TO_DATE('2019-05-16 10:25:13', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', null, 'N', null, null, null, null);
INSERT INTO EOR.OASYS_USER (OASYS_USER_UK, OASYS_USER_CODE, USER_FORENAME_1, USER_FORENAME_2, USER_FORENAME_3, USER_FAMILY_NAME, PASSWORD_ENCRYPTED, PASSWORD_CHANGE_DATE, LAST_LOGIN, FAILED_LOGIN_ATTEMPTS, SYSTEM_IND, USER_STATUS_ELM, USER_STATUS_CAT, DATE_OF_BIRTH, PASSWORD, EMAIL_ADDRESS, LEGACY_USER_CODE, MIGRATION_SOURCE_ELM, MIGRATION_SOURCE_CAT, CHECKSUM, CREATE_DATE, CREATE_USER, LASTUPD_DATE, LASTUPD_USER, CT_AREA_EST_CODE, EXCL_DEACT_IND, DEACT_USER, DEACT_DATE, DEACT_REASON, LAST_RESET_DATE) VALUES (186081, 'CHARLIE', 'Charlie', null, null, 'charleston', 'E3C077F7914BB96C3265AB1ED56F009882190C4A', TO_DATE('2019-05-15 10:25:13', 'YYYY-MM-DD HH24:MI:SS'), null, 0, 'N', 'ACTIVE', 'USER_STATUS', null, null, 'charlie.charleston@cc.com', null, null, null, '246E88D87A6707F081863AB832699C3C', TO_DATE('2019-05-16 10:15:09', 'YYYY-MM-DD HH24:MI:SS'), '?', TO_DATE('2019-05-16 10:25:13', 'YYYY-MM-DD HH24:MI:SS'), 'SYS', null, 'N', null, null, null, null);
