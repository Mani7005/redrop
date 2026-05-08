-- ============================================================
-- REDROP - Smart Blood Donation Management System
-- 03_function.sql : Stored Function
-- fn_days_since_donation(donor_id) — DETERMINISTIC
-- ============================================================

USE blood_donation;

DELIMITER $$

DROP FUNCTION IF EXISTS fn_days_since_donation$$

CREATE FUNCTION fn_days_since_donation(p_donor_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last_date DATE;
    DECLARE v_days      INT;

    SELECT last_donation INTO v_last_date
    FROM   Donor
    WHERE  donor_id = p_donor_id;

    IF v_last_date IS NULL THEN
        RETURN -1;   -- Never donated
    END IF;

    SET v_days = DATEDIFF(CURDATE(), v_last_date);
    RETURN v_days;
END$$

DELIMITER ;
