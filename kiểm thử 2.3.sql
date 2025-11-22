USE hcmut_tutor;

-- ============================================================
-- 1. KIỂM THỬ: sp_search_subject_by_name
-- Mục đích: Tìm kiếm môn học theo tên chính xác hoặc trả về tất cả nếu rỗng.
-- ============================================================
SELECT '--- TEST 1: sp_search_subject_by_name ---' AS Title;

-- Case 1.1: Tìm kiếm chính xác tên môn học có tồn tại
-- Kết quả mong đợi: Trả về 1 dòng 'Nhập môn Lập trình'
CALL sp_search_subject_by_name('Nhập môn Lập trình');

-- Case 1.2: Tìm kiếm với tên rỗng hoặc NULL
-- Kết quả mong đợi: Trả về danh sách tất cả môn học hiện có trong bảng Subject
CALL sp_search_subject_by_name('');
CALL sp_search_subject_by_name(NULL);

-- Case 1.3: Tìm kiếm môn học không tồn tại
-- Kết quả mong đợi: Không trả về dòng nào
CALL sp_search_subject_by_name('Môn học ảo');


-- ============================================================
-- 2. KIỂM THỬ: sp_select_tutor_pair_by_subject
-- Mục đích: Lấy danh sách lớp học (kèm tên Mentor) của một môn.
-- ============================================================
SELECT '--- TEST 2: sp_select_tutor_pair_by_subject ---' AS Title;

-- Case 2.1: Lấy danh sách lớp của môn có người dạy
-- Kết quả mong đợi: Trả về thông tin pairID=1, mentor=Admin01... (dựa trên data mẫu)
CALL sp_select_tutor_pair_by_subject('Nhập môn Lập trình');

-- Case 2.2: Lấy danh sách lớp của môn chưa có ai mở lớp
-- Dữ liệu mẫu: 'Sức bền vật liệu' có trong bảng Subject nhưng chưa có trong Tutor_pair
-- Kết quả mong đợi: Không trả về dòng nào
CALL sp_select_tutor_pair_by_subject('Sức bền vật liệu');


-- ============================================================
-- 3. KIỂM THỬ: sp_check_mentee_enrollment
-- Mục đích: Kiểm tra xem Mentee đã học môn này (bất kỳ lớp nào) chưa.
-- ============================================================
SELECT '--- TEST 3: sp_check_mentee_enrollment ---' AS Title;

-- Case 3.1: Mentee đã đăng ký môn này
-- Dữ liệu mẫu: mentee01 đã đăng ký pairID=1 (Nhập môn Lập trình)
-- Kết quả mong đợi: Trả về pairID = 1
CALL sp_check_mentee_enrollment('mentee01', 'Nhập môn Lập trình');

-- Case 3.2: Mentee chưa đăng ký môn này
-- Dữ liệu mẫu: mentee01 chưa học 'Mạng máy tính'
-- Kết quả mong đợi: Không trả về dòng nào (Empty set)
CALL sp_check_mentee_enrollment('mentee01', 'Mạng máy tính');


-- ============================================================
-- 4. KIỂM THỬ: usp_DangKyLopHocMentee
-- Mục đích: Đăng ký lớp, xử lý trùng lịch, chuyển lớp và check sĩ số.
-- Lưu ý: Thủ tục này thay đổi dữ liệu, ta dùng mentee05 (đang rảnh) để test.
-- ============================================================
SELECT '--- TEST 4: usp_DangKyLopHocMentee ---' AS Title;

-- --- CHUẨN BỊ DỮ LIỆU GIẢ LẬP ĐỂ TEST CÁC CASE KHÓ ---
-- Tạo thêm một lớp 'Nhập môn Lập trình' khác (pairID giả định 99) vào Thứ 2, Tiết 7-9 để test chuyển lớp
INSERT INTO `tutor_pair` (`pairID`, `enrollID`, `mentorID`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`, `mentee_capacity`, `mentee_current_count`) 
VALUES (99, 1, 'mentor01', 'Nhập môn Lập trình', 7, 9, 'Online', 'Thu Hai', 20, 0);

-- Tạo một lớp 'Môn Xung Đột' (pairID giả định 100) vào Thứ 2, Tiết 1-3 (Trùng giờ với pairID 1)
INSERT INTO `subject` VALUES (1, 'Môn Xung Đột');
INSERT INTO `tutor_pair` (`pairID`, `enrollID`, `mentorID`, `Subject_name`, `begin_session`, `end_session`, `location`, `day`, `mentee_capacity`, `mentee_current_count`) 
VALUES (100, 1, 'mentor01', 'Môn Xung Đột', 1, 3, 'H6-999', 'Thu Hai', 20, 0);


-- Case 4.1: Đăng ký mới thành công
-- Tình huống: mentee05 đăng ký lớp pairID=1 (Nhập môn Lập trình, T2, 1-3)
-- Kết quả mong đợi: Thành công, không báo lỗi. Kiểm tra bảng mentee_list thấy có dữ liệu.
CALL usp_DangKyLopHocMentee(1, 'mentee05');
SELECT * FROM mentee_list WHERE menteeID = 'mentee05'; 


-- Case 4.2: Lỗi trùng lịch (Conflict Time)
-- Tình huống: mentee05 đang học pairID=1 (T2, 1-3). Giờ cố đăng ký pairID=100 (Môn Xung Đột, cũng T2, 1-3).
-- Kết quả mong đợi: Báo lỗi "Lỗi: Trùng lịch học với lớp khác!"
CALL usp_DangKyLopHocMentee(100, 'mentee05');


-- Case 4.3: Chuyển lớp (Switch Class - Cùng môn, khác giờ)
-- Tình huống: mentee05 đang học pairID=1 (Nhập môn Lập trình). Giờ muốn chuyển sang pairID=99 (cũng Nhập môn Lập trình, T2, 7-9).
-- Logic: Hệ thống phải XÓA pairID=1 khỏi mentee_list và THÊM pairID=99.
-- Kết quả mong đợi: Thành công. mentee05 chỉ còn học lớp 99, không còn lớp 1.
CALL usp_DangKyLopHocMentee(99, 'mentee05');
SELECT * FROM mentee_list WHERE menteeID = 'mentee05';


-- Case 4.4: Lỗi quá sĩ số (Capacity Full)
-- Tình huống: Set lớp pairID=99 về capacity = 1, hiện tại đã có mentee05 (từ case 4.3).
-- Thử dùng mentee02 đăng ký vào lớp 99 này.
-- Kết quả mong đợi: Báo lỗi từ Trigger "Lỗi: Lớp học này đã đủ sĩ số..."
UPDATE tutor_pair SET mentee_capacity = 1, mentee_current_count = 1 WHERE pairID = 99;
CALL usp_DangKyLopHocMentee(99, 'mentee02');


-- --- DỌN DẸP DỮ LIỆU SAU KHI TEST (CLEAN UP) ---
DELETE FROM mentee_list WHERE menteeID = 'mentee05';
DELETE FROM tutor_pair WHERE pairID IN (99, 100);
DELETE FROM subject WHERE Subject_name = 'Môn Xung Đột';