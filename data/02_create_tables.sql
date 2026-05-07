-- ============================================================
--  Blood Donation System  |  DBMS Project
--  Step 2: Create Tables
-- ============================================================
USE blood_donation;

DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS donors;

-- Donors table
CREATE TABLE donors (
    donor_id      INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    blood_group   ENUM('A+','A-','B+','B-','O+','O-','AB+','AB-') NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    phone         VARCHAR(15)  NOT NULL UNIQUE,
    last_donation DATE,
    is_available  BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_phone CHECK (LENGTH(phone) = 10)
);

-- Emergency requests table
CREATE TABLE requests (
    request_id   INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    blood_group  ENUM('A+','A-','B+','B-','O+','O-','AB+','AB-') NOT NULL,
    city         VARCHAR(50)  NOT NULL,
    phone        VARCHAR(15)  NOT NULL,
    urgency      ENUM('Normal','Urgent','Critical') DEFAULT 'Normal',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
