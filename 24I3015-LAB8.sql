-- Create the Tables
CREATE TABLE Courses (
    CourseId INT PRIMARY KEY,
    CourseTitle VARCHAR(100),
    Instructor VARCHAR(100),
    Credits INT,
    Fee DECIMAL(10,2)
);

CREATE TABLE Students (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(100),
    Status VARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentId INT PRIMARY KEY,
    Course_id INT,
    Student_id INT,
    EnrollDate DATE,
    CompletionDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Course_id) REFERENCES Courses(CourseId),
    FOREIGN KEY (Student_id) REFERENCES Students(StudentId)
);

-- Insert at least 3-4 records into each table
INSERT INTO Courses (CourseId, CourseTitle, Instructor, Credits, Fee) VALUES
(1, 'Database Systems', 'Dr Ahmed', 3, 12000),
(2, 'Web Development', 'Ms Sara', 3, 10000),
(3, 'Machine Learning', 'Dr Ali', 4, 15000),
(4, 'Data Structures', 'Dr Ali', 3, 11000);

INSERT INTO Students (StudentId, Name, Email, City, Status) VALUES
(301, 'Ali Khan', 'ali@gmail.com', 'Lahore', 'Active'),
(302, 'Sara Ahmed', 'sara@yahoo.com', 'Karachi', 'Active'),
(303, 'John Lee', 'john@yahoo.com', NULL, 'Inactive'),
(304, 'Omer Tariq', 'omer@gmail.com', 'Lahore', 'Inactive');

INSERT INTO Enrollments (EnrollmentId, Course_id, Student_id, EnrollDate, CompletionDate, Status) VALUES
(1, 1, 301, '2025-01-10', NULL, 'Enrolled'),
(2, 2, 302, '2025-01-15', NULL, 'Enrolled'),
(3, 3, 301, '2025-02-01', NULL, 'Pending'),
(4, 1, 304, '2025-01-10', '2025-06-01', 'Completed');

-- Run the Following Queries

-- 1. Display CourseTitle, Instructor, and Fee where Fee > 10000, ordered by Fee descending.
SELECT CourseTitle, Instructor, Fee 
FROM Courses 
WHERE Fee > 10000 
ORDER BY Fee DESC;

-- 2. Retrieve courses where Instructor IN ('Dr Ahmed','Dr Ali') AND Credits >= 3.
SELECT * FROM Courses 
WHERE Instructor IN ('Dr Ahmed', 'Dr Ali') AND Credits >= 3;

-- 3. Display course titles starting with 'D' or containing 'Data'.
SELECT CourseTitle 
FROM Courses 
WHERE CourseTitle LIKE 'D%' OR CourseTitle LIKE '%Data%';

-- 4. Display students whose City is NULL OR Status = 'Inactive'.
SELECT * FROM Students 
WHERE City IS NULL OR Status = 'Inactive';

-- 5. Display student names and enrolled course titles using INNER JOIN with table aliases.
SELECT S.Name, C.CourseTitle 
FROM Students S
INNER JOIN Enrollments E ON S.StudentId = E.Student_id
INNER JOIN Courses C ON E.Course_id = C.CourseId;

-- 6. Retrieve students who are enrolled in any course using EXISTS.
SELECT * FROM Students S
WHERE EXISTS (
    SELECT * FROM Enrollments E 
    WHERE E.Student_id = S.StudentId
);

-- 7. Retrieve students who are not enrolled in any course using NOT EXISTS.
SELECT * FROM Students S
WHERE NOT EXISTS (
    SELECT * FROM Enrollments E 
    WHERE E.Student_id = S.StudentId
);

-- 8. Retrieve students who are enrolled in courses taught by 'Dr Ahmed' using a nested subquery.
SELECT * FROM Students 
WHERE StudentId IN (
    SELECT Student_id 
    FROM Enrollments 
    WHERE Course_id IN (
        SELECT CourseId 
        FROM Courses 
        WHERE Instructor = 'Dr Ahmed'
    )
);

-- 9. Retrieve course titles in which students from Lahore are enrolled using IN with a subquery.
SELECT CourseTitle 
FROM Courses 
WHERE CourseId IN (
    SELECT Course_id 
    FROM Enrollments 
    WHERE Student_id IN (
        SELECT StudentId 
        FROM Students 
        WHERE City = 'Lahore'
    )
);

-- 10. Update course Fee by increasing 5% only for courses taught by 'Dr Ahmed'.
UPDATE Courses 
SET Fee = Fee * 1.05 
WHERE Instructor = 'Dr Ahmed';

-- 11. Delete records from Enrollments where Status = 'Completed' OR CompletionDate IS NOT NULL.
DELETE FROM Enrollments 
WHERE Status = 'Completed' OR CompletionDate IS NOT NULL;

-- Data Transfer Task

-- Create table ArchivedStudents
CREATE TABLE ArchivedStudents (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(100)
);

-- Transfer students whose Status = 'Inactive' OR City IS NULL into this table.
INSERT INTO ArchivedStudents (StudentId, Name, Email, City)
SELECT StudentId, Name, Email, City
FROM Students
WHERE Status = 'Inactive' OR City IS NULL;

-- Deletion Task

-- Delete all inactive students from Students table only if they exist in ArchivedStudents table.
DELETE FROM Students
WHERE Status = 'Inactive' 
AND EXISTS (
    SELECT 1 
    FROM ArchivedStudents A 
    WHERE A.StudentId = Students.StudentId
);-- Create the Tables
CREATE TABLE Courses (
    CourseId INT PRIMARY KEY,
    CourseTitle VARCHAR(100),
    Instructor VARCHAR(100),
    Credits INT,
    Fee DECIMAL(10,2)
);

CREATE TABLE Students (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(100),
    Status VARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentId INT PRIMARY KEY,
    Course_id INT,
    Student_id INT,
    EnrollDate DATE,
    CompletionDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Course_id) REFERENCES Courses(CourseId),
    FOREIGN KEY (Student_id) REFERENCES Students(StudentId)
);

-- Insert at least 3-4 records into each table
INSERT INTO Courses (CourseId, CourseTitle, Instructor, Credits, Fee) VALUES
(1, 'Database Systems', 'Dr Ahmed', 3, 12000),
(2, 'Web Development', 'Ms Sara', 3, 10000),
(3, 'Machine Learning', 'Dr Ali', 4, 15000),
(4, 'Data Structures', 'Dr Ali', 3, 11000);

INSERT INTO Students (StudentId, Name, Email, City, Status) VALUES
(301, 'Ali Khan', 'ali@gmail.com', 'Lahore', 'Active'),
(302, 'Sara Ahmed', 'sara@yahoo.com', 'Karachi', 'Active'),
(303, 'John Lee', 'john@yahoo.com', NULL, 'Inactive'),
(304, 'Omer Tariq', 'omer@gmail.com', 'Lahore', 'Inactive');

INSERT INTO Enrollments (EnrollmentId, Course_id, Student_id, EnrollDate, CompletionDate, Status) VALUES
(1, 1, 301, '2025-01-10', NULL, 'Enrolled'),
(2, 2, 302, '2025-01-15', NULL, 'Enrolled'),
(3, 3, 301, '2025-02-01', NULL, 'Pending'),
(4, 1, 304, '2025-01-10', '2025-06-01', 'Completed');

-- Run the Following Queries

-- 1. Display CourseTitle, Instructor, and Fee where Fee > 10000, ordered by Fee descending.
SELECT CourseTitle, Instructor, Fee 
FROM Courses 
WHERE Fee > 10000 
ORDER BY Fee DESC;

-- 2. Retrieve courses where Instructor IN ('Dr Ahmed','Dr Ali') AND Credits >= 3.
SELECT * FROM Courses 
WHERE Instructor IN ('Dr Ahmed', 'Dr Ali') AND Credits >= 3;

-- 3. Display course titles starting with 'D' or containing 'Data'.
SELECT CourseTitle 
FROM Courses 
WHERE CourseTitle LIKE 'D%' OR CourseTitle LIKE '%Data%';

-- 4. Display students whose City is NULL OR Status = 'Inactive'.
SELECT * FROM Students 
WHERE City IS NULL OR Status = 'Inactive';

-- 5. Display student names and enrolled course titles using INNER JOIN with table aliases.
SELECT S.Name, C.CourseTitle 
FROM Students S
INNER JOIN Enrollments E ON S.StudentId = E.Student_id
INNER JOIN Courses C ON E.Course_id = C.CourseId;

-- 6. Retrieve students who are enrolled in any course using EXISTS.
SELECT * FROM Students S
WHERE EXISTS (
    SELECT * FROM Enrollments E 
    WHERE E.Student_id = S.StudentId
);

-- 7. Retrieve students who are not enrolled in any course using NOT EXISTS.
SELECT * FROM Students S
WHERE NOT EXISTS (
    SELECT * FROM Enrollments E 
    WHERE E.Student_id = S.StudentId
);

-- 8. Retrieve students who are enrolled in courses taught by 'Dr Ahmed' using a nested subquery.
SELECT * FROM Students 
WHERE StudentId IN (
    SELECT Student_id 
    FROM Enrollments 
    WHERE Course_id IN (
        SELECT CourseId 
        FROM Courses 
        WHERE Instructor = 'Dr Ahmed'
    )
);

-- 9. Retrieve course titles in which students from Lahore are enrolled using IN with a subquery.
SELECT CourseTitle 
FROM Courses 
WHERE CourseId IN (
    SELECT Course_id 
    FROM Enrollments 
    WHERE Student_id IN (
        SELECT StudentId 
        FROM Students 
        WHERE City = 'Lahore'
    )
);

-- 10. Update course Fee by increasing 5% only for courses taught by 'Dr Ahmed'.
UPDATE Courses 
SET Fee = Fee * 1.05 
WHERE Instructor = 'Dr Ahmed';

-- 11. Delete records from Enrollments where Status = 'Completed' OR CompletionDate IS NOT NULL.
DELETE FROM Enrollments 
WHERE Status = 'Completed' OR CompletionDate IS NOT NULL;

-- Data Transfer Task

-- Create table ArchivedStudents
CREATE TABLE ArchivedStudents (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(100)
);

-- Transfer students whose Status = 'Inactive' OR City IS NULL into this table.
INSERT INTO ArchivedStudents (StudentId, Name, Email, City)
SELECT StudentId, Name, Email, City
FROM Students
WHERE Status = 'Inactive' OR City IS NULL;

-- Deletion Task

-- Delete all inactive students from Students table only if they exist in ArchivedStudents table.
DELETE FROM Students
WHERE Status = 'Inactive' 
AND EXISTS (
    SELECT 1 
    FROM ArchivedStudents A 
    WHERE A.StudentId = Students.StudentId
);