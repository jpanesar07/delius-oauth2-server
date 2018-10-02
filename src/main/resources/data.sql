CREATE USER IF NOT EXISTS ITAG_USER password 'password';
CREATE USER IF NOT EXISTS OLD_NOMIS_USER password 'password';
CREATE USER IF NOT EXISTS ITAG_USER_ADM password 'password123456';
CREATE USER IF NOT EXISTS CA_USER password 'password123456';
CREATE USER IF NOT EXISTS RO_USER password 'password123456';
CREATE USER IF NOT EXISTS DM_USER password 'password123456';
CREATE USER IF NOT EXISTS NOMIS_BATCHLOAD password 'password123456';
CREATE USER IF NOT EXISTS LOCKED_USER password 'password123456';
CREATE USER IF NOT EXISTS EXPIRED_USER password 'password123456';

INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME, STATUS) VALUES (1, 'ITAG', 'USER', 'ACTIVE');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (2, 'OLD', 'NOMIS USER');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (3, 'Licence', 'Case Admin');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (4, 'Licence', 'Responsible Officer');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (5, 'Licence', 'Decision Maker');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (6, 'Licence', 'Batchloader');
INSERT INTO  STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME) VALUES (7, 'Expire', 'Locked');

INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('ITAG_USER', 'GENERAL', 1);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('ITAG_USER_ADM', 'ADMIN', 1);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('OLD_NOMIS_USER', 'GENERAL', 2);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('CA_USER', 'GENERAL', 3);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('RO_USER', 'GENERAL', 4);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('DM_USER', 'GENERAL', 5);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('NOMIS_BATCHLOAD', 'GENERAL', 6);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('LOCKED_USER', 'GENERAL', 7);
INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id) VALUES ('EXPIRED_USER', 'GENERAL', 7);

INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('ITAG_USER', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('ITAG_USER_ADM', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'Admin');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('OLD_NOMIS_USER', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('CA_USER', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('RO_USER', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('DM_USER', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('NOMIS_BATCHLOAD', 'OPEN', null, now()+10000, now(), 'TAG_GENERAL', 'N', 'N', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('LOCKED_USER', 'LOCKED', now(), now()+10000, now(), 'TAG_GENERAL', 'N', 'Y', 'N', 'General');
INSERT INTO V_TAG_DBA_USERS (username, account_status, lock_Date, expiry_date, created, profile, logged_in, locked_flag, expired_flag, user_type_description)
VALUES ('EXPIRED_USER', 'EXPIRED', null, now(), now(), 'TAG_GENERAL', 'N', 'N', 'Y', 'General');


INSERT INTO PERSONNEL_IDENTIFICATIONS (STAFF_ID, IDENTIFICATION_TYPE, IDENTIFICATION_NUMBER) VALUES (1, 'YJAF', 'test@yjaf.gov.uk');
INSERT INTO PERSONNEL_IDENTIFICATIONS (STAFF_ID, IDENTIFICATION_TYPE, IDENTIFICATION_NUMBER) VALUES (2, 'YJAF', 'olduser@yjaf.gov.uk');

INSERT INTO CASELOADS (CASELOAD_ID, DESCRIPTION, CASELOAD_TYPE) VALUES ('NWEB', 'Magic API Caseload', 'APP');
INSERT INTO CASELOADS (CASELOAD_ID, DESCRIPTION, CASELOAD_TYPE) VALUES ('MDI', 'Moorlands', 'INST');
INSERT INTO CASELOADS (CASELOAD_ID, DESCRIPTION, CASELOAD_TYPE) VALUES ('CADM', 'Central Admin', 'ADMIN');

INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'ITAG_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('MDI', 'ITAG_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('MDI', 'OLD_NOMIS_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('CADM', 'ITAG_USER_ADM', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'CA_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'RO_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'DM_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'NOMIS_BATCHLOAD', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'LOCKED_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'EXPIRED_USER', now());
INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'ITAG_USER_ADM', now());


INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (1, 'OMIC_ADMIN', 'Omic Administrator', 1, 'APP', 'GENERAL');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (-1, '900', 'Some Old Role', 99, 'INST', 'GENERAL');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (3, 'CENTRAL_ADMIN', 'All Powerful Admin', 1, 'INST', 'ADMIN');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (4, 'KW_MIGRATION', 'KW Migration', 1, 'APP', 'ADMIN');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (5, 'NOMIS_BATCHLOAD', 'Nomis BatchLoad', 1, 'APP', 'ADMIN');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (6, 'MAINTAIN_ACCESS_ROLES', 'Maintain Access Roles', 1, 'APP', 'ADMIN');

INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (11, 'LICENCE_CA', 'Licence Case Admin', 1, 'APP', 'GENERAL');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (12, 'LICENCE_RO', 'Licence Responsible Officer', 2, 'APP', 'GENERAL');
INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (13, 'LICENCE_DM', 'Licence Decision Maker', 3, 'APP', 'GENERAL');

INSERT INTO OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_SEQ, ROLE_TYPE, ROLE_FUNCTION) VALUES (14, 'OAUTH_ADMIN', 'Oauth Admin', 99, 'APP', 'ADMIN');

INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (-1, 'MDI', 'ITAG_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (-1, 'MDI', 'OLD_NOMIS_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (1, 'NWEB', 'ITAG_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (4, 'NWEB', 'ITAG_USER_ADM');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (5, 'NWEB', 'NOMIS_BATCHLOAD');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (6, 'NWEB', 'ITAG_USER_ADM');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (3, 'CADM', 'ITAG_USER_ADM');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (11, 'NWEB', 'CA_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (12, 'NWEB', 'RO_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (13, 'NWEB', 'DM_USER');
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES (14, 'NWEB', 'ITAG_USER_ADM');

create table oauth_client_token (
  token_id          VARCHAR2(255),
  token             BLOB,
  authentication_id varchar2(255),
  user_name         varchar2(255),
  client_id         varchar2(255)
);

CREATE TABLE oauth_client_details (
  client_id               varchar2(255) NOT NULL,
  resource_ids            varchar2(255) DEFAULT NULL,
  client_secret           varchar2(255) DEFAULT NULL,
  scope                   varchar2(255) DEFAULT NULL,
  authorized_grant_types  varchar2(255) DEFAULT NULL,
  web_server_redirect_uri varchar2(255) DEFAULT NULL,
  authorities             varchar2(255) DEFAULT NULL,
  access_token_validity   NUMBER(11, 0) DEFAULT NULL,
  refresh_token_validity  NUMBER(11, 0) DEFAULT NULL,
  additional_information  varchar2(255) DEFAULT NULL,
  autoapprove             varchar2(255) DEFAULT NULL
);

create table oauth_access_token (
  token_id          varchar2(255),
  token             BLOB,
  authentication_id varchar2(255),
  user_name         varchar2(255),
  client_id         varchar2(255),
  authentication    BLOB,
  refresh_token     varchar2(255)
);

create table oauth_refresh_token (
  token_id       varchar2(255),
  token          BLOB,
  authentication BLOB
);





