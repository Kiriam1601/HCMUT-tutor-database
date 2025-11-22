-- -----------------------------------------------------
-- 2.2.1
-- -----------------------------------------------------

-- Kịch bản lỗi: Trùng với tiết 1-3 đã có
USE hcmut_tutor;
INSERT INTO `enroll` (`mentorID`, `status`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`) 
VALUES ('mentor01', 'waiting', 'Nhập môn Lập trình', 2, 4, 'H6-105', 'Thu Hai');

-- KẾT QUẢ MONG ĐỢI: Error Code: 45000 - Lỗi: Thời gian đăng ký trùng lặp...

-- Kịch bản đúng: Tiết 4-6 nằm ngoài khoảng 1-3
USE hcmut_tutor;
INSERT INTO `enroll` (`mentorID`, `status`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`) 
VALUES ('mentor01', 'waiting', 'Nhập môn Lập trình', 4, 6, 'H6-105', 'Thu Hai');

-- KẾT QUẢ MONG ĐỢI: Insert thành công, 1 row created.

-- -----------------------------------------------------
-- 2.2.2
-- -----------------------------------------------------

USE hcmut_tutor;
SELECT pairID, mentee_current_count FROM tutor_pair WHERE pairID = 1;
-- Kết quả: 4

USE hcmut_tutor;
INSERT INTO `mentee_list` (`pairID`, `menteeID`) VALUES (1, 'mentee03');
-- Kiểm tra lại:
SELECT pairID, mentee_current_count FROM tutor_pair WHERE pairID = 1;
-- KẾT QUẢ MONG ĐỢI: mentee_current_count tăng lên 5.

USE hcmut_tutor;
DELETE FROM `mentee_list` WHERE `pairID` = 1 AND `menteeID` = 'mentee03';
-- Kiểm tra lại:
SELECT pairID, mentee_current_count FROM tutor_pair WHERE pairID = 1;
-- KẾT QUẢ MONG ĐỢI: mentee_current_count giảm về 4.