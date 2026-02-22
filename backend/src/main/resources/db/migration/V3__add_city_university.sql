-- =============================================
-- V3__add_city_university.sql
-- Add city to users, university_name to student_profiles
-- Update college names to Arabic
-- =============================================

-- 1. Add city column to users
ALTER TABLE users ADD COLUMN city VARCHAR(255);

-- 2. Add university_name column to student_profiles
ALTER TABLE student_profiles ADD COLUMN university_name VARCHAR(255);

-- 3. Update college names to Arabic
UPDATE colleges SET name = 'كلية الهندسة'          WHERE id = '00000000-0000-0000-0000-000000000101';
UPDATE colleges SET name = 'كلية العلوم'           WHERE id = '00000000-0000-0000-0000-000000000102';
UPDATE colleges SET name = 'كلية إدارة الأعمال'    WHERE id = '00000000-0000-0000-0000-000000000103';
UPDATE colleges SET name = 'كلية الطب'             WHERE id = '00000000-0000-0000-0000-000000000104';
UPDATE colleges SET name = 'كلية الآداب'           WHERE id = '00000000-0000-0000-0000-000000000105';

-- 4. Add more colleges
INSERT INTO colleges (id, name) VALUES
    ('00000000-0000-0000-0000-000000000106', 'كلية الحاسب الآلي ونظم المعلومات'),
    ('00000000-0000-0000-0000-000000000107', 'كلية الشريعة'),
    ('00000000-0000-0000-0000-000000000108', 'كلية العلوم التطبيقية'),
    ('00000000-0000-0000-0000-000000000109', 'كلية التربية'),
    ('00000000-0000-0000-0000-000000000110', 'كلية الأنظمة');

-- 5. Update seed users with sample city values
UPDATE users SET city = 'مكة المكرمة' WHERE id = '00000000-0000-0000-0000-000000000001';
UPDATE users SET city = 'مكة المكرمة' WHERE id = '00000000-0000-0000-0000-000000000002';
UPDATE users SET city = 'جدة'         WHERE id = '00000000-0000-0000-0000-000000000003';

-- 6. Update student profile with university name
UPDATE student_profiles SET university_name = 'جامعة أم القرى'
    WHERE user_id = '00000000-0000-0000-0000-000000000002';
