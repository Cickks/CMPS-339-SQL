/*
    CMPS 339 Group Project
    Fitness Center & Personal Training Management System
    SQL Server Database Script

    Michael: Database structure, tables, keys, constraints
    Remy: Sample data, queries, views, reports
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

INSERT INTO Members (FirstName, LastName, Email, Phone, DateOfBirth, JoinDate, MemberStatus)
VALUES
('Ari', 'Miller', 'ari.m@email.com', '985-555-0101', '1998-03-14', '2025-01-15', 'Active'),
('Noelle', 'Chutz', 'noelle.c@email.com', '985-555-0102', '2001-07-22', '2025-03-02', 'Active'),
('Quandale', 'Dingle', 'quandale.d@email.com', '985-555-0103', '1995-11-05', '2025-04-20', 'Active'),
('Noah', 'Martin', 'noah.m@email.com', NULL, '2000-01-30', '2025-06-10', 'Inactive'),
('Zoe', 'Hebert', 'zoe.h@email.com', '985-555-0105', '1999-09-18', '2025-07-01', 'Active');
GO

-- 2. MembershipPlans (5 rows)

INSERT INTO MembershipPlans (PlanName, MonthlyFee, DurationMonths)
VALUES
('Basic Monthly', 29.99, 1),
('Premium Monthly', 59.99, 1),
('Basic Annual', 299.99, 12),
('Premium Annual', 599.99, 12),
('Student Plan', 19.99, 1);
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