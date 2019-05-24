CREATE SCHEMA IF NOT EXISTS "EOR";

create table EOR.REF_CATEGORY
(
    REF_CATEGORY_UK    NUMBER                  not null
        constraint REF_CATEGORY_UN
            unique,
    REF_CATEGORY_CODE  VARCHAR2(50)            not null
        constraint REF_CATEGORY_PK
            primary key,
    CAT_CODE_DESC      VARCHAR2(4000),
    OPOL_IND           VARCHAR2(1) default 'N' not null,
    ADD_ALLOWED_IND    VARCHAR2(1) default 'N' not null,
    UPDATE_ALLOWED_IND VARCHAR2(1) default 'N' not null,
    CHECKSUM           VARCHAR2(4000),
    CREATE_DATE        DATE,
    CREATE_USER        VARCHAR2(100)           not null,
    LASTUPD_DATE       DATE,
    LASTUPD_USER       VARCHAR2(100)           not null
);

create table EOR.REF_ELEMENT
(
    REF_ELEMENT_UK         NUMBER        not null
        constraint REF_ELEMENT_UN
            unique,
    REF_CATEGORY_CODE      VARCHAR2(50)  not null
        constraint RCT_REL
            references EOR.REF_CATEGORY,
    REF_ELEMENT_CODE       VARCHAR2(50)  not null,
    REF_ELEMENT_CTID       VARCHAR2(50),
    REF_ELEMENT_SHORT_DESC VARCHAR2(60),
    REF_ELEMENT_DESC       VARCHAR2(4000),
    DISPLAY_SORT           NUMBER,
    START_DATE             DATE          not null,
    END_DATE               DATE,
    CHECKSUM               VARCHAR2(4000),
    CREATE_DATE            DATE,
    CREATE_USER            VARCHAR2(100) not null,
    LASTUPD_DATE           DATE,
    LASTUPD_USER           VARCHAR2(100) not null,
    constraint REF_ELEMENT_PK
        primary key (REF_CATEGORY_CODE, REF_ELEMENT_CODE)
);

create table EOR.DIVISION
(
    DIVISION_UK      NUMBER        not null
        constraint DIVISION_UN
            unique,
    CT_AREA_EST_CODE VARCHAR2(100) not null,
    DIVISION_CODE    VARCHAR2(100) not null,
    DIVISION_NAME    VARCHAR2(100),
    START_DATE       DATE          not null,
    END_DATE         DATE,
    CHECKSUM         VARCHAR2(4000),
    CREATE_DATE      DATE,
    CREATE_USER      VARCHAR2(100) not null,
    LASTUPD_DATE     DATE,
    LASTUPD_USER     VARCHAR2(100) not null,
    constraint DIVISION_PK
        primary key (CT_AREA_EST_CODE, DIVISION_CODE)
);

create table EOR.TEAM
(
    TEAM_UK          NUMBER        not null
        constraint TEAM_UN
            unique,
    CT_AREA_EST_CODE VARCHAR2(100) not null,
    DIVISION_CODE    VARCHAR2(100) not null,
    TEAM_CODE        VARCHAR2(100) not null,
    TEAM_NAME        VARCHAR2(100),
    CONTACT_NUMBER   VARCHAR2(32),
    EMAIL_ADDRESS    VARCHAR2(100),
    START_DATE       DATE          not null,
    END_DATE         DATE,
    CHECKSUM         VARCHAR2(4000),
    CREATE_DATE      DATE,
    CREATE_USER      VARCHAR2(100) not null,
    LASTUPD_DATE     DATE,
    LASTUPD_USER     VARCHAR2(100) not null,
    constraint TEAM_PK
        primary key (DIVISION_CODE, TEAM_CODE, CT_AREA_EST_CODE),
    constraint DIV_TEA
        foreign key (CT_AREA_EST_CODE, DIVISION_CODE) references EOR.DIVISION
);

create table EOR.OASYS_USER
(
    OASYS_USER_UK         NUMBER                             not null
        constraint OASYS_USER_UN
            unique,
    OASYS_USER_CODE       VARCHAR2(100)                      not null
        constraint OASYS_USER_PK
            primary key,
    USER_FORENAME_1       VARCHAR2(100),
    USER_FORENAME_2       VARCHAR2(100),
    USER_FORENAME_3       VARCHAR2(100),
    USER_FAMILY_NAME      VARCHAR2(100),
    PASSWORD_ENCRYPTED    RAW(256),
    PASSWORD_CHANGE_DATE  DATE,
    LAST_LOGIN            DATE,
    FAILED_LOGIN_ATTEMPTS NUMBER,
    SYSTEM_IND            VARCHAR2(1)  default 'N'           not null,
    USER_STATUS_ELM       VARCHAR2(50) default 'ACTIVE'      not null,
    USER_STATUS_CAT       VARCHAR2(50) default 'USER_STATUS' not null,
    DATE_OF_BIRTH         DATE,
    PASSWORD              VARCHAR2(30),
    EMAIL_ADDRESS         VARCHAR2(100),
    LEGACY_USER_CODE      VARCHAR2(100),
    MIGRATION_SOURCE_ELM  VARCHAR2(50),
    MIGRATION_SOURCE_CAT  VARCHAR2(50),
    CHECKSUM              VARCHAR2(4000),
    CREATE_DATE           DATE,
    CREATE_USER           VARCHAR2(100)                      not null,
    LASTUPD_DATE          DATE,
    LASTUPD_USER          VARCHAR2(100)                      not null,
    CT_AREA_EST_CODE      VARCHAR2(100),
    EXCL_DEACT_IND        VARCHAR2(1)  default 'N'           not null,
    DEACT_USER            VARCHAR2(100),
    DEACT_DATE            DATE,
    DEACT_REASON          VARCHAR2(50),
    LAST_RESET_DATE       DATE,
    constraint ELM_FK89
        foreign key (MIGRATION_SOURCE_CAT, MIGRATION_SOURCE_ELM) references EOR.REF_ELEMENT,
    constraint ELM_FK90
        foreign key (USER_STATUS_CAT, USER_STATUS_ELM) references EOR.REF_ELEMENT
);

create table EOR.USER_AREA
(
    USER_AREA_UK               NUMBER        not null
        constraint USER_AREA_UN2
            unique,
    CT_AREA_EST_CODE           VARCHAR2(100) not null,
    OASYS_USER_CODE            VARCHAR2(100) not null
        constraint OUS_UAR
            references EOR.OASYS_USER,
    START_DATE                 DATE          not null,
    END_DATE                   DATE,
    PHONE_NUMBER               VARCHAR2(32),
    EMAIL_ADDRESS              VARCHAR2(100),
    DEFAULT_TEAM_AREA_EST_CODE VARCHAR2(100),
    DIVISION_CODE              VARCHAR2(100),
    TEAM_CODE                  VARCHAR2(100),
    DEF_CNTRSGN_USER           VARCHAR2(100),
    DEF_CNTRSIGN_USER_AREA     VARCHAR2(100),
    USER_POSITION              VARCHAR2(100),
    HIERARCHY_LEVEL_ELM        VARCHAR2(50),
    HIERARCHY_LEVEL_CAT        VARCHAR2(50),
    OFFICE_AREA_EST_CODE       VARCHAR2(100),
    OFFICE_CODE                VARCHAR2(100),
    DELIUS_NOTES_ID            VARCHAR2(100),
    CHECKSUM                   VARCHAR2(4000),
    CREATE_DATE                DATE,
    CREATE_USER                VARCHAR2(100) not null,
    LASTUPD_DATE               DATE,
    LASTUPD_USER               VARCHAR2(100) not null,
    LAST_LOGIN_DATE            DATE,
    DEACT_USER                 VARCHAR2(100),
    DEACT_DATE                 DATE,
    DEACT_REASON               VARCHAR2(50),
    LAST_RESET_DATE            DATE,
    constraint USER_AREA_PK
        primary key (OASYS_USER_CODE, CT_AREA_EST_CODE),
    constraint USER_AREA_UN
        unique (CT_AREA_EST_CODE, OASYS_USER_CODE),
    constraint ELM_FK30
        foreign key (HIERARCHY_LEVEL_CAT, HIERARCHY_LEVEL_ELM) references EOR.REF_ELEMENT,
    constraint TEA_UAR
        foreign key (DIVISION_CODE, TEAM_CODE, DEFAULT_TEAM_AREA_EST_CODE) references EOR.TEAM,
    constraint UAR_UAR
        foreign key (DEF_CNTRSGN_USER, DEF_CNTRSIGN_USER_AREA) references EOR.USER_AREA
);

create table EOR.CT_AREA_EST
(
    CT_AREA_EST_UK             NUMBER                  not null
        constraint CT_AREA_EST_UN
            unique,
    CT_AREA_EST_CODE           VARCHAR2(100)           not null
        constraint CT_AREA_EST_PK
            primary key,
    AREA_EST_CTID              VARCHAR2(50),
    AREA_EST_NAME              VARCHAR2(100),
    START_DATE                 DATE                    not null,
    END_DATE                   DATE,
    CASE_MAN_SYSTEM_ELM        VARCHAR2(50),
    CASE_MAN_SYSTEM_CAT        VARCHAR2(50),
    SERVICE_ELM                VARCHAR2(50),
    SERVICE_CAT                VARCHAR2(50),
    LAO_CONTACT_NUMBER         VARCHAR2(100),
    SHOW_SDR_OBJ_IND           VARCHAR2(1) default 'N' not null,
    SHOW_SDR_HINTS_IND         VARCHAR2(1) default 'N' not null,
    SHOW_CRIM_GRAPH_IND        VARCHAR2(1) default 'N' not null,
    SHOW_SDR_EVIDENCE_ELM      VARCHAR2(50),
    SHOW_SDR_EVIDENCE_CAT      VARCHAR2(50),
    SDR_CONCERN_NONE_IND       VARCHAR2(1) default 'N' not null,
    SDR_CONCERN_SUICIDE_IND    VARCHAR2(1) default 'N' not null,
    SDR_CONCERN_SELFHARM_IND   VARCHAR2(1) default 'N' not null,
    SDR_CONCERN_CUSTODY_IND    VARCHAR2(1) default 'N' not null,
    SDR_CONCERN_HOSTEL_IND     VARCHAR2(1) default 'N' not null,
    SDR_CONCERN_VULNERABLE_IND VARCHAR2(1) default 'N' not null,
    DEF_TEAM_DIVISION_CODE     VARCHAR2(100),
    USER_MAIN_CONTACT          VARCHAR2(100),
    DEF_TEAM_CODE              VARCHAR2(100),
    DATA_EXPORT_PATH           VARCHAR2(1024),
    OASYS_USER_CODE            VARCHAR2(100),
    NOMIS_CODE                 VARCHAR2(6),
    CHECKSUM                   VARCHAR2(4000),
    CREATE_DATE                DATE,
    CREATE_USER                VARCHAR2(100)           not null,
    LASTUPD_DATE               DATE,
    LASTUPD_USER               VARCHAR2(100)           not null,
    PSR_LOGO_FILENAME          VARCHAR2(4000),
    AREA_EST_TYPE_CAT          VARCHAR2(50),
    AREA_EST_TYPE_ELM          VARCHAR2(50),
    RUN_QA_SAMPLE_IND          VARCHAR2(1)
        check ( run_qa_sample_ind IN ('N', 'Y')),
    BCS_ON_RECEPTION_IND       VARCHAR2(1)
        check ( bcs_on_reception_ind IN ('N', 'Y')),
    constraint ELM_FK43
        foreign key (CASE_MAN_SYSTEM_CAT, CASE_MAN_SYSTEM_ELM) references EOR.REF_ELEMENT,
    constraint ELM_FK44
        foreign key (SERVICE_CAT, SERVICE_ELM) references EOR.REF_ELEMENT,
    constraint ELM_FK45
        foreign key (SHOW_SDR_EVIDENCE_CAT, SHOW_SDR_EVIDENCE_ELM) references EOR.REF_ELEMENT,
    constraint ELM_FKX50
        foreign key (AREA_EST_TYPE_CAT, AREA_EST_TYPE_ELM) references EOR.REF_ELEMENT,
    constraint TEA_CAE
        foreign key (DEF_TEAM_DIVISION_CODE, DEF_TEAM_CODE, CT_AREA_EST_CODE) references EOR.TEAM,
    constraint UAR_CAE
        foreign key (OASYS_USER_CODE, USER_MAIN_CONTACT) references EOR.USER_AREA
);

ALTER TABLE EOR.USER_AREA
    ADD FOREIGN KEY (CT_AREA_EST_CODE)
        REFERENCES CT_AREA_EST (CT_AREA_EST_CODE);

ALTER TABLE EOR.OASYS_USER
    ADD FOREIGN KEY (CT_AREA_EST_CODE)
        REFERENCES CT_AREA_EST (CT_AREA_EST_CODE);

create table EOR.OFFICE
(
    OFFICE_UK         NUMBER        not null
        constraint OFFICE_UN
            unique,
    OFFICE_CODE       VARCHAR2(100) not null,
    CT_AREA_EST_CODE  VARCHAR2(100) not null
        constraint CAE_OFC
            references EOR.CT_AREA_EST,
    OFFICE_NAME       VARCHAR2(100),
    START_DATE        DATE          not null,
    END_DATE          DATE,
    ADDRESS_LINE_1    VARCHAR2(256),
    ADDRESS_LINE_2    VARCHAR2(256),
    ADDRESS_LINE_3    VARCHAR2(256),
    ADDRESS_LINE_4    VARCHAR2(256),
    ADDRESS_LINE_5    VARCHAR2(256),
    ADDRESS_LINE_6    VARCHAR2(256),
    POSTCODE          VARCHAR2(32),
    CONTACT_NUMBER    VARCHAR2(32),
    OFFICE_FAX_NUMBER VARCHAR2(20),
    CHECKSUM          VARCHAR2(4000),
    CREATE_DATE       DATE,
    CREATE_USER       VARCHAR2(100) not null,
    LASTUPD_DATE      DATE,
    LASTUPD_USER      VARCHAR2(100) not null,
    constraint OFFICE_PK
        primary key (CT_AREA_EST_CODE, OFFICE_CODE)
);

ALTER TABLE EOR.USER_AREA
    ADD FOREIGN KEY (OFFICE_AREA_EST_CODE, OFFICE_CODE)
        REFERENCES OFFICE (CT_AREA_EST_CODE, OFFICE_CODE);

create table EOR.REF_ROLE
(
    REF_ROLE_UK      NUMBER                  not null
        constraint REF_ROLE_UN
            unique,
    REF_ROLE_CODE    VARCHAR2(100)           not null
        constraint REF_ROLE_PK
            primary key,
    REF_ROLE_DESC    VARCHAR2(100),
    ROLE_TYPE_ELM    VARCHAR2(50)            not null,
    ROLE_TYPE_CAT    VARCHAR2(100)           not null,
    CT_AREA_EST_CODE VARCHAR2(100)
        constraint CAE_RRO
            references EOR.CT_AREA_EST,
    RESTRICTED_IND   VARCHAR2(1) default 'N' not null,
    CHECKSUM         VARCHAR2(4000),
    CREATE_DATE      DATE,
    CREATE_USER      VARCHAR2(100)           not null,
    LASTUPD_DATE     DATE,
    LASTUPD_USER     VARCHAR2(100)           not null,
    constraint ELM_FK127
        foreign key (ROLE_TYPE_CAT, ROLE_TYPE_ELM) references EOR.REF_ELEMENT
);

create table EOR.AREA_EST_USER_ROLE
(
    AREA_EST_USER_ROLE_UK NUMBER        not null
        constraint AREA_EST_USER_ROLE_UN
            unique,
    OASYS_USER_CODE       VARCHAR2(100) not null
        constraint OUS_AUR
            references EOR.OASYS_USER,
    REF_ROLE_CODE         VARCHAR2(100) not null
        constraint RRO_AUR
            references EOR.REF_ROLE,
    CT_AREA_EST_CODE      VARCHAR2(100) not null
        constraint CAE_AUR
            references EOR.CT_AREA_EST,
    START_DATE            DATE          not null,
    END_DATE              DATE,
    CHECKSUM              VARCHAR2(4000),
    CREATE_DATE           DATE,
    CREATE_USER           VARCHAR2(100) not null,
    LASTUPD_DATE          DATE,
    LASTUPD_USER          VARCHAR2(100) not null,
    constraint OASYS_USER_ROLE_PK
        primary key (OASYS_USER_CODE, REF_ROLE_CODE, CT_AREA_EST_CODE)
);