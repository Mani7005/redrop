-- ============================================================
--  Blood Donation System  |  DBMS Project
--  Step 5: TRIGGER  (PL/SQL requirement)
--
--  trg_check_availability
--    → Fires BEFORE every UPDATE on the donors table.
--    → Automatically sets is_available = FALSE if the donor
--      donated blood within the last 90 days.
--    → Restores is_available = TRUE once 90 days have passed.
--    → Uses fn_days_since_donation() (our stored function).
-- ============================================================
USE blood_donation;

DROP TRIGGER IF EXISTS trg_check_availability;

DELIMITER //
CREATE TRIGGER trg_check_availability
BEFORE UPDATE ON donors
FOR EACH ROW
BEGIN
    -- If last_donation is being updated, re-evaluate availability
    IF NEW.last_donation IS NOT NULL THEN
        IF DATEDIFF(CURDATE(), NEW.last_donation) < 90 THEN
            SET NEW.is_available = FALSE;   -- Donated too recently
        ELSE
            SET NEW.is_available = TRUE;    -- Eligible again
        END IF;
    END IF;
END //
DELIMITER ;
