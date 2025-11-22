USE hcmut_tutor;

-- Xóa dữ liệu cũ nếu có để tránh lỗi trùng lặp
DELETE FROM enroll;
DELETE FROM mentor;
DELETE FROM user;
DELETE FROM subject;
DELETE FROM faculty;

-- 1. Tạo Khoa (Faculty)
INSERT INTO faculty (FacultyID, Faculty_name) VALUES 
(1, 'Khoa Hoc May Tinh'), 
(2, 'Dien - Dien Tu');

-- 2. Tạo Môn học (Subject) - Ràng buộc FacultyID
INSERT INTO subject (FacultyID, Subject_name) VALUES 
(1, 'Lap Trinh C++'), 
(1, 'Cau Truc Du Lieu'),
(2, 'Mach Dien');

-- 3. Tạo User (Role = mentor)
INSERT INTO user (UserID, FullName, DateOfBirth, Gender, Phone, Email, Password, Role) VALUES 
('MENTOR01', 'Nguyen Van A', '2000-01-01', 'M', '0901234567', 'a@test.com', '123', 'mentor');

-- 4. Tạo Mentor (Liên kết với UserID và FacultyID = 1)
INSERT INTO mentor (mentorID, GPA, FacultyID, job, sinh_vien_nam) VALUES 
('MENTOR01', 3.5, 1, 'sinh_vien', 'nam_3');