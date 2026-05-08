-- ============================================================
-- REDROP - Smart Blood Donation Management System
-- 05_trigger.sql : Triggers
-- 1. trg_check_availability  — BEFORE UPDATE on Donor
-- 2. trg_after_donation      — AFTER INSERT on Donation_Record
-- ============================================================

USE blood_donation;

DELIMITER $$

-- ------------------------------------------------------------
-- TRIGGER 1: trg_check_availability
-- Fires BEFORE UPDATE on Donor
-- Auto-sets is_available based on 90-day cooldown rule
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_check_availability$$

CREATE TRIGGER trg_check_availability
BEFORE UPDATE ON Donor
FOR EACH ROW
BEGIN
    IF NEW.last_donation IS NOT NULL THEN
        IF DATEDIFF(CURDATE(), NEW.last_donation) < 90 THEN
            SET NEW.is_available = FALSE;
        ELSE
            SET NEW.is_available = TRUE;
        END IF;
    END IF;
END$$


-- ------------------------------------------------------------
-- TRIGGER 2: trg_after_donation
-- Fires AFTER INSERT on Donation_Record
-- Updates donor's last_donation date automatically
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_after_donation$$

CREATE TRIGGER trg_after_donation
AFTER INSERT ON Donation_Record
FOR EACH ROW
BEGIN
    UPDATE Donor
    SET    last_donation = NEW.donation_date
    WHERE  donor_id      = NEW.donor_id;
END$$

DELIMITER ;
