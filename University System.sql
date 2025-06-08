USE [master];
GO

/*** This is the order to drop tables that doesn't violate the foreign key constraints***/

DROP TABLE IF EXISTS CourseInstructors;
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;


/****** Object:  Database [University] ******/
CREATE DATABASE [University]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'University', FILENAME = N'G:\Advanced db.mdf' , 
  SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'University_log', FILENAME = N'G:\Advanced db.ldf' , 
  SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT;
GO

ALTER DATABASE [University] SET COMPATIBILITY_LEVEL = 150;
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
    EXEC [University].[dbo].[sp_fulltext_database] @action = 'enable';
END;
GO

-- Set database properties
ALTER DATABASE [University] SET ANSI_NULL_DEFAULT OFF;
ALTER DATABASE [University] SET ANSI_NULLS OFF;
ALTER DATABASE [University] SET ANSI_PADDING OFF;
ALTER DATABASE [University] SET ANSI_WARNINGS OFF;
ALTER DATABASE [University] SET AUTO_CLOSE OFF;
ALTER DATABASE [University] SET AUTO_SHRINK OFF;
ALTER DATABASE [University] SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE [University] SET PAGE_VERIFY CHECKSUM;
ALTER DATABASE [University] SET RECOVERY FULL;
ALTER DATABASE [University] SET MULTI_USER;
GO

USE [University];
GO

-- Create User for the Database
CREATE USER [Shahd] FOR LOGIN [new_login] WITH DEFAULT_SCHEMA=[dbo];
GO

ALTER ROLE [db_owner] ADD MEMBER [Shahd];
GO


-- Enable messages
SET NOCOUNT ON;
GO

-- Create tables

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) UNIQUE
);
GO

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE , 
	DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO 

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
	CreditsHours INT,
	CGPA DECIMAL(5,2),
	DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100),
	Credits INT ,
    CourseCapacity INT , 
	CourseFee DECIMAL(5, 2) , 
	PrerequisiteCourseID INT NULL,
    FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID)
);
GO

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
	EnrollmentFee DECIMAL (5,2) ,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

CREATE TABLE CourseInstructors (
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),
    InstructorID INT,
    CourseID INT,
    Semester NVARCHAR(20),
    Year INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    EnrollmentID INT,
    Grade DECIMAL(5,2),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE CASCADE
);
GO


--Populate the tables
--Insert Data into Department Table
INSERT INTO Departments (DepartmentName) VALUES ('CyperSecurity');
INSERT INTO Departments (DepartmentName) VALUES ('Data Science');
INSERT INTO Departments (DepartmentName) VALUES ('Intelligent Systems');
INSERT INTO Departments (DepartmentName) VALUES ('Health Care');
INSERT INTO Departments (DepartmentName) VALUES ('Business analytics');

--Insert Data into Instructors table
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Samantha', 'Paul', 'anna78@example.net', 5);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Kathleen', 'Wiggins', 'nathan71@example.org', 1);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Nancy', 'Campbell', 'deniserosario@example.org', 2);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Melissa', 'Jackson', 'ksmith@example.com', 3);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Eric', 'Lindsey', 'rcarson@example.com', 4);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Jessica', 'Williams', 'ojones@example.org', 5);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('James', 'Roberts', 'jessica64@example.org', 2);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Nicole', 'Smith', 'kevinwilliams@example.com', 3);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Michael', 'Walker', 'shawnmoore@example.com', 1);
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES ('Christopher', 'Kim', 'browncaroline@example.com', 5);

--Insert Data into Students table
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA, DepartmentID) VALUES ('Anthony', 'Garcia', 22, 4, 5);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA ,DepartmentID) VALUES ('Tyler', 'Garcia', 19, 3.5, 3);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Joseph', 'Thompson', 17, 1, 3);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Vincent', 'Vaughn', 16, 3, 2);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Noah', 'Rodriguez', 22, 2, 3);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Alexander', 'Ochoa', 14, 4, 1);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Nathan', 'Young', 16, 3.5, 3);
INSERT INTO Students (FirstName, LastName, CreditsHours, CGPA , DepartmentID) VALUES ('Julia', 'Farmer', 14, 1, 3);

--Insert Data to Courses table
INSERT INTO Courses (CourseName, Credits, CourseCapacity, CourseFee, PrerequisiteCourseID) VALUES ('convex optimization', 4, 5 , 358.84, NULL);
INSERT INTO Courses (CourseName, Credits, CourseCapacity, CourseFee, PrerequisiteCourseID) VALUES ('regression analysis', 3, 7, 806.26, 1);
INSERT INTO Courses (CourseName, Credits, CourseCapacity, CourseFee, PrerequisiteCourseID) VALUES ('programming II', 4, 4, 234.9, NULL);
INSERT INTO Courses (CourseName, Credits, CourseCapacity, CourseFee, PrerequisiteCourseID) VALUES ('linear algebra', 5, 3, 812.6, 1);
INSERT INTO Courses (CourseName, Credits, CourseCapacity, CourseFee, PrerequisiteCourseID) VALUES ('numerical computations', 3, 8, 576.66, 4);

--Insert Data to CourseInstructors table
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (1 , 4, 'Summer', 2024);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (1 , 3, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (1 , 5, 'Spring', 2024);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (2 , 2, 'Fall', 2024);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (3 , 1, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (4 , 2, 'Spring', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (5 , 3, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (6 , 3, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (7 , 2, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (8 , 3, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (9 , 5, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (10 , 4, 'Fall', 2023);
INSERT INTO CourseInstructors (InstructorID,CourseID, Semester, Year) VALUES (10 , 1, 'Fall', 2023);

--Insert Data to Enrollments Table
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (1, 4, '2025-02-02', 812.6);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (1, 2, '2024-02-20', 806.26);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (2, 1, '2024-05-11', 358.84);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (2, 2, '2024-08-21', 358.84);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (3, 4, '2024-05-04', 812.6);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (3, 5, '2024-02-27', 576.66);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (4, 2, '2024-05-07', 806.26);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (4, 5, '2024-05-05', 576.66);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (5, 4, '2024-07-12', 812.6);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (5, 3, '2024-01-10', 234.9);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (6, 1, '2023-07-23', 234.9);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (7, 5, '2023-12-19', 576.66);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (7, 1, '2024-09-08', 576.66);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (8, 5, '2024-09-22', 576.66);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (8, 3, '2023-06-17', 234.9);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (3, 4, '2024-01-27', 812.6);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (4, 3, '2024-06-22', 234.9);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (8, 4, '2024-09-04', 234.9);
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee) VALUES (8, 2, '2024-07-20', 812.6);



--Insert Data to Grades Table
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (1, 4);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (2, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (3, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (4, 3);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (5, 3);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (6, 3.5);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (7, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (8, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (9, 3.5);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (10, 4);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (11, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (12, 4);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (13, 3.5);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (14, 4);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (15, 1);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (16, 2);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (17, 3.5);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (18, 2);
INSERT INTO Grades ( EnrollmentID, Grade) VALUES (19, 4);

SELECT * FROM Grades;
/*****************************   Member1_Task   *****************************/
-- Find the average grade for each course, grouped by the course name
SELECT 
    C.CourseName, 
    AVG(G.Grade) AS AverageGrade
FROM 
    Courses C
JOIN 
    Enrollments E ON C.CourseID = E.CourseID
JOIN 
    Grades G ON E.EnrollmentID = G.EnrollmentID
GROUP BY 
    C.CourseName;
GO

/********************************************************************************************/

---List the instructors who are teaching more than 1 course
SELECT 
    I.FirstName AS InstructorFirstName, 
    I.LastName AS InstructorLastName, 
    COUNT(CI.CourseID) AS CoursesAssigned
FROM 
    Instructors I
JOIN 
    CourseInstructors CI ON I.InstructorID = CI.InstructorID
GROUP BY 
    I.InstructorID, I.FirstName, I.LastName
HAVING 
    COUNT(CI.CourseID) > 1;
GO

/********************************************************************************************/

--Find the number of students enrolled in each course
SELECT 
    C.CourseName, 
    COUNT(E.StudentID) AS NumberOfStudents
FROM 
    Courses C
LEFT JOIN 
    Enrollments E ON C.CourseID = E.CourseID
GROUP BY 
    C.CourseName;
GO

/********************************************************************************************/

--Find the students with the highest grade in each course
SELECT 
    S.FirstName AS StudentFirstName, 
    S.LastName AS StudentLastName, 
    C.CourseName, 
    G.Grade
FROM 
    Students S
JOIN 
    Enrollments E ON S.StudentID = E.StudentID
JOIN 
    Courses C ON E.CourseID = C.CourseID
JOIN 
    Grades G ON E.EnrollmentID = G.EnrollmentID
WHERE 
    G.Grade = (
        SELECT MAX(G2.Grade)
        FROM Grades G2
        JOIN Enrollments E2 ON G2.EnrollmentID = E2.EnrollmentID
        JOIN Courses C2 ON E2.CourseID = C2.CourseID
        WHERE C2.CourseID = C.CourseID
    );
GO

/********************************************************************************************/

-- Find the students who have enrolled in the most number of courses
SELECT 
    S.FirstName AS StudentFirstName, 
    S.LastName AS StudentLastName, 
    COUNT(E.CourseID) AS NumberOfCourses
FROM 
    Students S
JOIN 
    Enrollments E ON S.StudentID = E.StudentID
GROUP BY 
    S.StudentID, S.FirstName, S.LastName
HAVING 
    COUNT(E.CourseID) = (
        SELECT MAX(CourseCount)
        FROM (
            SELECT COUNT(E2.CourseID) AS CourseCount
            FROM Enrollments E2
            GROUP BY E2.StudentID
        ) AS Subquery
    );
GO 

/********************************************************************************************/

--StudentProgress_view
CREATE VIEW StudentProgress AS 
SELECT 
    S.StudentID,
    S.FirstName AS StudentFirstName,
    S.LastName AS StudentLastName,
    C.CourseName,
    CI.Semester,
    CI.Year,
    G.Grade,
    I.FirstName AS InstructorFirstName,
    I.LastName AS InstructorLastName
FROM 
    Students S
JOIN 
    Enrollments E ON S.StudentID = E.StudentID
JOIN 
    Courses C ON E.CourseID = C.CourseID
JOIN 
    Grades G ON E.EnrollmentID = G.EnrollmentID
JOIN 
    CourseInstructors CI ON C.CourseID = CI.CourseID
JOIN 
    Instructors I ON CI.InstructorID = I.InstructorID;
GO

--Usage
SELECT * FROM StudentProgress
WHERE StudentFirstName = 'Joseph';
GO

/********************************************************************************************/

--InstructorLoad
CREATE VIEW InstructorLoad AS
SELECT 
    I.InstructorID,
    I.FirstName AS InstructorFirstName,
    I.LastName AS InstructorLastName,
    CI.Semester,
    CI.Year,
    COUNT(CI.CourseID) AS NumberOfCourses
FROM 
    Instructors I
JOIN 
    CourseInstructors CI ON I.InstructorID = CI.InstructorID
GROUP BY 
    I.InstructorID, I.FirstName, I.LastName, CI.Semester, CI.Year;
GO

--Usage
SELECT * FROM InstructorLoad WHERE Year = 2023 AND Semester = 'Fall';
Go

/*************************** Member2_Task ******************************/
--Stored Procedures 
--Procedure to check if the student grade is A or B+ make a course discount
CREATE PROCEDURE WithDiscount
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @EligibleForDiscount BIT = 0;
        DECLARE @CourseFee DECIMAL(5,2);
        DECLARE @DiscountedFee DECIMAL(5,2);
        DECLARE @CGPA DECIMAL(3,2);

        -- Check if the student is already enrolled in the course
        IF EXISTS (
            SELECT 1
            FROM Enrollments
            WHERE StudentID = @StudentID AND CourseID = @CourseID
        )
        BEGIN
            PRINT 'The course has been already enrolled';
            RETURN;
        END

        -- Get the student's CGPA
        SELECT @CGPA = CGPA
        FROM Students
        WHERE StudentID = @StudentID;

        IF @CGPA IS NULL
        BEGIN
            RAISERROR('Student not found or CGPA not available.', 16, 1);
            RETURN;
        END

        -- Check CGPA eligibility (e.g., CGPA >= 3.5)
        IF @CGPA >= 3.5
        BEGIN
            SET @EligibleForDiscount = 1;
        END

        -- Get the course fee
        SELECT @CourseFee = CourseFee
        FROM Courses
        WHERE CourseID = @CourseID;

        IF @CourseFee IS NULL
        BEGIN
            RAISERROR('Invalid CourseID. Course not found.', 16, 1);
            RETURN;
        END

        -- Apply discount if eligible
        IF @EligibleForDiscount = 1
        BEGIN
            SET @DiscountedFee = @CourseFee * 0.90;  -- 10% discount
        END
        ELSE
        BEGIN
            SET @DiscountedFee = @CourseFee;
        END

        -- Insert into Enrollments table
        INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
        VALUES (@StudentID, @CourseID, GETDATE(), @DiscountedFee);

        PRINT 'Enrollment successful.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred during enrollment:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


--Usage 
EXEC WithDiscount @StudentID = 1, @CourseID = 3;
GO

--check for another student
EXEC WithDiscount @StudentID = 3, @CourseID = 3;
GO

SELECT * FROM  Enrollments ;
GO

/********************************************************************************************/

-- Procedure to update course fee with validation
CREATE PROCEDURE UpdateCourseFee 
    @CourseID INT,
    @NewFee DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        --Check if course exists
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            RAISERROR('Course does not exist!', 16, 1);
        END

        --Check if fee is non-negative
        ELSE IF @NewFee < 0
        BEGIN
            RAISERROR('Fee cannot be negative!', 16, 1);
        END

        -- Perform the update
        ELSE
        BEGIN
            UPDATE Courses 
            SET CourseFee = @NewFee 
            WHERE CourseID = @CourseID;

            PRINT 'Update completed';
        END
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred during the update:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

--check befode update
SELECT * FROM Courses WHERE CourseID = 5 ;
GO

-- Usage:
EXEC UpdateCourseFee @CourseID = 5, @NewFee = 250.00;
GO

--check after update
SELECT * FROM Courses WHERE CourseID = 5 ;
GO

/********************************************************************************************/

--check if a student has completed a course prerequisite before enrolling it 
CREATE PROCEDURE EnrollStudentWithPrerequisiteCheck
    @StudentID INT,
    @CourseID INT,
    @StatusMessage NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @PrereqCourseID INT;
        DECLARE @HasCompletedPrereq BIT = 0;
        DECLARE @CourseFee DECIMAL(5,2);

        -- Get the prerequisite course ID (can be NULL)
        SELECT @PrereqCourseID = PrerequisiteCourseID
        FROM Courses
        WHERE CourseID = @CourseID;

        IF @PrereqCourseID IS NULL
        BEGIN
            -- No prerequisite required
            SET @HasCompletedPrereq = 1;
        END
        ELSE
        BEGIN
            -- Check if the student has completed the prerequisite course (has a grade)
            IF EXISTS (
                SELECT 1
                FROM Enrollments e
                JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
                WHERE e.StudentID = @StudentID AND e.CourseID = @PrereqCourseID
            )
            BEGIN
                SET @HasCompletedPrereq = 1;
            END
        END

        IF @HasCompletedPrereq = 0
        BEGIN
            SET @StatusMessage = 'You have not completed the course prerequisite yet';
            RETURN;
        END

        -- Check if already enrolled
        IF EXISTS (
            SELECT 1
            FROM Enrollments
            WHERE StudentID = @StudentID AND CourseID = @CourseID
        )
        BEGIN
            SET @StatusMessage = 'You are already enrolled in this course';
            RETURN;
        END

        -- Get Course Fee
        SELECT @CourseFee = CourseFee
        FROM Courses
        WHERE CourseID = @CourseID;

        IF @CourseFee IS NULL
        BEGIN
            SET @StatusMessage = 'Invalid Course ID';
            RETURN;
        END

        -- Enroll student
        INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
        VALUES (@StudentID, @CourseID, GETDATE(), @CourseFee);

        SET @StatusMessage = 'Enrollment successful';
    END TRY
    BEGIN CATCH
        SET @StatusMessage = 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--Usage
DECLARE @Msg NVARCHAR(200);
EXEC EnrollStudentWithPrerequisiteCheck @StudentID = 2, @CourseID = 4, @StatusMessage = @Msg OUTPUT;
PRINT @Msg;
GO

--check for another student
DECLARE @Msg NVARCHAR(200);
EXEC EnrollStudentWithPrerequisiteCheck @StudentID = 6, @CourseID = 5, @StatusMessage = @Msg OUTPUT;
PRINT @Msg;
GO

SELECT * FROM Enrollments;
GO

/********************************************************************************************/

--Functions
--Get the students enrolled in a specific department 
CREATE FUNCTION GetStudentsInDepartment
(
    @DepartmentID INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @StudentList NVARCHAR(MAX);

    SELECT @StudentList = STRING_AGG(FirstName + ' ' + LastName, ', ')
    FROM Students
    WHERE DepartmentID = @DepartmentID;

    RETURN ISNULL(@StudentList, 'No students found');
END;
GO

--Usage
SELECT dbo.GetStudentsInDepartment(3) AS EnrolledStudents;
GO

/********************************************************************************************/

--Get student total spending
CREATE FUNCTION GetStudentTotalSpending
(
    @StudentID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalSpending DECIMAL(10, 2);

    -- Calculate total spending by summing up the EnrollmentFee for the student
    SELECT @TotalSpending = SUM(EnrollmentFee)
    FROM Enrollments
    WHERE StudentID = @StudentID;

    -- Return 0 if the student is not enrolled in any courses
    RETURN ISNULL(@TotalSpending, 0.00);
END;
GO

--Usage
SELECT dbo.GetStudentTotalSpending(1) AS TotalSpending;
GO

/********************************************************************************************/

--Get department with most students 
CREATE FUNCTION GetDepartmentWithMostStudents()
RETURNS INT
AS
BEGIN
    DECLARE @DepartmentWithMostStudents INT;

    -- Get the DepartmentID with the most enrolled students
    SELECT TOP 1 @DepartmentWithMostStudents = DepartmentID
    FROM Students
    GROUP BY DepartmentID
    ORDER BY COUNT(*) DESC;

    RETURN @DepartmentWithMostStudents;
END;
GO

--Usage
SELECT dbo.GetDepartmentWithMostStudents() AS DepartmentWithMostStudents;
GO

SELECT * FROM Departments ; 
GO

/********************************************************************************************/

--Triggers
--Trigger to prevent enrolling in a course if the course capacity is full (INSTEAD OF INSERT):
CREATE TRIGGER IfFull
ON Enrollments
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CourseID INT, @StudentID INT, @CourseFee DECIMAL(10, 2);
    DECLARE @CurrentCount INT, @CourseCapacity INT;

    -- Get the data from the inserted row (assuming one row only)
    SELECT 
        @CourseID = CourseID,
        @StudentID = StudentID
    FROM inserted;

    -- Get the course fee and capacity
    SELECT 
        @CourseFee = CourseFee,
        @CourseCapacity = CourseCapacity
    FROM Courses
    WHERE CourseID = @CourseID;

    -- Count current enrollments
    SELECT @CurrentCount = COUNT(*)
    FROM Enrollments
    WHERE CourseID = @CourseID;

    -- Check if the course is full
    IF @CurrentCount >= @CourseCapacity
    BEGIN
        PRINT 'Cannot enroll. Course capacity is full.';
    END
    ELSE
    BEGIN
        INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
        VALUES (@StudentID, @CourseID, GETDATE(), @CourseFee);

        PRINT 'Enrolled successfully.';
    END
END;
GO


--test 
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
VALUES (3 , 3 , GETDATE(), 0);
GO

--check for another course 
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
VALUES (4, 1, GETDATE(), 0);
GO

SELECT * FROM Enrollments;
GO


/********************************************************************************************/

--Trigger to prevent deletion of an enrolled course if the student's credit hours are less than 15 (AFTER DELETE):
CREATE TRIGGER PreventDelet
ON Enrollments
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentID INT;
    DECLARE @TotalCredits INT;

    -- Get the affected student
    SELECT TOP 1 @StudentID = StudentID FROM deleted;

    -- Recalculate their remaining credit hours after the deletion
    SELECT @TotalCredits = SUM(C.Credits)
    FROM Enrollments E
    JOIN Courses C ON E.CourseID = C.CourseID
    WHERE E.StudentID = @StudentID;

    -- If the total drops below 15, rollback
	PRINT 'Student ID: ' + CAST(@StudentID AS VARCHAR);
    PRINT 'Total Credits After Delete: ' + CAST(@TotalCredits AS VARCHAR);
    IF ISNULL(@TotalCredits, 0) < 15
    BEGIN
        PRINT 'Cannot delete enrollment. Student would fall below 15 credit hours.';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Otherwise, update the student's CreditsHours
    UPDATE Students
    SET CreditsHours = @TotalCredits
    WHERE StudentID = @StudentID;

    PRINT 'Deletion allowed. Credits updated.';
END;
GO

--test
DELETE FROM Enrollments
WHERE StudentID =2  AND CourseID = 1;

--check another student
DELETE FROM Enrollments
WHERE StudentID = 8 AND CourseID = 3;

SELECT * FROM Enrollments;
GO


/*************************** Member3_Task ******************************/

-- Transactions and Concurrency Examples

-- 1. Basic Transaction Example (Course Fee Update)
use University;
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Update course fee for CourseID 1
    UPDATE Courses 
    SET CourseFee = CourseFee * 1.1  -- Increase by 10%
    WHERE CourseID = 1;
    
    -- Insert a log record
    INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
    VALUES (1, 1, GETDATE(), (SELECT CourseFee FROM Courses WHERE CourseID = 1));
    
    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Transaction rolled back due to error:';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- Check the result
SELECT CourseID, CourseName, CourseFee FROM Courses WHERE CourseID = 1;
SELECT * FROM Enrollments WHERE StudentID = 1 AND CourseID = 1;
GO

/********************************************************************************************/

-- 2. Transaction with SAVEPOINT (Student Department Transfer) - FIXED VERSION
BEGIN TRANSACTION;
    -- Save current state
    SAVE TRANSACTION BeforeTransfer;
    
    -- Try to transfer student to new department
    UPDATE Students 
    SET DepartmentID = 4  -- Health Care department
    WHERE StudentID = 2;
    
    -- Check if student has courses that don't belong to the new department
    IF EXISTS (
        SELECT 1 
        FROM Enrollments e
        JOIN Courses c ON e.CourseID = c.CourseID
        JOIN CourseInstructors ci ON c.CourseID = ci.CourseID
        JOIN Instructors i ON ci.InstructorID = i.InstructorID
        WHERE e.StudentID = 2 AND i.DepartmentID <> 4
    )
    BEGIN
        -- Rollback to savepoint if conflict
        ROLLBACK TRANSACTION BeforeTransfer;
        PRINT 'Transfer rolled back - student has courses in other departments.';
    END
    ELSE
    BEGIN
        PRINT 'Transfer completed successfully.';
    END
    
COMMIT TRANSACTION;
GO

-- Check result
SELECT s.StudentID, s.FirstName, s.LastName, d.DepartmentName 
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
WHERE s.StudentID = 2;
GO

/********************************************************************************************/


/********************************************************************************************/

/********************************************************************************************/

-- 5. Different Isolation Levels Examples

-- a) READ COMMITTED (Default)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
    SELECT * FROM Students WHERE StudentID = 1;
    -- Other transactions can modify this data
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Students WHERE StudentID = 1;  -- May see changes
COMMIT TRANSACTION;
GO

-- b) REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
    SELECT * FROM Students WHERE StudentID = 1;
    -- Other transactions can't modify this data until commit
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Students WHERE StudentID = 1;  -- Will see same data
COMMIT TRANSACTION;
GO

-- c) SERIALIZABLE (Highest isolation)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
    SELECT * FROM Students WHERE DepartmentID = 3;
    -- Other transactions can't insert/update/delete in this range
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Students WHERE DepartmentID = 3;  -- Will see same data
COMMIT TRANSACTION;
GO

/********************************************************************************************/

-- 6. Solving Concurrency Issues with Optimistic Concurrency Control
-- Using rowversion/timestamp

-- First, add a rowversion column to Students table
ALTER TABLE Students ADD RowVersion rowversion;
GO

-- Then use it in update procedure
CREATE PROCEDURE UpdateStudentCGPA
    @StudentID INT,
    @NewCGPA DECIMAL(5,2),
    @OriginalRowVersion rowversion
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @CurrentRowVersion rowversion;
        
        -- Get current rowversion
        SELECT @CurrentRowVersion = RowVersion
        FROM Students
        WHERE StudentID = @StudentID;
        
        -- Check if row was modified
        IF @CurrentRowVersion <> @OriginalRowVersion
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN -1;  -- Indicate concurrency conflict
        END
        
        -- Perform update
        UPDATE Students
        SET CGPA = @NewCGPA
        WHERE StudentID = @StudentID;
        
        COMMIT TRANSACTION;
        RETURN 0;  -- Success
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        RETURN -2;  -- Error
    END CATCH
END;
GO

-- Usage example:
DECLARE @RowVersion rowversion;
SELECT @RowVersion = RowVersion FROM Students WHERE StudentID = 1;

-- Simulate concurrent change by another user
UPDATE Students SET CGPA = 3.85 WHERE StudentID = 1;

-- Now try our update
DECLARE @Result INT;
EXEC @Result = UpdateStudentCGPA 
    @StudentID = 1, 
    @NewCGPA = 3.9, 
    @OriginalRowVersion = @RowVersion;
    
IF @Result = -1
    PRINT 'Update failed - data was modified by another user.';
ELSE IF @Result = 0
    PRINT 'Update succeeded.';
ELSE
    PRINT 'Error occurred during update.';
GO

-- Check result
SELECT StudentID, FirstName, LastName, CGPA FROM Students WHERE StudentID = 1;
GO


/*****************************************Member4***************************/
/***************************************
    INDEX CREATION
***************************************/
-- Example queries with specific columns to optimize index usage
SELECT StudentID, CourseID, EnrollmentDate, EnrollmentFee 
FROM Enrollments 
WHERE StudentID = 3;

SELECT StudentID, CourseID, EnrollmentDate 
FROM Enrollments 
WHERE CourseID = 1;

SELECT StudentID, FirstName, LastName, DepartmentID 
FROM Students 
WHERE DepartmentID = 2;

-- Create index on StudentID column in Enrollments table to speed up lookups by StudentID
CREATE NONCLUSTERED INDEX idx_Enrollments_StudentID
ON Enrollments(StudentID)
INCLUDE (CourseID, EnrollmentDate, EnrollmentFee); -- Covering Index for common queries

-- Create composite index on StudentID and CourseID for queries filtering on both
CREATE NONCLUSTERED INDEX idx_Enrollments_StudentID_CourseID
ON Enrollments(StudentID, CourseID)
INCLUDE (EnrollmentDate, EnrollmentFee); -- Include additional columns for covering

-- Create index on CourseID column in Enrollments table
CREATE NONCLUSTERED INDEX idx_Enrollments_CourseID
ON Enrollments(CourseID)
INCLUDE (StudentID, EnrollmentDate); -- Covering Index for CourseID queries

-- Create index on DepartmentID column in Students table
CREATE NONCLUSTERED INDEX idx_Students_DepartmentID
ON Students(DepartmentID)
INCLUDE (FirstName, LastName); -- Covering Index for department-related queries

-- Create index on CourseID in Courses table for joins and lookups
CREATE NONCLUSTERED INDEX idx_Courses_CourseID
ON Courses(CourseID)
INCLUDE (CourseName, CourseFee); -- Covering Index for common queries

-- Create index on PrerequisiteCourseID in Courses table for prerequisite checks
CREATE NONCLUSTERED INDEX idx_Courses_PrerequisiteCourseID
ON Courses(PrerequisiteCourseID)
WHERE PrerequisiteCourseID IS NOT NULL; -- Filtered Index for non-NULL values

-- Create index on EnrollmentID in Grades table for joins
CREATE NONCLUSTERED INDEX idx_Grades_EnrollmentID
ON Grades(EnrollmentID)
INCLUDE (Grade); -- Covering Index for grade-related queries

/***************************************
    SECURITY SETUP - USERS AND ROLES
***************************************/

-- Create login and user for student with a stronger password
CREATE LOGIN student_user WITH PASSWORD = 'Stu#Secure2025!';
CREATE USER student_user FOR LOGIN student_user;

-- Create login and user for admin with a stronger password
CREATE LOGIN admin_user WITH PASSWORD = 'Adm#Secure2025!';
CREATE USER admin_user FOR LOGIN admin_user;

-- Create a role for students
CREATE ROLE StudentRole;

-- Grant read-only access to Students, Courses, and StudentProgress view for StudentRole
GRANT SELECT ON Students TO StudentRole;
GRANT SELECT ON Courses TO StudentRole;
GRANT SELECT ON StudentProgress TO StudentRole; -- Added for view access

-- Add student_user to StudentRole
EXEC sp_addrolemember 'StudentRole', 'student_user';

-- Revoke modification permissions from student_user
REVOKE INSERT, UPDATE, DELETE ON Students FROM student_user;
REVOKE INSERT, UPDATE, DELETE ON Courses FROM student_user;

-- Create a role for admins
CREATE ROLE AdminRole;

-- Grant full permissions on all tables in schema dbo to AdminRole
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO AdminRole;

-- Grant execute permissions on stored procedures to AdminRole
GRANT EXECUTE ON WithDiscount TO AdminRole;
GRANT EXECUTE ON UpdateCourseFee TO AdminRole;
GRANT EXECUTE ON EnrollStudentWithPrerequisiteCheck TO AdminRole;

-- Add admin_user to AdminRole
EXEC sp_addrolemember 'AdminRole', 'admin_user';

-- Grant SHOWPLAN to admin_user only (revoked from student_user for security)
GRANT SHOWPLAN TO admin_user;

/***************************************
    TRIGGER TO HANDLE FRIENDLY ERROR FOR STUDENT
***************************************/

-- Create trigger to prevent students from deleting rows from Students table
-- Enhanced to check for Enrollments and handle multiple row deletions
/*CREATE TRIGGER PreventStudentDelete
ON Students
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @UserName NVARCHAR(100);
    SET @UserName = USER_NAME();

    IF @UserName = 'student_user'
    BEGIN
        PRINT '❌ You are not allowed to delete student data.';
        RETURN;
    END

    -- Check if any student to be deleted has enrollments
    IF EXISTS (SELECT 1 FROM Enrollments e WHERE e.StudentID IN (SELECT StudentID FROM deleted))
    BEGIN
        PRINT 'Cannot delete students because some are enrolled in courses.';
        RETURN;
    END

    -- Allow deletion for others
    DELETE FROM Students
    WHERE StudentID IN (SELECT StudentID FROM deleted);
END;
GO*/

/***************************************
    TESTING THE SECURITY
***************************************/

-- Test 1: Ensure student_user cannot delete from Students (should trigger friendly error)
EXECUTE AS USER = 'student_user';
DELETE FROM Students WHERE StudentID = 1;
-- Expected: Prints '❌ You are not allowed to delete student data.'
REVERT;

-- Test 2: Ensure student_user can view StudentProgress view
EXECUTE AS USER = 'student_user';
SELECT StudentID, StudentFirstName, StudentLastName, CourseName, Grade 
FROM StudentProgress 
WHERE StudentFirstName = 'Joseph';
-- Expected: Returns rows for student Joseph
REVERT;

-- Test 3: Ensure admin_user can delete from Enrollments and Students
EXECUTE AS USER = 'admin_user';
-- Delete enrollments for StudentID = 4 (no foreign key issues expected)
DELETE FROM Enrollments WHERE StudentID = 4;
-- Delete student with StudentID = 4 (should succeed if no enrollments)
DELETE FROM Students WHERE StudentID = 4;
-- Expected: Deletes rows successfully
REVERT;

-- Test 4: Test admin_user executing stored procedure WithDiscount
EXECUTE AS USER = 'admin_user';
EXEC WithDiscount @StudentID = 1, @CourseID = 3;
-- Expected: Prints 'Enrollment successful.' or error if already enrolled
REVERT;

/*****************************************************************************************/
-- Test 5: Test index performance on Courses and Grades
EXECUTE AS USER = 'admin_user';
SELECT CourseName, AVG(Grade)
FROM Courses C
JOIN Enrollments E ON C.CourseID = E.CourseID
JOIN Grades G ON E.EnrollmentID = G.EnrollmentID
WHERE C.CourseID = 1
GROUP BY CourseName;
-- Expected: Faster execution with idx_Courses_CourseID and idx_Grades_EnrollmentID
REVERT;

/***************************************
     PERFORMANCE COMPARISON
***************************************/

-- Example queries to compare performance with indexes (run with Actual Execution Plan enabled in SSMS)
SELECT StudentID, CourseID, EnrollmentDate, EnrollmentFee 
FROM Enrollments 
WHERE StudentID = 3;

SELECT StudentID, CourseID, EnrollmentDate 
FROM Enrollments 
WHERE CourseID = 1;

SELECT StudentID, FirstName, LastName, DepartmentID 
FROM Students 
WHERE DepartmentID = 2;

SELECT CourseID, CourseName, CourseFee 
FROM Courses 
WHERE CourseID = 1;

SELECT EnrollmentID, Grade 
FROM Grades 
WHERE EnrollmentID = 1;





