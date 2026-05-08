-- ============================================================
-- REDROP - Smart Blood Donation Management System
-- 02_create_tables.sql : All 6 tables (matches synopsis schema)
-- Tables: Blood_Group, Donor, Donation_Record,
--         Blood_Availability, Emergency_Request, Donor_Notification
-- ============================================================

USE blood_donation;

-- ------------------------------------------------------------
-- TABLE 1: Blood_Group (lookup table — avoids redundancy, 3NF)
-- ------------------------------------------------------------
CREATE TABLE Blood_Group (
    blood_group_id   INT           AUTO_INCREMENT PRIMARY KEY,
    blood_type       VARCHAR(5)    NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- TABLE 2: Donor
-- ------------------------------------------------------------
CREATE TABLE Donor (
    donor_id         INT           AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100)  NOT NULL,
    age              INT           NOT NULL CHECK (age >= 18 AND age <= 65),
    gender           ENUM('Male','Female','Other') NOT NULL,
    contact          VARCHAR(10)   NOT NULL UNIQUE,
    blood_group_id   INT           NOT NULL,
    last_donation    DATE,
    is_available     BOOLEAN       DEFAULT TRUE,
    city             VARCHAR(100)  NOT NULL,
    FOREIGN KEY (blood_group_id) REFERENCES Blood_Group(blood_group_id)
);

-- ------------------------------------------------------------
-- TABLE 3: Donation_Record
-- ------------------------------------------------------------
CREATE TABLE Donation_Record (
    donation_id      INT           AUTO_INCREMENT PRIMARY KEY,
    donor_id         INT           NOT NULL,
    donation_date    DATE          NOT NULL DEFAULT (CURDATE()),
    quantity_ml      INT           NOT NULL DEFAULT 450,
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- TABLE 4: Blood_Availability
-- ------------------------------------------------------------
CREATE TABLE Blood_Availability (
    blood_group_id   INT           PRIMARY KEY,
    available_units  INT           NOT NULL DEFAULT 0 CHECK (available_units >= 0),
    FOREIGN KEY (blood_group_id) REFERENCES Blood_Group(blood_group_id)
);

-- ------------------------------------------------------------
-- TABLE 5: Emergency_Request
-- ------------------------------------------------------------
CREATE TABLE Emergency_Request (
    request_id       INT           AUTO_INCREMENT PRIMARY KEY,
    hospital_name    VARCHAR(150)  NOT NULL,
    blood_group_id   INT           NOT NULL,
    required_units   INT           NOT NULL DEFAULT 1,
    request_date     DATETIME      DEFAULT CURRENT_TIMESTAMP,
    contact_phone    VARCHAR(10)   NOT NULL,
    urgency          ENUM('Normal','Urgent','Critical') DEFAULT 'Normal',
    status           ENUM('Pending','Fulfilled','Cancelled') DEFAULT 'Pending',
    city             VARCHAR(100)  NOT NULL,
    FOREIGN KEY (blood_group_id) REFERENCES Blood_Group(blood_group_id)
);

-- ------------------------------------------------------------
-- TABLE 6: Donor_Notification
-- ------------------------------------------------------------
CREATE TABLE Donor_Notification (
    notification_id      INT       AUTO_INCREMENT PRIMARY KEY,
    donor_id             INT       NOT NULL,
    request_id           INT       NOT NULL,
    notification_status  ENUM('Sent','Acknowledged','Declined') DEFAULT 'Sent',
    notified_at          DATETIME  DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id)   REFERENCES Donor(donor_id)           ON DELETE CASCADE,
    FOREIGN KEY (request_id) REFERENCES Emergency_Request(request_id) ON DELETE CASCADE
);
