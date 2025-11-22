USE hcmut_tutor;
DELIMITER //

DROP FUNCTION IF EXISTS func_kiem_tra_chuyen_can //
-- -----------------------------------------------------
-- Duyệt qua danh sách các lớp mà Mentee tham gia (mentee_list join tutor_pair), 
-- đếm tổng số môn học và kiểm tra xem có môn nào học vào cuối tuần (Thứ 7, CN) 
-- hay không để đánh giá mức độ chăm chỉ.
-- -----------------------------------------------------

CREATE FUNCTION func_kiem_tra_chuyen_can(p_menteeID VARCHAR(50)) 
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Khai báo biến
    DECLARE v_course_count INT DEFAULT 0;
    DECLARE v_day VARCHAR(100);
    DECLARE v_has_weekend_class BOOLEAN DEFAULT FALSE;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_exists INT;
    DECLARE v_result VARCHAR(255);

    -- Khai báo con trỏ: Lấy ngày học của các lớp mà mentee này tham gia
    DECLARE cur_mentee_schedule CURSOR FOR 
        SELECT tp.day 
        FROM mentee_list ml
        JOIN tutor_pair tp ON ml.pairID = tp.pairID
        WHERE ml.menteeID = p_menteeID;

    -- Handler ngắt vòng lặp
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 1. Kiểm tra tham số đầu vào
    SELECT COUNT(*) INTO v_exists FROM mentee WHERE menteeID = p_menteeID;
    
    IF v_exists = 0 THEN
        RETURN CONCAT('Lỗi: Mentee ID ', p_menteeID, ' không tồn tại.');
    END IF;

    -- 2. Mở con trỏ và lặp
    OPEN cur_mentee_schedule;

    process_loop: LOOP
        FETCH cur_mentee_schedule INTO v_day;
        
        IF done THEN
            LEAVE process_loop;
        END IF;

        -- Tăng số lượng môn học
        SET v_course_count = v_course_count + 1;

        -- Kiểm tra nếu học vào cuối tuần
        IF v_day IN ('Thu Bay', 'CN') THEN
            SET v_has_weekend_class = TRUE;
        END IF;
    END LOOP;

    CLOSE cur_mentee_schedule;

    -- 3. Logic đánh giá trả về
    IF v_course_count = 0 THEN
        SET v_result = 'Sinh viên chưa đăng ký môn học nào.';
    ELSEIF v_has_weekend_class = TRUE THEN
        SET v_result = CONCAT('Rất chăm chỉ: Học ', v_course_count, ' môn (bao gồm cả cuối tuần).');
    ELSEIF v_course_count >= 2 THEN
        SET v_result = CONCAT('Tích cực: Đang học ', v_course_count, ' môn.');
    ELSE
        SET v_result = CONCAT('Bình thường: Đang học ', v_course_count, ' môn.');
    END IF;

    RETURN v_result;
END //

DELIMITER ;
-- -----------------------------------------------------
-- Script kiểm thử
--
-- SELECT func_kiem_tra_chuyen_can('mentee01') AS Ket_Qua_Mentee01;
-- Dự kiến: Tích cực: Đang học 2 môn (Lớp 1 T2, Lớp 3 T3 - không có cuối tuần).
--
-- SELECT func_kiem_tra_chuyen_can('mentee05') AS Ket_Qua_Mentee05;
-- Dự kiến: Sinh viên chưa đăng ký môn học nào.
--
--
-- Insert tạm để test: mentee02 vào lớp ID 5 (Học Thứ Bảy)
-- INSERT INTO mentee_list (pairID, menteeID) VALUES (5, 'mentee02');

-- SELECT func_kiem_tra_chuyen_can('mentee02') AS Ket_Qua_Cuoi_Tuan;
-- Dự kiến: Rất chăm chỉ: Học... môn (bao gồm cả cuối tuần).

-- Xóa dữ liệu test sau khi xong
-- DELETE FROM mentee_list WHERE pairID = 5 AND menteeID = 'mentee02';
-- -----------------------------------------------------