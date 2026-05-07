-- ============================================================
--  Blood Donation System  |  DBMS Project
--  Step 3: Stored FUNCTION  (PL/SQL requirement)
--
--  fn_days_since_donation(donor_id)
--    → Returns how many days ago the donor last donated.
--    → Returns -1 if no donation date is recorded.
--    → The trigger uses this value to decide availability.
-- ============================================================
USE blood_donation;

DROP FUNCTION IF EXISTS fn_days_since_donation;

DELIMITER //
CREATE FUNCTION fn_days_since_donation(p_donor_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last_date DATE;
    DECLARE v_days INT;

    SELECT last_donation
    INTO   v_last_date
    FROM   donors
    WHERE  donor_id = p_donor_id;

    IF v_last_date IS NULL THEN
        RETURN -1;
    END IF;

    SET v_days = DATEDIFF(CURDATE(), v_last_date);
    RETURN v_days;
END //
DELIMITER ;

-- Quick test (run after sample data is loaded):
-- SELECT fn_days_since_donation(1);
