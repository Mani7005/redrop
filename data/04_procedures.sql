-- ============================================================
-- REDROP - Smart Blood Donation Management System
-- 04_procedures.sql : Stored Procedures
-- 1. find_donors(blood_type, city)   — uses fn_days_since_donation
-- 2. get_blood_group_stats()         — uses CURSOR
-- 3. match_emergency_donors(req_id)  — emergency donor matching
-- ============================================================

USE blood_donation;

DELIMITER $$

-- ------------------------------------------------------------
-- PROCEDURE 1: find_donors
-- Finds available donors by blood type and city
-- Calls fn_days_since_donation() for each row
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS find_donors$$

CREATE PROCEDURE find_donors(
    IN p_blood_type VARCHAR(5),
    IN p_city       VARCHAR(100)
)
BEGIN
    SELECT
        d.donor_id,
        d.name,
        bg.blood_type        AS blood_group,
        d.city,
        d.contact            AS phone,
        d.last_donation,
        d.is_available,
        fn_days_since_donation(d.donor_id) AS days_since_donation
    FROM   Donor d
    JOIN   Blood_Group bg ON d.blood_group_id = bg.blood_group_id
    WHERE  bg.blood_type = p_blood_type
      AND  d.city        = p_city
      AND  d.is_available = TRUE
    ORDER  BY d.last_donation ASC;
END$$


-- ------------------------------------------------------------
-- PROCEDURE 2: get_blood_group_stats
-- Uses a CURSOR to iterate all blood groups and build stats
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS get_blood_group_stats$$

CREATE PROCEDURE get_blood_group_stats()
BEGIN
    -- Cursor variables
    DECLARE v_bg_id      INT;
    DECLARE v_bg_type    VARCHAR(5);
    DECLARE v_done       INT DEFAULT 0;

    -- Stats variables
    DECLARE v_total      INT DEFAULT 0;
    DECLARE v_available  INT DEFAULT 0;
    DECLARE v_units      INT DEFAULT 0;

    -- Declare cursor over all blood groups
    DECLARE bg_cursor CURSOR FOR
        SELECT blood_group_id, blood_type FROM Blood_Group ORDER BY blood_type;

    -- Handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    -- Temp table to collect results
    DROP TEMPORARY TABLE IF EXISTS tmp_stats;
    CREATE TEMPORARY TABLE tmp_stats (
        blood_group      VARCHAR(5),
        total_donors     INT,
        available_donors INT,
        available_units  INT
    );

    OPEN bg_cursor;

    stat_loop: LOOP
        FETCH bg_cursor INTO v_bg_id, v_bg_type;
        IF v_done = 1 THEN LEAVE stat_loop; END IF;

        -- Total donors for this blood group
        SELECT COUNT(*) INTO v_total
        FROM   Donor
        WHERE  blood_group_id = v_bg_id;

        -- Available donors
        SELECT COUNT(*) INTO v_available
        FROM   Donor
        WHERE  blood_group_id = v_bg_id AND is_available = TRUE;

        -- Blood units in stock
        SELECT COALESCE(available_units, 0) INTO v_units
        FROM   Blood_Availability
        WHERE  blood_group_id = v_bg_id;

        INSERT INTO tmp_stats VALUES (v_bg_type, v_total, v_available, v_units);
    END LOOP stat_loop;

    CLOSE bg_cursor;

    -- Return results
    SELECT * FROM tmp_stats WHERE total_donors > 0;
    DROP TEMPORARY TABLE IF EXISTS tmp_stats;
END$$


-- ------------------------------------------------------------
-- PROCEDURE 3: match_emergency_donors
-- Finds eligible donors for an emergency request and
-- inserts Donor_Notification records + updates request status
-- Uses CURSOR to iterate matching donors
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS match_emergency_donors$$

CREATE PROCEDURE match_emergency_donors(IN p_request_id INT)
BEGIN
    DECLARE v_donor_id   INT;
    DECLARE v_bg_id      INT;
    DECLARE v_city       VARCHAR(100);
    DECLARE v_done       INT DEFAULT 0;
    DECLARE v_count      INT DEFAULT 0;

    DECLARE donor_cursor CURSOR FOR
        SELECT d.donor_id
        FROM   Donor d
        WHERE  d.blood_group_id = v_bg_id
          AND  d.city           = v_city
          AND  d.is_available   = TRUE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    -- Get request details
    SELECT blood_group_id, city
    INTO   v_bg_id, v_city
    FROM   Emergency_Request
    WHERE  request_id = p_request_id;

    OPEN donor_cursor;

    notify_loop: LOOP
        FETCH donor_cursor INTO v_donor_id;
        IF v_done = 1 THEN LEAVE notify_loop; END IF;

        -- Insert notification (ignore duplicates)
        INSERT IGNORE INTO Donor_Notification (donor_id, request_id, notification_status)
        VALUES (v_donor_id, p_request_id, 'Sent');

        SET v_count = v_count + 1;
    END LOOP notify_loop;

    CLOSE donor_cursor;

    -- Update request status if at least one donor found
    IF v_count > 0 THEN
        UPDATE Emergency_Request
        SET    status = 'Fulfilled'
        WHERE  request_id = p_request_id;
    END IF;

    SELECT v_count AS donors_notified;
END$$

DELIMITER ;
