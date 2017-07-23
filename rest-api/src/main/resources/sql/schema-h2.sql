-- ----------------------------
-- TABLE STRUCTURE FOR USER
-- ----------------------------
DROP TABLE IF EXISTS "USER";
CREATE TABLE "USER" (
  "USER_NAME" VARCHAR(255) NOT NULL,
  "PASSWORD" VARCHAR(500) NOT NULL,
  "PASSWORD_SALT" VARCHAR(255) DEFAULT NULL,
  "STATUS" TINYINT(4) NOT NULL,
  "E_MAIL" VARCHAR(255) DEFAULT NULL,
  "LAST_ACCESS_DTT" DATETIME DEFAULT NULL,
  "CREDENTIALS_EXPIRE_DTT" DATETIME DEFAULT NULL,
  "ACCOUNT_EXPIRE_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("USER_NAME")
);

-- ----------------------------
-- TABLE STRUCTURE FOR ROLE
-- ----------------------------
DROP TABLE IF EXISTS "ROLE";
CREATE TABLE "ROLE" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  PRIMARY KEY ("ID")
);

-- ----------------------------
-- TABLE STRUCTURE FOR USER_IN_ROLE
-- ----------------------------
DROP TABLE IF EXISTS "USER_IN_ROLE";
CREATE TABLE "USER_IN_ROLE" (
  "USER_NAME" VARCHAR(255) NOT NULL,
  "ROLE_ID" VARCHAR(40) NOT NULL,
  KEY "USERS_IN_ROLES_USER_NAME" ("USER_NAME"),
  KEY "USERS_IN_ROLES_ROLE_ID" ("ROLE_ID"),
  CONSTRAINT "USER_IN_ROLE_IBFK_1" FOREIGN KEY ("ROLE_ID") REFERENCES "ROLE" ("ID") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "USER_IN_ROLE_IBFK_2" FOREIGN KEY ("USER_NAME") REFERENCES "USER" ("USER_NAME") ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR CONTACT
-- ----------------------------
DROP TABLE IF EXISTS "CONTACT";
CREATE TABLE "CONTACT" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(255) DEFAULT NULL,
  "PHONE" VARCHAR(20) DEFAULT NULL,
  "HOME_PHONE" VARCHAR(20) DEFAULT NULL,
  "E_MAIL" VARCHAR(255) DEFAULT NULL,
  "ADDRESS_LINE_1" VARCHAR(255) DEFAULT NULL,
  "ADDRESS_LINE_2" VARCHAR(255) DEFAULT NULL,
  "APARTMENT" VARCHAR(255) DEFAULT NULL,
  "STREET" VARCHAR(255) DEFAULT NULL,
  "CITY" VARCHAR(255) DEFAULT NULL,
  "STATE" VARCHAR(50) DEFAULT NULL,
  "COUNTRY" VARCHAR(255) DEFAULT NULL,
  "ZIP" INT(10) DEFAULT NULL,
  "NOTES" VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY ("ID")
);

-- ----------------------------
-- TABLE STRUCTURE FOR PERSON
-- ----------------------------
DROP TABLE IF EXISTS "PERSON";
CREATE TABLE "PERSON" (
  "ID" VARCHAR(40) NOT NULL,
  "USER_NAME" VARCHAR(255) DEFAULT NULL,
  "F_NAME" VARCHAR(255) DEFAULT NULL,
  "M_NAME" VARCHAR(255) DEFAULT NULL,
  "L_NAME" VARCHAR(255) DEFAULT NULL,
  "PREFIX" VARCHAR(255) DEFAULT NULL,
  "SUFFIX" VARCHAR(255) DEFAULT NULL,
  "DOB" DATETIME DEFAULT NULL,
  "HEIGHT" FLOAT DEFAULT NULL,
  "WEIGHT" FLOAT DEFAULT NULL,
  "RACE" VARCHAR(100) DEFAULT NULL,
  "EYE_COLOR" TINYINT(1) DEFAULT NULL,
  "HAIR_COLOR" TINYINT(1) DEFAULT NULL,
  "GENDER" TINYINT(4) DEFAULT NULL,
  "PICTURE_URI" VARCHAR(1000) DEFAULT NULL,
  "SSN" INT(9) DEFAULT NULL,
  "JOINING_DTT" DATETIME DEFAULT NULL,
  "CONTACT" VARCHAR(40) DEFAULT NULL,
  "EMR_CONTACT" VARCHAR(40) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "USER_NAME_FK" ("USER_NAME"),
  KEY "CONTACT_FK" ("CONTACT"),
  KEY "EMR_CONTACT_FK" ("EMR_CONTACT"),
  CONSTRAINT "PERSON_IBFK_1" FOREIGN KEY ("USER_NAME") REFERENCES "USER" ("USER_NAME") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "PERSON_IBFK_2" FOREIGN KEY ("CONTACT") REFERENCES "CONTACT" ("ID") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "PERSON_IBFK_3" FOREIGN KEY ("EMR_CONTACT") REFERENCES "CONTACT" ("ID") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ----------------------------
-- TABLE STRUCTURE FOR STAFF
-- ----------------------------
DROP TABLE IF EXISTS "STAFF";
CREATE TABLE "STAFF" (
  "ID" VARCHAR(40) NOT NULL,
  "ALT_ID" VARCHAR(40) NOT NULL,
  "DESIGNATION" VARCHAR(255) DEFAULT NULL,
  "DESC" VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY ("ID"),
  CONSTRAINT "STAFF_IBFK_1" FOREIGN KEY ("ID") REFERENCES "PERSON" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR STUDENT
-- ----------------------------
DROP TABLE IF EXISTS "STUDENT";
CREATE TABLE "STUDENT" (
  "ID" VARCHAR(40) NOT NULL,
  "ROLL_NUMBER" VARCHAR(40) NOT NULL,
  "PARENT_EMAIL" VARCHAR(255) DEFAULT NULL,
  "LEVEL" VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY ("ID"),
  CONSTRAINT "STUDENT_IBFK_1" FOREIGN KEY ("ID") REFERENCES "PERSON" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR COURSE
-- ----------------------------
DROP TABLE IF EXISTS "COURSE";
CREATE TABLE "COURSE" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(255) DEFAULT NULL,
  "DEPT" VARCHAR(255) DEFAULT NULL,
  "DESC" VARCHAR(255) DEFAULT NULL,
  "CREDITS" TINYINT(1) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID")
);

-- ----------------------------
-- TABLE STRUCTURE FOR COURSE_SCHEDULE
-- ----------------------------
DROP TABLE IF EXISTS "COURSE_SCHEDULE";
CREATE TABLE "COURSE_SCHEDULE" (
  "ID" VARCHAR(40) NOT NULL,
  "COURSE_ID" VARCHAR(40) DEFAULT NULL,
  "INSTRUCTOR_ID" VARCHAR(40) DEFAULT NULL,
  "NAME" VARCHAR(256) DEFAULT NULL,
  "STATUS" TINYINT(1) DEFAULT NULL,
  "TERM" VARCHAR(25) DEFAULT NULL,
  "START_DT" DATE DEFAULT NULL,
  "END_DT" DATE DEFAULT NULL,
  "START_T" TIME DEFAULT NULL,
  "END_T" TIME DEFAULT NULL,
  "LOCATION" VARCHAR(100) DEFAULT NULL,
  "DESC" VARCHAR(1000) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "COURSE_FK" ("COURSE_ID"),
  KEY "INSTRUCTOR_ID_FK" ("INSTRUCTOR_ID"),
  CONSTRAINT "COURSE_SCHEDULE_IBFK_2" FOREIGN KEY ("INSTRUCTOR_ID") REFERENCES "STAFF" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT "COURSE_SCHEDULE_IBFK_1" FOREIGN KEY ("COURSE_ID") REFERENCES "COURSE" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);


-- ----------------------------
-- TABLE STRUCTURE FOR STUDENT_COURSE_ENROLLMENT
-- ----------------------------
DROP TABLE IF EXISTS "STUDENT_COURSE_ENROLLMENT";
CREATE TABLE "STUDENT_COURSE_ENROLLMENT" (
  "ID" VARCHAR(40) NOT NULL,
  "COURSE_SCHEDULE_ID" VARCHAR(40) DEFAULT NULL,
  "STUDENT_ID" VARCHAR(40) DEFAULT NULL,
  "ENROLLED_DTT" DATETIME DEFAULT NULL,
  "STATUS" TINYINT(1) DEFAULT NULL,
  "GRADE" VARCHAR(10) DEFAULT NULL,
  "GRADED_DTT" DATETIME DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "COURSE_SCHEDULE_ID_FK" ("COURSE_SCHEDULE_ID"),
  KEY "STUDENT_ID_FK_2" ("STUDENT_ID"),
  CONSTRAINT "STUDENT_COURSE_ENROLLMENT_IBFK_3" FOREIGN KEY ("STUDENT_ID") REFERENCES "STUDENT" ("ID") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "STUDENT_COURSE_ENROLLMENT_IBFK_2" FOREIGN KEY ("COURSE_SCHEDULE_ID") REFERENCES "COURSE_SCHEDULE" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR ATTENDANCE_BY
-- ----------------------------
DROP TABLE IF EXISTS "ATTENDANCE_BY";
CREATE TABLE "ATTENDANCE_BY" (
  "ID" VARCHAR(40) NOT NULL,
  "TAKEN_DTT" DATETIME DEFAULT NULL,
  "TAKEN_BY" VARCHAR(50) DEFAULT NULL,
  "COURSE_SCHEDULE_ID" VARCHAR(40) DEFAULT NULL,
  "COMMENT" VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "AB_TAKEN_BY" ("TAKEN_BY"),
  KEY "COURSE_SCHEDULE_ID" ("COURSE_SCHEDULE_ID"),
  CONSTRAINT "ATTENDANCE_BY_IBFK_2" FOREIGN KEY ("COURSE_SCHEDULE_ID") REFERENCES "COURSE_SCHEDULE" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT "ATTENDANCE_BY_IBFK_1" FOREIGN KEY ("TAKEN_BY") REFERENCES "STAFF" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR ATTENDANCE
-- ----------------------------
DROP TABLE IF EXISTS "ATTENDANCE";
CREATE TABLE "ATTENDANCE" (
  "ID" VARCHAR(40) NOT NULL,
  "STUDENT_COURSE_ENROLLMENT_ID" VARCHAR(40) NOT NULL,
  "COMMENT" VARCHAR(255) DEFAULT NULL,
  "STATUS" TINYINT(1) DEFAULT NULL,
  "ATTENDANCE_BY_ID" VARCHAR(40) NOT NULL,
  PRIMARY KEY ("ID"),
  KEY "STUDENT_COURSE_ENROLLMENT_ID" ("STUDENT_COURSE_ENROLLMENT_ID"),
  CONSTRAINT "ATTENDANCE_IBFK_2" FOREIGN KEY ("ATTENDANCE_BY_ID") REFERENCES "ATTENDANCE_BY" ("ID") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "ATTENDANCE_IBFK_1" FOREIGN KEY ("STUDENT_COURSE_ENROLLMENT_ID") REFERENCES "STUDENT_COURSE_ENROLLMENT" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR TEST
-- ----------------------------
DROP TABLE IF EXISTS "TEST";
CREATE TABLE "TEST" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  "REF_ID" VARCHAR(40) DEFAULT NULL,
  "TEST_TYPE" VARCHAR(50) DEFAULT NULL,
  "START_DTT" VARCHAR(255) DEFAULT NULL,
  "END_DTT" VARCHAR(255) DEFAULT NULL,
  "MAX_SCORE" VARCHAR(255) DEFAULT NULL,
  "DESC" VARCHAR(1000) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID")
);

-- ----------------------------
-- TABLE STRUCTURE FOR TEST_SCORES
-- ----------------------------
DROP TABLE IF EXISTS "TEST_SCORE";
CREATE TABLE "TEST_SCORE" (
  "ID" VARCHAR(40) NOT NULL,
  "TEST_ID" VARCHAR(40) NOT NULL,
  "PERSON_ID" VARCHAR(40) NOT NULL,
  "START_DTT" DATETIME DEFAULT NULL,
  "END_DTT" DATETIME DEFAULT NULL,
  "GRADE" VARCHAR(10) DEFAULT NULL,
  "SCORE" INT(255) DEFAULT NULL,
  "NOTES" VARCHAR(255) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "TEST_ID" ("TEST_ID"),
  KEY "PERSON_ID" ("PERSON_ID"),
  CONSTRAINT "TEST_SCORE_IBFK_2" FOREIGN KEY ("PERSON_ID") REFERENCES "PERSON" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT "TEST_SCORE_IBFK_1" FOREIGN KEY ("TEST_ID") REFERENCES "TEST" ("ID") ON DELETE NO ACTION ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR FEE
-- ----------------------------
DROP TABLE IF EXISTS "FEE";
CREATE TABLE "FEE" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(256) DEFAULT NULL,
  "STUDENT_ID" VARCHAR(40) NOT NULL,
  "ACADEMIC_TERM" VARCHAR(100) NOT NULL,
  "AMOUNT" FLOAT NOT NULL,
  "COMMENT" VARCHAR(1000),
  PRIMARY KEY ("ID"),
  KEY "FEE_ID" ("ID"),
  CONSTRAINT "FEE_IBFK_1" FOREIGN KEY ("STUDENT_ID") REFERENCES "STUDENT" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR PAYMENT
-- ----------------------------
DROP TABLE IF EXISTS "PAYMENT";
CREATE TABLE "PAYMENT" (
  "ID" VARCHAR(40) NOT NULL,
  "NAME" VARCHAR(256) DEFAULT NULL,
  "FEE_ID" VARCHAR(40),
  "AMOUNT" FLOAT NOT NULL,
  "COMMENT" VARCHAR(1000),
  PRIMARY KEY ("ID"),
  KEY "PAYMENT_ID" ("ID"),
  CONSTRAINT "PAYMENT_IBFK_1" FOREIGN KEY ("FEE_ID") REFERENCES "FEE" ("ID") ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- TABLE STRUCTURE FOR SCHOOL_SCHEDULE
-- ----------------------------
DROP TABLE IF EXISTS "SCHOOL_SCHEDULE";
CREATE TABLE "SCHOOL_SCHEDULE" (
  "ID" VARCHAR(40) NOT NULL,
  "EVENT_NAME" VARCHAR(255) DEFAULT NULL,
  "STATUS" TINYINT(1) DEFAULT NULL,
  "START_DTT" DATETIME DEFAULT NULL,
  "END_DTT" DATETIME DEFAULT NULL,
  "ANNONCED_BY" VARCHAR(50) DEFAULT NULL,
  "MODIFIED_DTT" DATETIME DEFAULT NULL,
  PRIMARY KEY ("ID"),
  KEY "ANNONCED_BY" ("ANNONCED_BY"),
  CONSTRAINT "SCHOOL_SCHEDULE_IBFK_1" FOREIGN KEY ("ANNONCED_BY") REFERENCES "STAFF" ("ID") ON DELETE SET NULL ON UPDATE CASCADE
);
