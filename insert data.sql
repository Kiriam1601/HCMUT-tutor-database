USE hcmut_tutor;

-- Tắt kiểm tra khóa ngoại tạm thời để insert dữ liệu dễ dàng hơn
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- 1. Data for table `faculty` (Khoa)
-- -----------------------------------------------------
INSERT INTO `faculty` (`FacultyID`, `Faculty_name`) VALUES
(1, 'Khoa học và Kỹ thuật Máy tính'),
(2, 'Điện - Điện tử'),
(3, 'Kỹ thuật Cơ khí'),
(4, 'Kỹ thuật Hóa học'),
(5, 'Kỹ thuật Xây dựng');

-- -----------------------------------------------------
-- 2. Data for table `subject` (Môn học)
-- -----------------------------------------------------
INSERT INTO `subject` (`FacultyID`, `Subject_name`) VALUES
(1, 'Nhập môn Lập trình'),
(1, 'Cấu trúc dữ liệu và Giải thuật'),
(1, 'Hệ điều hành'),
(1, 'Mạng máy tính'),
(2, 'Mạch điện 1'),
(2, 'Trường điện từ'),
(3, 'Cơ lý thuyết'),
(4, 'Hóa đại cương'),
(5, 'Sức bền vật liệu');

-- -----------------------------------------------------
-- 3. Data for table `user` (Người dùng hệ thống)
-- Chúng ta cần tạo đủ Admin, Mentor và Mentee
-- -----------------------------------------------------
INSERT INTO `user` (`UserID`, `FullName`, `DateOfBirth`, `Gender`, `Phone`, `Email`, `Password`, `Role`) VALUES
-- 5 Admins
('admin01', 'Nguyễn Văn Quản Trị', '1990-01-01', 'M', '0901111111', 'admin1@hcmut.edu.vn', 'hashpass1', 'admin'),
('admin02', 'Lê Thị Admin', '1991-02-02', 'F', '0901111112', 'admin2@hcmut.edu.vn', 'hashpass2', 'admin'),
('admin03', 'Trần Văn Sếp', '1985-05-05', 'M', '0901111113', 'admin3@hcmut.edu.vn', 'hashpass3', 'admin'),
('admin04', 'Phạm Thị Tổ Trưởng', '1992-03-10', 'F', '0901111114', 'admin4@hcmut.edu.vn', 'hashpass4', 'admin'),
('admin05', 'Hoàng Văn Admin', '1993-12-12', 'M', '0901111115', 'admin5@hcmut.edu.vn', 'hashpass5', 'admin'),

-- 5 Mentors
('mentor01', 'Lê Văn Dạy Giỏi', '2002-01-01', 'M', '0902222221', 'mentor1@hcmut.edu.vn', 'hashpassM1', 'mentor'),
('mentor02', 'Nguyễn Thị Học Tốt', '2001-05-20', 'F', '0902222222', 'mentor2@hcmut.edu.vn', 'hashpassM2', 'mentor'),
('mentor03', 'Trần Tuấn Tú', '2000-11-11', 'M', '0902222223', 'mentor3@hcmut.edu.vn', 'hashpassM3', 'mentor'),
('mentor04', 'Phan Thị Minh', '2002-08-15', 'F', '0902222224', 'mentor4@hcmut.edu.vn', 'hashpassM4', 'mentor'),
('mentor05', 'Vũ Đức Đam', '1999-03-03', 'M', '0902222225', 'mentor5@hcmut.edu.vn', 'hashpassM5', 'mentor'),

-- 5 Mentees
('mentee01', 'Học Sinh A', '2005-01-01', 'M', '0903333331', 'mentee1@hcmut.edu.vn', 'hashpassS1', 'mentee'),
('mentee02', 'Học Sinh B', '2005-02-02', 'F', '0903333332', 'mentee2@hcmut.edu.vn', 'hashpassS2', 'mentee'),
('mentee03', 'Học Sinh C', '2005-03-03', 'M', '0903333333', 'mentee3@hcmut.edu.vn', 'hashpassS3', 'mentee'),
('mentee04', 'Học Sinh D', '2005-04-04', 'F', '0903333334', 'mentee4@hcmut.edu.vn', 'hashpassS4', 'mentee'),
('mentee05', 'Học Sinh E', '2005-05-05', 'M', '0903333335', 'mentee5@hcmut.edu.vn', 'hashpassS5', 'mentee');

-- -----------------------------------------------------
-- 6. Data for table `mentor`
-- -----------------------------------------------------
INSERT INTO `mentor` (`mentorID`, `GPA`, `FacultyID`, `job`, `sinh_vien_nam`) VALUES
('mentor01', 3.80, 1, 'sinh_vien', 'nam_3'),
('mentor02', 3.90, 1, 'sinh_vien', 'nam_4'),
('mentor03', 3.50, 2, 'sinh_vien', 'nam_3'),
('mentor04', 3.65, 1, 'nghien_cuu_sinh', 'none'),
('mentor05', 3.75, 3, 'sinh_vien', 'nam_2');

-- -----------------------------------------------------
-- 7. Data for table `tutor_application` (Đơn đăng ký làm mentor)
-- -----------------------------------------------------
INSERT INTO `tutor_application` (`applicationID`, `FullName`, `DateOfBirth`, `Gender`, `Phone`, `Email`, `Password`, `GPA`, `FacultyID`, `job`, `sinh_vien_nam`, `status`) VALUES
('app001', 'Người Đăng Ký 1', '2003-01-01', 'M', '0904444441', 'app1@email.com', 'pass1', 3.2, 1, 'sinh_vien', 'nam_3', 'waiting'),
('app002', 'Người Đăng Ký 2', '2003-02-02', 'F', '0904444442', 'app2@email.com', 'pass2', 3.5, 2, 'sinh_vien', 'nam_3', 'waiting'),
('app003', 'Người Đăng Ký 3', '2002-03-03', 'M', '0904444443', 'app3@email.com', 'pass3', 2.5, 3, 'sinh_vien', 'nam_4', 'waiting'),
('app004', 'Người Đăng Ký 4', '2001-04-04', 'F', '0904444444', 'app4@email.com', 'pass4', 3.8, 4, 'nghien_cuu_sinh', 'none', 'waiting'),
('app005', 'Người Đăng Ký 5', '2003-05-05', 'M', '0904444445', 'app5@email.com', 'pass5', 3.1, 5, 'sinh_vien', 'nam_2', 'waiting');

-- -----------------------------------------------------
-- 8. Data for table `enroll` (Mentor đăng ký dạy môn)
-- -----------------------------------------------------
INSERT INTO `enroll` (`enrollID`, `mentorID`, `status`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`) VALUES
(1, 'mentor01', 'waiting', 'Nhập môn Lập trình', 1, 3, 'H6-101', 'Thu Hai'),
(2, 'mentor01', 'waiting', 'Cấu trúc dữ liệu và Giải thuật', 7, 9, 'H6-102', 'Thu Tu'),
(3, 'mentor02', 'waiting', 'Hệ điều hành', 4, 6, 'B4-201', 'Thu Ba'),
(4, 'mentor03', 'waiting', 'Mạch điện 1', 1, 3, 'C4-301', 'Thu Nam'),
(5, 'mentor05', 'waiting', 'Cơ lý thuyết', 8, 10, 'C5-101', 'Thu Sau'),
(6, 'mentor04', 'waiting', 'Mạng máy tính', 1, 3, 'H1-101', 'Thu Bay');

-- -----------------------------------------------------
-- 9. Data for table `tutor_pair` (Lớp học thực tế)
-- -----------------------------------------------------
-- Lưu ý: pairID mapping với enrollID đã được accept ở trên
INSERT INTO `tutor_pair` (`pairID`, `enrollID`, `mentorID`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`, `mentee_capacity`, `mentee_current_count`) VALUES
(1, 1, 'mentor01', 'Nhập môn Lập trình', 1, 3, 'H6-101', 'Thu Hai', 20, 2),
(2, 2, 'mentor01', 'Cấu trúc dữ liệu và Giải thuật', 7, 9, 'H6-102', 'Thu Tu', 15, 1),
(3, 3, 'mentor02', 'Hệ điều hành', 4, 6, 'B4-201', 'Thu Ba', 20, 2),
(4, 5, 'mentor05', 'Cơ lý thuyết', 8, 10, 'C5-101', 'Thu Sau', 10, 0),
(5, 6, 'mentor04', 'Mạng máy tính', 1, 3, 'H1-101', 'Thu Bay', 15, 0);

-- -----------------------------------------------------
-- 10. Data for table `mentee_list` (Danh sách mentee trong lớp)
-- -----------------------------------------------------
INSERT INTO `mentee_list` (`pairID`, `menteeID`) VALUES
(1, 'mentee01'),
(1, 'mentee02'),
(2, 'mentee03'),
(3, 'mentee01'),
(3, 'mentee04');

-- -----------------------------------------------------
-- 11. Data for table `outline` (Đề cương/Tài liệu lớp học)
-- -----------------------------------------------------
INSERT INTO `outline` (`PairID`, `Name`, `Context`) VALUES
(1, 'Slide Bài 1', 'Giới thiệu về C++ và môi trường lập trình'),
(1, 'Bài tập tuần 1', 'Bài tập về biến và vòng lặp'),
(2, 'Syllabus', 'Đề cương môn Cấu trúc dữ liệu'),
(3, 'Lab 1 Guide', 'Hướng dẫn cài đặt Ubuntu cho môn Hệ điều hành'),
(5, 'Slide Chương 1', 'Mô hình OSI và TCP/IP');
-- -----------------------------------------------------
-- 13. Data for table `feedback_tutor` (Phản hồi về Mentor)
-- -----------------------------------------------------
INSERT INTO `feedback_tutor` (`mentorID`, `menteeID`, `Context`) VALUES
('mentor01', 'mentee01', 'Mentor giảng bài rất dễ hiểu, nhiệt tình.'),
('mentor01', 'mentee02', 'Thầy hỗ trợ giải bài tập rất chi tiết.'),
('mentor02', 'mentee01', 'Cô dạy hơi nhanh nhưng kiến thức rất chắc.'),
('mentor02', 'mentee04', 'Cần thêm nhiều ví dụ thực tế hơn.'),
('mentor05', 'mentee03', 'Mentor rất vui tính, lớp học không bị áp lực.');

-- Bật lại kiểm tra khóa ngoại sau khi đã insert xong
SET FOREIGN_KEY_CHECKS = 1;