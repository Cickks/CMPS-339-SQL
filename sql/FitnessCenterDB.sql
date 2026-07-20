/*
    CMPS 339 Group Project
    Fitness Center & Personal Training Management System
    SQL Server Database Script

    Michael: Core tables, integration, and final testing
    Remy: Core sample data and membership-plan query
    Nicholas: Group classes, schedules, attendance, queries, and check-in view
    Areeba: Private sessions, payments, query, and trainer revenue view
*/

-- Create the database only if it does not already exist
IF DB_ID('FitnessCenterDB') IS NULL
BEGIN
    CREATE DATABASE FitnessCenterDB;
END;
GO

-- Use the project database
USE FitnessCenterDB;
GO

-- Members table
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    DateOfBirth DATE NULL,
    JoinDate DATE NOT NULL CONSTRAINT DF_Members_JoinDate DEFAULT (GETDATE()),
    MemberStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Members_MemberStatus DEFAULT ('Active'),

    CONSTRAINT PK_Members PRIMARY KEY (MemberID),
    CONSTRAINT UQ_Members_Email UNIQUE (Email),
    CONSTRAINT CK_Members_MemberStatus CHECK (MemberStatus IN ('Active', 'Inactive', 'Suspended'))
);
GO

-- MembershipPlans table
CREATE TABLE MembershipPlans (
    MembershipPlanID INT IDENTITY(1,1) NOT NULL,
    PlanName VARCHAR(50) NOT NULL,
    MonthlyFee DECIMAL(10,2) NOT NULL,
    ClassAccessLimit INT NULL,
    IncludesPersonalTraining BIT NOT NULL CONSTRAINT DF_MembershipPlans_IncludesPersonalTraining DEFAULT (0),
    PlanStatus VARCHAR(20) NOT NULL CONSTRAINT DF_MembershipPlans_PlanStatus DEFAULT ('Active'),

    CONSTRAINT PK_MembershipPlans PRIMARY KEY (MembershipPlanID),
    CONSTRAINT UQ_MembershipPlans_PlanName UNIQUE (PlanName),
    CONSTRAINT CK_MembershipPlans_MonthlyFee CHECK (MonthlyFee > 0),
    CONSTRAINT CK_MembershipPlans_ClassAccessLimit CHECK (ClassAccessLimit IS NULL OR ClassAccessLimit >= 0),
    CONSTRAINT CK_MembershipPlans_PlanStatus CHECK (PlanStatus IN ('Active', 'Inactive'))
);
GO

-- MemberMemberships table
CREATE TABLE MemberMemberships (
    MemberMembershipID INT IDENTITY(1,1) NOT NULL,
    MemberID INT NOT NULL,
    MembershipPlanID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    MembershipStatus VARCHAR(20) NOT NULL CONSTRAINT DF_MemberMemberships_MembershipStatus DEFAULT ('Active'),

    CONSTRAINT PK_MemberMemberships PRIMARY KEY (MemberMembershipID),
    CONSTRAINT UQ_MemberMemberships_Member_Plan_Start UNIQUE (MemberID, MembershipPlanID, StartDate),
    CONSTRAINT CK_MemberMemberships_EndDate CHECK (EndDate IS NULL OR EndDate >= StartDate),
    CONSTRAINT CK_MemberMemberships_Status CHECK (MembershipStatus IN ('Active', 'Expired', 'Cancelled')),

    CONSTRAINT FK_MemberMemberships_Members FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),

    CONSTRAINT FK_MemberMemberships_MembershipPlans FOREIGN KEY (MembershipPlanID)
        REFERENCES MembershipPlans(MembershipPlanID)
);
GO

-- Trainers table
CREATE TABLE Trainers (
    TrainerID INT IDENTITY(1,1) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    Specialization VARCHAR(100) NOT NULL,
    HourlyRate DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL CONSTRAINT DF_Trainers_HireDate DEFAULT (GETDATE()),
    TrainerStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Trainers_TrainerStatus DEFAULT ('Active'),

    CONSTRAINT PK_Trainers PRIMARY KEY (TrainerID),
    CONSTRAINT UQ_Trainers_Email UNIQUE (Email),
    CONSTRAINT CK_Trainers_HourlyRate CHECK (HourlyRate > 0),
    CONSTRAINT CK_Trainers_TrainerStatus CHECK (TrainerStatus IN ('Active', 'Inactive'))
);
GO

-- Rooms table
CREATE TABLE Rooms (
    RoomID INT IDENTITY(1,1) NOT NULL,
    RoomName VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    RoomStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Rooms_RoomStatus DEFAULT ('Available'),

    CONSTRAINT PK_Rooms PRIMARY KEY (RoomID),
    CONSTRAINT UQ_Rooms_RoomName UNIQUE (RoomName),
    CONSTRAINT CK_Rooms_Capacity CHECK (Capacity > 0),
    CONSTRAINT CK_Rooms_RoomStatus CHECK (RoomStatus IN ('Available', 'Unavailable', 'Maintenance'))
);
GO

-- GroupClasses Table
CREATE TABLE GroupClasses (
    ClassID INT IDENTITY(1,1) NOT NULL,
    ClassName VARCHAR(50) NOT NULL,
    ClassDescription VARCHAR(255) NULL,
    ClassStatus VARCHAR(20) NOT NULL CONSTRAINT DF_GroupClasses_ClassStatus DEFAULT ('Active'),

    CONSTRAINT PK_GroupClasses PRIMARY KEY (ClassID),
    CONSTRAINT UQ_GroupClasses_ClassName UNIQUE (ClassName),
    CONSTRAINT CK_GroupClasses_ClassStatus CHECK (ClassStatus IN ('Active', 'Inactive'))
);
GO

-- ClassSchedules Table 
CREATE TABLE ClassSchedules (
    ScheduleID INT IDENTITY(1,1) NOT NULL,
    ClassID INT NOT NULL,
    TrainerID INT NOT NULL,
    RoomID INT NOT NULL,
    ScheduleTime DATETIME NOT NULL,
    MaxCapacity INT NOT NULL,

    CONSTRAINT PK_ClassSchedules PRIMARY KEY (ScheduleID),
    CONSTRAINT CK_ClassSchedules_MaxCapacity CHECK (MaxCapacity > 0),
    CONSTRAINT FK_ClassSchedules_GroupClasses FOREIGN KEY (ClassID)
        REFERENCES GroupClasses(ClassID),
    CONSTRAINT FK_ClassSchedules_Trainers FOREIGN KEY (TrainerID)
        REFERENCES Trainers(TrainerID),
    CONSTRAINT FK_ClassSchedules_Rooms FOREIGN KEY (RoomID)
        REFERENCES Rooms(RoomID)
);
GO

-- ClassAttendance Table 
CREATE TABLE ClassAttendance (
    AttendanceID INT IDENTITY(1,1) NOT NULL,
    MemberID INT NOT NULL,
    ScheduleID INT NOT NULL,
    CheckInTime DATETIME NOT NULL CONSTRAINT DF_ClassAttendance_CheckInTime DEFAULT (GETDATE()),
    MemberRating INT NULL,

    CONSTRAINT PK_ClassAttendance PRIMARY KEY (AttendanceID),
    CONSTRAINT UQ_ClassAttendance_Member_Schedule UNIQUE (MemberID, ScheduleID),
    CONSTRAINT CK_ClassAttendance_MemberRating CHECK (MemberRating BETWEEN 1 AND 5),

    CONSTRAINT FK_ClassAttendance_Members FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),
    CONSTRAINT FK_ClassAttendance_ClassSchedules FOREIGN KEY (ScheduleID)
        REFERENCES ClassSchedules(ScheduleID)
);
GO

-- PrivateSessions Table
CREATE TABLE PrivateSessions (
    PrivateSessionID INT IDENTITY(1,1) NOT NULL,
    MemberID INT NOT NULL,
    TrainerID INT NOT NULL,
    RoomID INT NULL,
    SessionDate DATE NOT NULL,
    StartTime TIME(3) NOT NULL,
    DurationMinutes INT NOT NULL CONSTRAINT DF_PrivateSessions_DurationMinutes DEFAULT (60),
    SessionFee DECIMAL(10,2) NOT NULL,
    SessionStatus VARCHAR(20) NOT NULL CONSTRAINT DF_PrivateSessions_SessionStatus DEFAULT ('Scheduled'),

    CONSTRAINT PK_PrivateSession PRIMARY KEY (PrivateSessionID),
    CONSTRAINT UQ_PrivateSessions_Trainer_Date_Time UNIQUE (TrainerID, SessionDate, StartTime),
    CONSTRAINT CK_PrivateSessions_DurationMinutes CHECK (DurationMinutes > 0),
    CONSTRAINT CK_PrivateSessions_SessionStatus CHECK (SessionStatus IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),

    CONSTRAINT FK_PrivateSessions_Members FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),
    
    CONSTRAINT FK_PrivateSessions_Trainers FOREIGN KEY (TrainerID)
        REFERENCES Trainers(TrainerID),
    
    CONSTRAINT FK_PrivateSessions_Rooms FOREIGN KEY (RoomID)
        REFERENCES Rooms(RoomID)
);
GO

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) NOT NULL,
    MemberID INT NOT NULL,
    MemberMembershipID INT NULL,
    PrivateSessionID INT NULL,
    PaymentDate DATE NOT NULL CONSTRAINT DF_Payments_PaymentDate DEFAULT (GETDATE()),
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Payments_PaymentStatus DEFAULT ('Completed'),

    CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
    CONSTRAINT CK_Payments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Payments_PaymentMethod CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'Cash', 'Bank Transfer', 'Check')),
    CONSTRAINT CK_Payments_PaymentStatus CHECK (PaymentStatus IN ('Completed', 'Pending', 'Failed', 'Refunded')),
    CONSTRAINT CK_Payments_LinkedTo CHECK (
        NOT (MemberMembershipID IS NULL AND PrivateSessionID IS NULL)
    ),

    CONSTRAINT FK_Payment_Members FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),
    CONSTRAINT FK_Payments_MemberMemberships FOREIGN KEY (MemberMembershipID)
        REFERENCES MemberMemberships(MemberMembershipID),
    CONSTRAINT FK_Payments_PrivateSessions FOREIGN KEY (PrivateSessionID)
        REFERENCES PrivateSessions(PrivateSessionID)
);
GO

INSERT INTO Members (FirstName, LastName, Email, Phone, DateOfBirth, JoinDate, MemberStatus)
VALUES
('Ari', 'Miller', 'ari.m@email.com', '985-555-0101', '1998-03-14', '2025-01-15', 'Active'),
('Noelle', 'Chutz', 'noelle.c@email.com', '985-555-0102', '2001-07-22', '2025-03-02', 'Active'),
('Quandale', 'Dingle', 'quandale.d@email.com', '985-555-0103', '1995-11-05', '2025-04-20', 'Active'),
('Noah', 'Martin', 'noah.m@email.com', NULL, '2000-01-30', '2025-06-10', 'Inactive'),
('Zoe', 'Hebert', 'zoe.h@email.com', '985-555-0105', '1999-09-18', '2025-07-01', 'Active');
GO


-- 3. Trainers (5 rows)

INSERT INTO Trainers (FirstName, LastName, Email, Phone, Specialization, HourlyRate, HireDate, TrainerStatus)
VALUES
('Marcus', 'Reilly', 'marcus.r@fitcenter.com', '985-555-0201', 'Strength', 45.00, '2023-02-01', 'Active'),
('Dana', 'Cho', 'dana.c@fitcenter.com', '985-555-0202', 'Yoga', 40.00, '2022-08-15', 'Active'),
('Jorge', 'Alvarez', 'jorge.a@fitcenter.com', '985-555-0203', 'HIIT', 50.00, '2023-05-10', 'Active'),
('Priya', 'Nair', 'priya.n@fitcenter.com', '985-555-0204', 'Pilates', 42.00, '2024-01-20', 'Active'),
('Kevin', 'Okafor', 'kevin.o@fitcenter.com', NULL, 'CrossFit', 48.00, '2021-11-01', 'Inactive');
GO

-- 4. Rooms (5 rows)

INSERT INTO Rooms (RoomName, Capacity, RoomStatus)
VALUES
('Studio A', 20, 'Available'),
('Studio B', 15, 'Available'),
('Weight Room', 30, 'Available'),
('CrossFit Box', 12, 'Maintenance'),
('Private Training Room', 4, 'Available');
GO

-- MembershipPlans (5 rows)

INSERT INTO MembershipPlans (PlanName, MonthlyFee, ClassAccessLimit, IncludesPersonalTraining, PlanStatus)
VALUES
('Basic Monthly', 29.99, 8, 0, 'Active'),
('Premium Monthly', 59.99, NULL, 1, 'Active'),
('Basic Annual', 24.99, 8, 0, 'Active'),
('Premium Annual', 49.99, NULL, 1, 'Active'),
('Student Plan', 19.99, 4, 0, 'Active');
GO

INSERT INTO MemberMemberships
    (MemberID, MembershipPlanID, StartDate, EndDate, MembershipStatus)
VALUES
    (1, 1, '2025-01-15', NULL, 'Active'),
    (2, 2, '2025-03-02', NULL, 'Active'),
    (3, 3, '2025-04-20', NULL, 'Active'),
    (4, 4, '2025-06-10', '2025-07-10', 'Expired'),
    (5, 5, '2025-07-01', NULL, 'Active');
GO

INSERT INTO GroupClasses (ClassName, ClassDescription)
VALUES 
('Yoga', 'Do some yoga.'),
('Spin class', 'Fake bicycles.'),
('Weight class', 'Lift some weights.'),
('Pilates', 'Do some pilates.'),
('CrossFit', 'Do some crossfit.');
GO

INSERT INTO ClassSchedules (ClassID, TrainerID, RoomID, ScheduleTime, MaxCapacity)
VALUES 
(1, 2, 1, '2026-07-20 08:00:00', 15),
(2, 3, 2, '2026-07-20 09:30:00', 12),
(3, 3, 1, '2026-07-21 17:30:00', 20),
(4, 4, 2, '2026-07-22 10:00:00', 15),
(1, 2, 1, '2026-07-27 08:00:00', 15),
(5, 1, 3, '2026-07-23 06:00:00', 10);
GO

INSERT INTO ClassAttendance (MemberID, ScheduleID, CheckInTime, MemberRating)
VALUES 
(1, 1, '2026-07-20 07:55:00', 5),
(1, 2, '2026-07-20 09:28:00', 4),
(1, 3, '2026-07-21 17:25:00', 5),
(1, 4, '2026-07-22 09:59:00', 4),
(1, 6, '2026-07-23 05:50:00', 3),
(1, 5, '2026-07-27 07:52:00', 5),
(2, 1, '2026-07-20 07:54:00', 4),
(3, 1, '2026-07-20 07:57:00', 2),
(2, 3, '2026-07-21 17:20:00', 4),
(5, 4, '2026-07-22 09:55:00', 5);
GO

INSERT INTO PrivateSessions (MemberID, TrainerID, RoomID, SessionDate, StartTime, DurationMinutes, SessionFee, SessionStatus)
VALUES
(2, 1, 5, '2026-07-05', '09:00', 60, 45.00, 'Completed'),
(2, 3, 5, '2026-07-08', '10:00', 45, 37.50, 'No-Show'),
(5, 4, 5, '2026-07-10', '14:00', 60, 42.00, 'Completed'),
(3, 1, 5, '2026-07-13', '08:00', 30, 22.50, 'Cancelled'),
(1, 2, 3, '2026-07-15', '17:30', 60, 40.00, 'Scheduled');
GO

INSERT INTO Payments (MemberID, MemberMembershipID, PrivateSessionID, PaymentDate, Amount, PaymentMethod, PaymentStatus)
VALUES
(1, 1, NULL, '2026-01-15', 29.99, 'Credit Card', 'Completed'),
(2, 2, NULL, '2026-03-02', 59.99, 'Debit Card', 'Pending'),
(2, NULL, 1, '2026-07-05', 45.00, 'Check', 'Failed'),
(3, 3, NULL, '2026-04-20', 24.99, 'Cash', 'Completed'),
(5, NULL, 3, '2026-07-10', 42.00, 'Bank Transfer', 'Refunded');
GO

CREATE VIEW vw_MemberCheckInLog AS
SELECT 
    m.MemberID,
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    c.ClassName,
    s.ScheduleTime,
    a.CheckInTime,
    a.MemberRating
FROM ClassAttendance a
INNER JOIN Members m ON a.MemberID = m.MemberID
INNER JOIN ClassSchedules s ON a.ScheduleID = s.ScheduleID
INNER JOIN GroupClasses c ON s.ClassID = c.ClassID;
GO

SELECT 
    c.ClassName,
    s.ScheduleTime,
    t.FirstName AS TrainerFirstName,
    t.LastName AS TrainerLastName,
    r.RoomName
FROM ClassSchedules s
INNER JOIN GroupClasses c ON s.ClassID = c.ClassID
INNER JOIN Trainers t ON s.TrainerID = t.TrainerID
INNER JOIN Rooms r ON s.RoomID = r.RoomID
ORDER BY s.ScheduleTime ASC;

SELECT 
    m.MemberID,
    m.FirstName,
    m.LastName,
    COUNT(a.AttendanceID) AS TotalClassesAttended
FROM ClassAttendance a
INNER JOIN Members m ON a.MemberID = m.MemberID
GROUP BY m.MemberID, m.FirstName, m.LastName
HAVING COUNT(a.AttendanceID) > 5;

SELECT 
    c.ClassID,
    c.ClassName,
    AVG(CAST(a.MemberRating AS DECIMAL(3,2))) AS AverageRating,
    COUNT(a.MemberRating) AS TotalRatingsReceived
FROM ClassAttendance a
INNER JOIN ClassSchedules s ON a.ScheduleID = s.ScheduleID
INNER JOIN GroupClasses c ON s.ClassID = c.ClassID
WHERE a.MemberRating IS NOT NULL
GROUP BY c.ClassID, c.ClassName;

SELECT * FROM vw_MemberCheckInLog ORDER BY CheckInTime DESC;

-- Query: Members, their private sessions, and the trainer who led each session
SELECT
    m.MemberID,
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    ps.PrivateSessionID,
    ps.SessionDate,
    ps.StartTime,
    ps.DurationMinutes,
    ps.SessionFee,
    ps.SessionStatus,
    t.TrainerID,
    t.FirstName AS TrainerFirstName,
    t.LastName AS TrainerLastName,
    t.Specialization
FROM Members m
INNER JOIN PrivateSessions ps ON m.MemberID = ps.MemberID
INNER JOIN Trainers t ON ps.TrainerID = t.TrainerID
ORDER BY m.LastName, m.FirstName, ps.SessionDate;
GO

-- View: Trainer revenue and total session hours based on COMPLETED private sessions only
CREATE VIEW vw_TrainerRevenue AS
SELECT
    t.TrainerID,
    t.FirstName AS TrainerFirstName,
    t.LastName AS TrainerLastName,
    t.Specialization,
    COUNT(ps.PrivateSessionID) AS CompletedSessions,
    ROUND(SUM(ps.DurationMinutes) / 60.0, 2) AS TotalSessionHours,
    SUM(ps.SessionFee) AS TotalRevenue
FROM Trainers t
LEFT JOIN PrivateSessions ps
    ON t.TrainerID = ps.TrainerID AND ps.SessionStatus = 'Completed'
GROUP BY t.TrainerID, t.FirstName, t.LastName, t.Specialization;
GO

SELECT * FROM vw_TrainerRevenue ORDER BY TotalRevenue DESC;
GO