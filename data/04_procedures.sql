-- ============================================================
--  Blood Donation System  |  DBMS Project
--  Step 4: Stored PROCEDURES  (PL/SQL requirement)
--
--  Procedure 1: find_donors(blood_group, city)
--    → Searches available donors. Called by Flask /search route.
--
--  Procedure 2: get_blood_group_stats()
--    → Uses a CURSOR to iterate over all blood groups and
--      build a stats summary table. Called by Flask /stats route.
-- ============================================================
USE blood_donation;

-- -----------------------------------------------------------
--  Procedure 1 – find_donors
-- -----------------------------------------------------------
DROP PROCEDURE IF EXISTS find_donors;

DELIMITER //
CREATE PROCEDURE find_donors(IN p_blood_group VARCHAR(5), IN p_city VARCHAR(50))
BEGIN
    SELECT donor_id, name, blood_group, city, phone,
           last_donation,
           fn_days_since_donation(donor_id) AS days_since_donation
    FROM   donors
    WHERE  blood_group  = p_blood_group
      AND  city         = p_city
      AND  is_available = TRUE
    ORDER  BY last_donation ASC;
END //
DELIMITER ;


-- -----------------------------------------------------------
--  Procedure 2 – get_blood_group_stats  (uses CURSOR)
-- -----------------------------------------------------------
DROP PROCEDURE IF EXISTS get_blood_group_stats;

DELIMITER //
CREATE PROCEDURE get_blood_group_stats()
BEGIN
    -- Variables to hold cursor data
    DECLARE v_bg        VARCHAR(5);
    DECLARE v_available INT;
    DECLARE v_total     INT;
    DECLARE done        INT DEFAULT FALSE;

    -- Cursor: one row per distinct blood group
    DECLARE bg_cursor CURSOR FOR
        SELECT
            blood_group,
            SUM(CASE WHEN is_available = TRUE  THEN 1 ELSE 0 END) AS available,
            COUNT(*) AS total
        FROM donors
        GROUP BY blood_group
        ORDER BY blood_group;

    -- Handler: set done = TRUE when no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Temp table to collect results
    DROP TEMPORARY TABLE IF EXISTS blood_stats;
    CREATE TEMPORARY TABLE blood_stats (
        blood_group       VARCHAR(5),
        available_donors  INT,
        total_donors      INT
    );

    OPEN bg_cursor;

    fetch_loop: LOOP
        FETCH bg_cursor INTO v_bg, v_available, v_total;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        INSERT INTO blood_stats VALUES (v_bg, v_available, v_total);
    END LOOP fetch_loop;

    CLOSE bg_cursor;

    -- Return the collected stats
    SELECT * FROM blood_stats;
END //
DELIMITER ;
