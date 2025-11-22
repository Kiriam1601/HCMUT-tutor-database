-- -----------------------------------------------------
-- 1. KHỞI TẠO DATABASE VÀ BẢNG (SCHEMA)
-- -----------------------------------------------------
DROP DATABASE IF EXISTS hcmut_tutor;
CREATE DATABASE hcmut_tutor CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE hcmut_tutor;

SET FOREIGN_KEY_CHECKS = 0;

-- Table: faculty
DROP TABLE IF EXISTS `faculty`;
CREATE TABLE `faculty` (
  `FacultyID` int NOT NULL,
  `Faculty_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FacultyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: subject
DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject` (
  `FacultyID` int NOT NULL,
  `Subject_name` varchar(255) NOT NULL,
  KEY `FK_Subject_Faculty_idx` (`FacultyID`),
  CONSTRAINT `FK_Subject_Faculty` FOREIGN KEY (`FacultyID`) REFERENCES `faculty` (`FacultyID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: user
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `UserID` varchar(50) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) DEFAULT 'M',
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` varchar(50) DEFAULT 'mentee',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `UserID_UNIQUE` (`UserID`),
  CONSTRAINT `CHK_User_gender` CHECK ((`Gender` in (_utf8mb4'M',_utf8mb4'F'))),
  CONSTRAINT `CHK_User_Role` CHECK ((`Role` in (_utf8mb4'admin',_utf8mb4'mentee',_utf8mb4'mentor')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: admin
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `adminID` varchar(50) NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE KEY `admminID_UNIQUE` (`adminID`),
  CONSTRAINT `FK_Admin_User` FOREIGN KEY (`adminID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: mentee
DROP TABLE IF EXISTS `mentee`;
CREATE TABLE `mentee` (
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`menteeID`),
  UNIQUE KEY `menteeID_UNIQUE` (`menteeID`),
  CONSTRAINT `FK_Mentee_User` FOREIGN KEY (`menteeID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: mentor
DROP TABLE IF EXISTS `mentor`;
CREATE TABLE `mentor` (
  `mentorID` varchar(50) NOT NULL,
  `GPA` decimal(3,2) NOT NULL,
  `FacultyID` int NOT NULL,
  `job` varchar(50) NOT NULL,
  `sinh_vien_nam` varchar(50) NOT NULL,
  PRIMARY KEY (`mentorID`),
  UNIQUE KEY `mentorID_UNIQUE` (`mentorID`),
  CONSTRAINT `FK_Mentor_User` FOREIGN KEY (`mentorID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
  CONSTRAINT `chk_gpa_scale_mentor` CHECK (((`GPA` >= 0) and (`GPA` <= 4))),
  CONSTRAINT `CHK_job_check_mentor` CHECK ((`job` in (_utf8mb4'nghien_cuu_sinh',_utf8mb4'sinh_vien',_utf8mb4'sinh_vien_sau_dh',_utf8mb4'giang_vien'))),
  CONSTRAINT `CHK_year_check_mentor` CHECK ((`sinh_vien_nam` in (_utf8mb4'none',_utf8mb4'nam_2',_utf8mb4'nam_3',_utf8mb4'nam_4')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: tutor_application
DROP TABLE IF EXISTS `tutor_application`;
CREATE TABLE `tutor_application` (
  `applicationID` varchar(50) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) DEFAULT 'M',
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `GPA` decimal(3,2) NOT NULL,
  `FacultyID` int NOT NULL,
  `job` varchar(50) NOT NULL,
  `sinh_vien_nam` varchar(50) NOT NULL,
  `status` varchar(255) DEFAULT 'waiting',
  PRIMARY KEY (`applicationID`),
  UNIQUE KEY `Email` (`Email`), 
  CONSTRAINT `FK_faculty_application_form` FOREIGN KEY (`FacultyID`) REFERENCES `faculty` (`FacultyID`) ON DELETE CASCADE,
  CONSTRAINT `chk_application_status` CHECK ((`status` in (_utf8mb4'waiting',_utf8mb4'accepted',_utf8mb4'denied'))),
  CONSTRAINT `chk_gpa_scale_application` CHECK (((`GPA` >= 0) and (`GPA` <= 4))),
  CONSTRAINT `CHK_job_check` CHECK ((`job` in (_utf8mb4'nghien_cuu_sinh',_utf8mb4'sinh_vien',_utf8mb4'sinh_vien_sau_dh',_utf8mb4'giang_vien'))),
  CONSTRAINT `CHK_year_check` CHECK ((`sinh_vien_nam` in (_utf8mb4'none',_utf8mb4'nam_2',_utf8mb4'nam_3',_utf8mb4'nam_4')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: enroll
DROP TABLE IF EXISTS `enroll`;
CREATE TABLE `enroll` (
  `enrollID` int NOT NULL AUTO_INCREMENT,
  `mentorID` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'waiting',
  `Subject_name` varchar(255) NOT NULL,
  `begin_session` int NOT NULL,
  `end_session` int NOT NULL,
  `location` varchar(255) NOT NULL,
  `day` varchar(100) NOT NULL,
  KEY `FK_Enroll_mentee_idx` (`mentorID`),
  PRIMARY KEY (`enrollID`),
  CONSTRAINT `FK_Enroll_mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE,
  CONSTRAINT `chk_day_of_week` CHECK ((`day` in (_utf8mb4'Thu Hai',_utf8mb4'Thu Ba',_utf8mb4'Thu Tu',_utf8mb4'Thu Nam',_utf8mb4'Thu Sau',_utf8mb4'Thu Bay',_utf8mb4'CN'))),
  CONSTRAINT `chk_enroll_status` CHECK ((`status` in (_utf8mb4'waiting',_utf8mb4'accepted',_utf8mb4'denied'))),
  CONSTRAINT `chk_session_order` CHECK ((`end_session` >= `begin_session`)),
  CONSTRAINT `chk_session_range` CHECK (((`begin_session` >= 1) and (`begin_session` <= 17) and (`end_session` >= 1) and (`end_session` <= 17)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: tutor_pair
DROP TABLE IF EXISTS `tutor_pair`;
CREATE TABLE `tutor_pair` (
  `pairID` int NOT NULL AUTO_INCREMENT,
  `enrollID` int NOT NULL,
  `mentorID` varchar(50) NOT NULL,
  `Subject_name` varchar(255) DEFAULT NULL,
  `begin_session` int NOT NULL,
  `end_session` int NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `day` varchar(100) DEFAULT NULL,
  `mentee_capacity` int DEFAULT '15',
  `mentee_current_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`pairID`,`mentorID`),
  UNIQUE KEY `pairID_UNIQUE` (`pairID`),
  KEY `FK_tutor_pair_mentor` (`mentorID`),
  CONSTRAINT `FK_tutor_pair_enroll` FOREIGN KEY (`enrollID`) REFERENCES `enroll` (`enrollID`) ON DELETE CASCADE,
  CONSTRAINT `FK_tutor_pair_mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE,
  CONSTRAINT `chk_tutor_pair_day_of_week` CHECK ((`day` in (_utf8mb4'Thu Hai',_utf8mb4'Thu Ba',_utf8mb4'Thu Tu',_utf8mb4'Thu Nam',_utf8mb4'Thu Sau',_utf8mb4'Thu Bay',_utf8mb4'CN'))),
  CONSTRAINT `chk_tutor_pair_session_order` CHECK ((`end_session` >= `begin_session`)),
  CONSTRAINT `chk_tutor_pair_session_range` CHECK (((`begin_session` >= 1) and (`begin_session` <= 15) and (`end_session` >= 1) and (`end_session` <= 15)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: mentee_list
DROP TABLE IF EXISTS `mentee_list`;
CREATE TABLE `mentee_list` (
  `pairID` int NOT NULL,
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`pairID`,`menteeID`),
  KEY `FK_mentee_list_mentee` (`menteeID`),
  CONSTRAINT `FK_mentee_list_mentee` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE,
  CONSTRAINT `FK_mentee_list_pair` FOREIGN KEY (`pairID`) REFERENCES `tutor_pair` (`pairID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: outline
DROP TABLE IF EXISTS `outline`;
CREATE TABLE `outline` (
  `OutlineID` int NOT NULL AUTO_INCREMENT,
  `PairID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Context` text,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OutlineID`),
  KEY `FK_Outline_pair` (`PairID`),
  CONSTRAINT `FK_Outline_pair` FOREIGN KEY (`PairID`) REFERENCES `tutor_pair` (`pairID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: feedback_tutor
DROP TABLE IF EXISTS `feedback_tutor`;
CREATE TABLE `feedback_tutor` (
  `FeedbackTutorID` int NOT NULL AUTO_INCREMENT,
  `mentorID` varchar(50) NOT NULL,
  `menteeID` varchar(50) NOT NULL,
  `Context` text NOT NULL,
  `Date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FeedbackTutorID`),
  KEY `FK_FeedbackTutor_Mentor` (`mentorID`),
  KEY `FK_FeedbackTutor_Mentee` (`menteeID`),
  CONSTRAINT `FK_FeedbackTutor_Mentee` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_FeedbackTutor_Mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;


-- -----------------------------------------------------
-- 2. TÍCH HỢP TRIGGERS
-- -----------------------------------------------------

DELIMITER $$

-- =============================================
-- TRIGGERS CHO BẢNG: tutor_application
-- =============================================

-- 1. Check Email tồn tại trong User trước khi nộp đơn
DROP TRIGGER IF EXISTS `trg_before_application_accept_check_email`$$
CREATE TRIGGER `trg_before_application_accept_check_email` BEFORE INSERT ON `tutor_application`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM user WHERE Email = NEW.Email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Địa chỉ Email này đã tồn tại trong hệ thống User.';
    END IF; 
END$$

-- 2. Tự động tạo User và Mentor khi đơn được duyệt (Accepted)
DROP TRIGGER IF EXISTS `trg_after_application_accept`$$
CREATE TRIGGER `trg_after_application_accept` AFTER UPDATE ON `tutor_application` FOR EACH ROW BEGIN
    -- Chỉ chạy khi status chuyển sang 'accepted'
    IF NEW.status = 'accepted' THEN
        -- Insert vào bảng USER
        INSERT INTO `user` (
            `UserID`, `FullName`, `DateOfBirth`, `Gender`, `Phone`, `Email`, `Password`, `Role`
        ) VALUES (
            NEW.applicationID, NEW.FullName, NEW.DateOfBirth, NEW.Gender, NEW.Phone, NEW.Email, NEW.Password, 'mentor'
        );
        
        -- Insert vào bảng MENTOR
        INSERT INTO `mentor` (
            `mentorID`, `GPA`, `FacultyID`, `job`, `sinh_vien_nam`
        ) VALUES (
            NEW.applicationID, NEW.GPA, NEW.FacultyID, NEW.job, NEW.sinh_vien_nam
        );
    END IF;

    -- Xóa User/Mentor nếu bị từ chối hoặc chuyển lại waiting
    IF NEW.status = 'waiting' OR NEW.status = 'denied' THEN
        DELETE FROM `mentor` WHERE `mentorID` = NEW.applicationID;
        DELETE FROM `user` WHERE `UserID` = NEW.applicationID;
    END IF;
END$$


-- =============================================
-- TRIGGERS CHO BẢNG: user
-- =============================================
-- 3. Check Email trong danh sách chờ duyệt trước khi tạo User
DROP TRIGGER IF EXISTS `trg_before_user_accept_check_email`$$
CREATE TRIGGER `trg_before_user_accept_check_email` BEFORE INSERT ON `user`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM tutor_application WHERE Email = NEW.Email AND status = 'waiting') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Địa chỉ Email này đang chờ xét duyệt trong danh sách Mentor.';
    END IF; 
END$$

-- 4. Tự động phân loại User vào Admin hoặc Mentee
DROP TRIGGER IF EXISTS `user_AFTER_INSERT`$$
CREATE TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
  IF NEW.Role = 'admin' THEN
      INSERT INTO admin (adminID) VALUES (NEW.UserID);
  ELSEIF NEW.Role = 'mentee' THEN
      INSERT INTO mentee (menteeID) VALUES (NEW.UserID);
  END IF;

  -- Nếu email đã được tạo user chính thức, xóa đơn bị từ chối cũ (nếu có) để sạch data
  IF EXISTS (SELECT 1 FROM tutor_application WHERE Email = NEW.Email AND status = 'denied') THEN
      DELETE FROM `tutor_application` WHERE `Email` = NEW.Email;
  END IF;
END$$

-- =============================================
-- TRIGGERS CHO BẢNG: enroll
-- =============================================

-- 5. Check trùng lịch khi INSERT enroll
DROP TRIGGER IF EXISTS `trg_check_time_on_insert`$$
CREATE TRIGGER `trg_check_time_on_insert` BEFORE INSERT ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_conflict_id INT DEFAULT NULL;
    SELECT enrollID INTO v_conflict_id
    FROM enroll AS T_old
    WHERE 
        T_old.mentorID = NEW.mentorID AND 
        T_old.day = NEW.day AND
        T_old.status IN ('accepted', 'waiting') AND
        (
            NEW.end_session >= T_old.begin_session AND 
            NEW.begin_session <= T_old.end_session
        )
    LIMIT 1;
    
    IF v_conflict_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Thời gian đăng ký trùng lặp với phiên dạy đã tồn tại';
    END IF;
END$$

-- 6. Check trùng lịch khi UPDATE enroll
DROP TRIGGER IF EXISTS `trg_check_time_on_update`$$
CREATE TRIGGER `trg_check_time_on_update` BEFORE UPDATE ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_conflict_id INT DEFAULT NULL;
    
    -- Chỉ kiểm tra nếu có thay đổi về thời gian hoặc trạng thái
    IF (NEW.day <> OLD.day OR NEW.begin_session <> OLD.begin_session OR NEW.end_session <> OLD.end_session)
    OR (NEW.status IN ('accepted', 'waiting') AND OLD.status NOT IN ('accepted', 'waiting')) THEN
        SELECT enrollID INTO v_conflict_id
        FROM enroll AS T_old
        WHERE 
            T_old.enrollID != NEW.enrollID AND -- Tránh so sánh với chính nó
            T_old.mentorID = NEW.mentorID AND 
            T_old.day = NEW.day AND
            T_old.status IN ('accepted', 'waiting') AND
            (
                NEW.end_session >= T_old.begin_session AND 
                NEW.begin_session <= T_old.end_session
            )
        LIMIT 1;

        IF v_conflict_id IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Thời gian đăng ký trùng lặp với phiên dạy đã tồn tại';
        END IF;
    END IF;
END$$

-- 7. Check Môn học & Khoa khi INSERT enroll
DROP TRIGGER IF EXISTS `trg_check_subject_faculty_on_insert`$$
CREATE TRIGGER `trg_check_subject_faculty_on_insert` BEFORE INSERT ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_mentor_faculty_id INT;
    DECLARE v_subject_faculty_id INT;
    
    -- Lấy FacultyID của Mentor
    SELECT FacultyID INTO v_mentor_faculty_id FROM mentor WHERE mentorID = NEW.mentorID;
    
    -- Lấy FacultyID của Subject
    SELECT FacultyID INTO v_subject_faculty_id FROM subject WHERE Subject_name = NEW.Subject_name LIMIT 1;
    
    IF v_subject_faculty_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tên môn học không tồn tại trong bảng subject.';
    ELSEIF v_mentor_faculty_id != v_subject_faculty_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Môn học này không thuộc khoa mà mentor đang phụ trách.';
    END IF;
END$$

-- 8. Check Môn học & Khoa khi UPDATE enroll
DROP TRIGGER IF EXISTS `trg_check_subject_faculty_on_update`$$
CREATE TRIGGER `trg_check_subject_faculty_on_update` BEFORE UPDATE ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_mentor_faculty_id INT;
    DECLARE v_subject_faculty_id INT;

    IF NEW.mentorID != OLD.mentorID OR NEW.Subject_name != OLD.Subject_name THEN
        SELECT FacultyID INTO v_mentor_faculty_id FROM mentor WHERE mentorID = NEW.mentorID;
        SELECT FacultyID INTO v_subject_faculty_id FROM subject WHERE Subject_name = NEW.Subject_name LIMIT 1;

        IF v_subject_faculty_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tên môn học không tồn tại trong bảng subject.';
        ELSEIF v_mentor_faculty_id != v_subject_faculty_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Môn học này không thuộc khoa mà mentor đang phụ trách.';
        END IF;
    END IF;
END$$

-- 9. Đồng bộ Enroll sang Tutor_Pair
DROP TRIGGER IF EXISTS `trg_process_enroll_status`$$
CREATE TRIGGER `trg_process_enroll_status` AFTER UPDATE ON `enroll` FOR EACH ROW BEGIN
    -- Khi được duyệt -> Tạo lớp học
    IF NEW.status = 'accepted' THEN
        INSERT INTO `tutor_pair` (
            `enrollID`, `mentorID`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`
        ) VALUES (
            NEW.enrollID, NEW.mentorID, NEW.Subject_name, NEW.begin_session, NEW.end_session, NEW.location, NEW.day
        );
    END IF;
    
    -- Khi bị hủy hoặc chờ -> Xóa lớp học
    IF NEW.status = 'waiting' OR NEW.status = 'denied' THEN
      DELETE FROM `tutor_pair` WHERE `enrollID` = NEW.enrollID;
    END IF;
END$$

-- =============================================
-- TRIGGERS CHO BẢNG: mentee_list
-- =============================================

-- 10. Check sĩ số lớp trước khi thêm Mentee
DROP TRIGGER IF EXISTS `trg_check_mentee_capacity`$$
CREATE TRIGGER `trg_check_mentee_capacity` BEFORE INSERT ON `mentee_list` FOR EACH ROW BEGIN
    DECLARE v_current_count INT;
    DECLARE v_max_capacity INT;

    SELECT `mentee_capacity`, `mentee_current_count`
    INTO v_max_capacity, v_current_count
    FROM `tutor_pair`
    WHERE `pairID` = NEW.pairID
    FOR UPDATE; 

    IF v_current_count >= v_max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Lớp học này đã đủ sĩ số. Không thể thêm mentee.';
    END IF;
END$$

-- 11. Cập nhật số lượng Mentee (+1)
DROP TRIGGER IF EXISTS `trg_update_mentee_count_on_insert`$$
CREATE TRIGGER `trg_update_mentee_count_on_insert` AFTER INSERT ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` + 1
    WHERE `pairID` = NEW.pairID;
END$$

-- 12. Cập nhật số lượng Mentee (-1)
DROP TRIGGER IF EXISTS `trg_update_mentee_count_on_delete`$$
CREATE TRIGGER `trg_update_mentee_count_on_delete` AFTER DELETE ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` - 1
    WHERE `pairID` = OLD.pairID;
END$$

-- -----------------------------------------------------
-- 3. TÍCH HỢP PROCEDURE
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 3. 2.1
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_enroll_insert $$
-- Thủ tục thêm lịch đăng ký dạy của Mentor
CREATE PROCEDURE sp_enroll_insert(
    IN p_mentorID VARCHAR(50),
    IN p_Subject_name VARCHAR(255),
    IN p_begin_session INT,
    IN p_end_session INT,
    IN p_location VARCHAR(255),
    IN p_day VARCHAR(100)
)
BEGIN
    -- (Tùy chọn: Thêm các kiểm tra VALIDATE dữ liệu khác ở đây)
    
    -- 1. Kiểm tra thời gian bắt đầu và kết thúc
    IF p_begin_session > p_end_session THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tiết bắt đầu phải nhỏ hơn hoặc bằng tiết kết thúc.';
    END IF;

    -- 2. Thực hiện INSERT
    INSERT INTO enroll (
        mentorID, Subject_name, begin_session, end_session, location, day
    ) VALUES (
        p_mentorID, p_Subject_name, p_begin_session, p_end_session, p_location, p_day
    );
END $$

DROP PROCEDURE IF EXISTS sp_enroll_update $$
-- Thủ tục cập nhật lịch đăng ký dạy của Mentor
CREATE PROCEDURE sp_enroll_update(
    IN p_enrollID INT,
    IN p_Subject_name VARCHAR(255),
    IN p_begin_session INT,
    IN p_end_session INT,
    IN p_location VARCHAR(255),
    IN p_day VARCHAR(100)
)
BEGIN
    -- 1. Kiểm tra thời gian bắt đầu và kết thúc (Nghiệp vụ cơ bản)
    IF p_begin_session > p_end_session THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tiết bắt đầu phải nhỏ hơn hoặc bằng tiết kết thúc.';
    END IF;

    -- 2. Kiểm tra sự tồn tại của enrollID (Tùy chọn, nhưng nên có)
    IF NOT EXISTS (SELECT 1 FROM enroll WHERE enrollID = p_enrollID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy ID đăng ký để cập nhật.';
    END IF;
    
    -- 3. Thực hiện UPDATE
    UPDATE enroll
    SET 
        Subject_name = p_Subject_name,
        begin_session = p_begin_session,
        end_session = p_end_session,
        location = p_location,
        day = p_day
    WHERE
        enrollID = p_enrollID;
        
    -- 4. Kiểm tra xem có bản ghi nào bị ảnh hưởng không
    IF ROW_COUNT() = 0 THEN
         -- Trả về thông báo nếu không có hàng nào được cập nhật (enrollID đúng nhưng không có thay đổi dữ liệu)
         -- Chúng ta sẽ xử lý lỗi này ở Node.js để trả về 404/200 thích hợp hơn.
         SELECT 'No rows affected' AS status_message;
    ELSE
         SELECT 'Update successful' AS status_message;
    END IF;
END $$

DROP PROCEDURE IF EXISTS sp_enroll_delete $$
-- Thủ tục xóa lịch đăng ký dạy của Mentor
CREATE PROCEDURE sp_enroll_delete(
    IN p_enrollID INT
)
BEGIN
    DECLARE v_mentee_count INT DEFAULT 0;

    -- 1. Kiểm tra sự tồn tại của ID
    IF NOT EXISTS (SELECT 1 FROM enroll WHERE enrollID = p_enrollID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy ID đăng ký để xóa.';
    END IF;

    -- 3. Thực hiện DELETE
    DELETE FROM enroll
    WHERE enrollID = p_enrollID;
END $$

-- -----------------------------------------------------
-- 3. 2.3
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_search_subject_by_name $$
-- Thủ tục tìm kiếm môn học (Hiển thị tất cả nếu tham số rỗng)
CREATE PROCEDURE sp_search_subject_by_name(
    IN p_Subject_name VARCHAR(255)
)
BEGIN
    -- Kiểm tra tham số đầu vào (có thể cần sử dụng TRIM() để loại bỏ khoảng trắng thừa)
    SET p_Subject_name = TRIM(p_Subject_name);
    
    SELECT 
        DISTINCT Subject_name 
    FROM 
        subject 
    WHERE 
        (p_Subject_name IS NULL OR p_Subject_name = '') -- Nếu rỗng, điều kiện này đúng -> trả về tất cả
        OR 
        -- Ngược lại, thực hiện tìm kiếm chính xác (giữ lại COLLATE để tránh lỗi 1267)
        Subject_name = p_Subject_name COLLATE utf8mb4_0900_ai_ci;
END $$

DROP PROCEDURE IF EXISTS sp_select_tutor_pair_by_subject $$
-- Thủ tục truy vấn thông tin các lớp học dựa trên tên môn học
CREATE PROCEDURE sp_select_tutor_pair_by_subject(
    IN p_Subject_name VARCHAR(255)
)
BEGIN
    SELECT
        tp.*,         
        u.FullName    
    FROM
        tutor_pair tp 
    JOIN
        user u        
        ON tp.mentorID = u.UserID
    WHERE 
        tp.Subject_name = p_Subject_name COLLATE utf8mb4_0900_ai_ci;
        -- Nếu bạn cần sửa lỗi collation (Illegal mix...), hãy thêm COLLATE như sau:
        -- WHERE tp.Subject_name = p_Subject_name COLLATE utf8mb4_0900_ai_ci;
END $$

DROP PROCEDURE IF EXISTS sp_check_mentee_enrollment $$
-- Thủ tục kiểm tra xem một Mentee đã đăng ký môn học cụ thể chưa
CREATE PROCEDURE sp_check_mentee_enrollment(
    IN p_menteeID VARCHAR(50),
    IN p_Subject_name VARCHAR(255)
)
BEGIN
    SELECT 
        ml.pairID
    FROM
        mentee_list ml
    JOIN 
        tutor_pair tp
        ON tp.pairID = ml.pairID
    WHERE 
        tp.Subject_name = p_Subject_name COLLATE utf8mb4_0900_ai_ci
        AND ml.menteeID = p_menteeID COLLATE utf8mb4_0900_ai_ci;
END $$

DROP PROCEDURE IF EXISTS usp_DangKyLopHocMentee $$
-- Thủ tục xử lý toàn bộ quá trình đăng ký/thay thế lớp học cho Mentee
CREATE PROCEDURE usp_DangKyLopHocMentee(
    IN p_pairID INT,
    IN p_menteeID VARCHAR(50)
)
BEGIN
    DECLARE v_new_subject_name VARCHAR(255);
    DECLARE v_new_day VARCHAR(100);
    DECLARE v_new_begin_session INT;
    DECLARE v_new_end_session INT;
    DECLARE v_old_pairID INT;
    DECLARE v_conflict_count INT;

    -- 1. Lấy thông tin lớp mới và kiểm tra tồn tại (Giống bước 1 Node.js)
    SELECT 
        Subject_name, day, begin_session, end_session
    INTO 
        v_new_subject_name, v_new_day, v_new_begin_session, v_new_end_session
    FROM 
        tutor_pair 
    WHERE 
        pairID = p_pairID;

    IF v_new_subject_name IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Lớp học không tồn tại.';
    END IF;
    
    -- 2. Kiểm tra môn cũ cùng subject (Giống bước 2 Node.js)
    SELECT 
        ml.pairID 
    INTO 
        v_old_pairID
    FROM 
        mentee_list ml
    JOIN 
        tutor_pair tp ON ml.pairID = tp.pairID
    WHERE 
        ml.menteeID = p_menteeID 
        AND tp.Subject_name = v_new_subject_name
        AND ml.pairID != p_pairID; -- Đảm bảo không xét lớp đang cố gắng đăng ký lại

    -- 3. Kiểm tra trùng lịch (Giống bước 3 Node.js)
    SELECT 
        COUNT(*) 
    INTO 
        v_conflict_count
    FROM 
        mentee_list ml
    JOIN 
        tutor_pair tp ON ml.pairID = tp.pairID
    WHERE 
        ml.menteeID = p_menteeID
        AND tp.Subject_name != v_new_subject_name  -- Bỏ qua môn cùng subject (đã xét ở bước 2)
        AND tp.day = v_new_day
        AND NOT (tp.end_session < v_new_begin_session OR tp.begin_session > v_new_end_session);

    IF v_conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Trùng lịch học với lớp khác!';
    END IF;

    -- 4. Xóa môn cũ nếu cùng subject (Giống bước 4 Node.js)
    IF v_old_pairID IS NOT NULL THEN
        DELETE FROM mentee_list 
        WHERE menteeID = p_menteeID AND pairID = v_old_pairID;
    END IF;

    -- 5. Thêm môn mới (Giống bước 5 Node.js)
    INSERT INTO mentee_list(pairID, menteeID) 
    VALUES (p_pairID, p_menteeID);
    
    -- Nếu có trigger kiểm tra sĩ số, nó sẽ tự động kích hoạt lỗi 45000 nếu quá tải.

END $$

-- -----------------------------------------------------
-- 3. 2.4
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS func_danh_gia_tai_cong_viec $$
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
END $$

DROP FUNCTION IF EXISTS func_kiem_tra_chuyen_can $$
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
END $$

DELIMITER ;