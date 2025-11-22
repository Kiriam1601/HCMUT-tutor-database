USE hcmut_tutor;

DELIMITER //

DROP FUNCTION IF EXISTS func_danh_gia_tai_cong_viec //
-- -----------------------------------------------------
-- Duyệt qua các lớp học (tutor_pair) của một mentor cụ thể,
-- tính tổng số tiết (session) họ phải dạy và trả về đánh giá (Rảnh rỗi, Bình thường, Quá tải).
-- -----------------------------------------------------

CREATE FUNCTION func_danh_gia_tai_cong_viec(p_mentorID VARCHAR(50)) 
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Khai báo biến
    DECLARE v_total_sessions INT DEFAULT 0;
    DECLARE v_begin INT;
    DECLARE v_end INT;
    DECLARE v_message VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_exists INT;

    -- Khai báo con trỏ (CURSOR) để lấy danh sách các kíp dạy của mentor
    DECLARE cur_schedule CURSOR FOR 
        SELECT begin_session, end_session 
        FROM tutor_pair 
        WHERE mentorID = p_mentorID;

    -- Khai báo handler để xử lý khi con trỏ duyệt hết dữ liệu
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 1. Kiểm tra tham số đầu vào (Validation)
    SELECT COUNT(*) INTO v_exists FROM mentor WHERE mentorID = p_mentorID;
    
    IF v_exists = 0 THEN
        RETURN CONCAT('Lỗi: Mentor ID ', p_mentorID, ' không tồn tại.');
    END IF;

    -- 2. Mở con trỏ và bắt đầu vòng lặp
    OPEN cur_schedule;

    read_loop: LOOP
        FETCH cur_schedule INTO v_begin, v_end;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Tính toán số tiết của từng môn (Kết thúc - Bắt đầu + 1)
        SET v_total_sessions = v_total_sessions + (v_end - v_begin + 1);
    END LOOP;

    CLOSE cur_schedule;

    -- 3. Sử dụng IF để đánh giá kết quả
    IF v_total_sessions = 0 THEN
        SET v_message = 'Trạng thái: Chưa nhận lớp nào.';
    ELSEIF v_total_sessions <= 4 THEN
        SET v_message = CONCAT('Trạng thái: Rảnh rỗi (Tổng tiết: ', v_total_sessions, ')');
    ELSEIF v_total_sessions <= 8 THEN
        SET v_message = CONCAT('Trạng thái: Bình thường (Tổng tiết: ', v_total_sessions, ')');
    ELSE
        SET v_message = CONCAT('Trạng thái: Quá tải (Tổng tiết: ', v_total_sessions, ')');
    END IF;

    RETURN v_message;
END //

DELIMITER ;

-- -----------------------------------------------------
-- Script kiểm thử
--
-- SELECT func_danh_gia_tai_cong_viec('mentor01') AS Ket_Qua_Mentor01;
-- Dự kiến: Tổng tiết khoảng 6 (3 tiết + 3 tiết) -> Trạng thái: Bình thường
--
-- SELECT func_danh_gia_tai_cong_viec('mentor05') AS Ket_Qua_Mentor05;
-- Dự kiến: Tổng tiết 3 -> Trạng thái: Rảnh rỗi
--
-- SELECT func_danh_gia_tai_cong_viec('mentor99') AS Ket_Qua_Loi;
-- Dự kiến: Lỗi: Mentor ID mentor99 không tồn tại.
-- -----------------------------------------------------