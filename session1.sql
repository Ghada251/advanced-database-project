use University;
-- Session 1 (Run this in one query window)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
SELECT 'Session 1 (Uncommitted Read): Before Update';
SELECT Grade FROM Grades WHERE EnrollmentID = 1;
WAITFOR DELAY '00:00:05'; -- Simulate some work
SELECT 'Session 1 (Uncommitted Read): After Potential Update';
SELECT Grade FROM Grades WHERE EnrollmentID = 1;
COMMIT TRANSACTION;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- Reset isolation level
GO


--------------------------------------------------------------------------
-- Demonstrate Lost Update Problem
--------------------------------------------------------------------------

-- Session 1 (Run this in one query window)
BEGIN TRANSACTION;
DECLARE @initial INT;
SELECT @initial = CreditsHours FROM Students WHERE StudentID = 5;
WAITFOR DELAY '00:00:05';
UPDATE Students
SET CreditsHours = @initial + 1
WHERE StudentID = 5;
COMMIT;
SELECT 'Session 1: Updated Credits';
SELECT CreditsHours FROM Students WHERE StudentID = 5;
GO


use University;

-- 3. Dirty Read Problem Demonstration
-- First connection (run this first):
BEGIN TRANSACTION;
    UPDATE Students 
    SET CGPA = 3.75 
    WHERE StudentID = 3;
    
    -- Wait for 10 seconds to simulate long transaction
    WAITFOR DELAY '00:00:10';
    
    -- Then rollback
    ROLLBACK TRANSACTION;
GO






-- 4. Lost Update Problem Demonstration
-- First connection:
BEGIN TRANSACTION;
    DECLARE @CurrentFee DECIMAL(5,2);
    
    SELECT @CurrentFee = CourseFee 
    FROM Courses WITH (UPDLOCK)  -- Prevent lost update
    WHERE CourseID = 2;
    
    -- Simulate processing delay
    WAITFOR DELAY '00:00:05';
    
    UPDATE Courses 
    SET CourseFee = @CurrentFee + 50 
    WHERE CourseID = 2;
    
    COMMIT TRANSACTION;
GO
