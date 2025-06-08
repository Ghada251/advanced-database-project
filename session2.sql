use University;
--Session 2 (Run this in another query window *while Session 1 is waiting*)
BEGIN TRANSACTION;
UPDATE Grades
SET Grade = 4.3
WHERE EnrollmentID = 1;
WAITFOR DELAY '00:00:03'; -- Simulate some work before commit/rollback
-- Try commenting out the COMMIT/ROLLBACK below to see the dirty read
-- COMMIT TRANSACTION;
ROLLBACK TRANSACTION;
GO


-- Session 2 (Run this in another query window *while Session 1 is waiting*)
BEGIN TRANSACTION;
DECLARE @initial INT;
SELECT @initial = CreditsHours FROM Students WHERE StudentID = 5;
UPDATE Students
SET CreditsHours = @initial + 2
WHERE StudentID = 5;
COMMIT;
SELECT 'Session 2: Updated Credits';
SELECT CreditsHours FROM Students WHERE StudentID = 5;
GO


-- في Session تاني:
BEGIN TRANSACTION;
DELETE FROM Enrollments WHERE StudentID = 7;
COMMIT TRANSACTION;


BEGIN TRANSACTION;
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, EnrollmentFee)
VALUES (8, 4, GETDATE(), 100);
COMMIT TRANSACTION;







use University;

-- Second connection (run this in new window while first is running):
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  -- Allows dirty reads
BEGIN TRANSACTION;
    SELECT StudentID, FirstName, LastName, CGPA 
    FROM Students 
    WHERE StudentID = 3;  -- Will see uncommitted change (3.75)
    
    -- Then wait to see final result after first transaction completes
    WAITFOR DELAY '00:00:15';
    
    SELECT StudentID, FirstName, LastName, CGPA 
    FROM Students 
    WHERE StudentID = 3;  -- Will see original value after rollback
COMMIT TRANSACTION;
GO





-- Second connection (run simultaneously in new window):
BEGIN TRANSACTION;
    DECLARE @CurrentFee DECIMAL(5,2);
    
    SELECT @CurrentFee = CourseFee 
    FROM Courses 
    WHERE CourseID = 2;
    
    -- No waiting here
    UPDATE Courses 
    SET CourseFee = @CurrentFee + 100 
    WHERE CourseID = 2;
    
    COMMIT TRANSACTION;
GO

-- Check final result
SELECT CourseID, CourseName, CourseFee FROM Courses WHERE CourseID = 2;
GO
