-- SQL Server Script to create the Constitution1996 DB by Marco Oppel ©2025
-- Table Contents except Amendments based on the actual Constitution found at: https://www.justice.gov.za/legislation/constitution/saconstitution-web-eng.pdf
-- Amendments table content was found on pages 2 - 3 from this book: https://juta.co.za/catalogue-details/constitution-of-the-republic-of-south-africa-1996-3_446
-- CONTENTS ACCURATE AS OF APRIL 2025

/*
	////////////////////////
	Create and use the Constitution1996 DB, and create the schemas
	////////////////////////
*/
DROP DATABASE IF EXISTS Constitution1996;
CREATE DATABASE Constitution1996;
GO

USE Constitution1996;
GO

CREATE SCHEMA AmendmentSchema;
GO
CREATE SCHEMA MainSchema;
GO
CREATE SCHEMA ScheduleSchema;
GO

/*
	/////////////////////
	Create the tables needed for each schema
	/////////////////////
*/

/* AmendmentSchema */

CREATE TABLE [AmendmentSchema].Amendments
(
	AmendmentID int PRIMARY KEY,
	AmendmentTitle nvarchar(50) NOT NULL,
	DateOfEffect Date NOT NULL,
	Reference nvarchar(175) NOT NULL
)
GO
CREATE UNIQUE INDEX AmendmentIndex ON [AmendmentSchema].Amendments(AmendmentTitle);
GO

/* END */

/* MainSchema */


CREATE TABLE [MainSchema].Chapters
(
	ChapterID int PRIMARY KEY,
	ChapterTitle nvarchar(60) NOT NULL
)
GO
CREATE UNIQUE INDEX ChapterTitleIndex ON [MainSchema].Chapters(ChapterTitle);
GO

CREATE TABLE [MainSchema].Sections
(
	SectionID int PRIMARY KEY,
	ChapterID int FOREIGN KEY REFERENCES [MainSchema].Chapters(ChapterID),
	SectionTitle nvarchar(100) NOT NULL,
	SectionText nvarchar(MAX)
)
GO
CREATE UNIQUE INDEX MainSectionTitleIndex ON [MainSchema].Sections(SectionTitle);
GO

CREATE TABLE [MainSchema].Subsections
(
    SubsectionID int PRIMARY KEY,
    SectionID int FOREIGN KEY REFERENCES [MainSchema].Sections(SectionID),
    SubsectionText nvarchar(MAX) NOT NULL
)
GO

CREATE TABLE [MainSchema].Clauses
(
	ClauseID int PRIMARY KEY,
    SubsectionID int FOREIGN KEY REFERENCES [MainSchema].Subsections(SubsectionID),
    ClauseText nvarchar(MAX) NOT NULL
)
GO

/* END */


/* ScheduleSchema */ 

CREATE TABLE [ScheduleSchema].Schedules
(
    ScheduleID int PRIMARY KEY,
    ScheduleTitle nvarchar(100) NOT NULL
)
GO
CREATE UNIQUE INDEX ScheduleTitleIndex ON [ScheduleSchema].Schedules(ScheduleTitle);
GO

CREATE TABLE [ScheduleSchema].ScheduleParts
(
    PartID int PRIMARY KEY,
    ScheduleID int NOT NULL,
    PartTitle nvarchar(100) NOT NULL,
    FOREIGN KEY (ScheduleID) REFERENCES [ScheduleSchema].Schedules(ScheduleID)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleSections
(
    SectionID int PRIMARY KEY,
    PartID int NOT NULL,
    ScheduleID int NOT NULL,
    SectionText nvarchar(MAX),
    FOREIGN KEY (PartID) REFERENCES [ScheduleSchema].ScheduleParts(PartID),
    FOREIGN KEY (ScheduleID) REFERENCES [ScheduleSchema].Schedules(ScheduleID)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleSubsections
(
    SubsectionID int PRIMARY KEY,
    SectionID int NOT NULL,
    SubsectionText nvarchar(MAX) NOT NULL,
    FOREIGN KEY (SectionID) REFERENCES [ScheduleSchema].ScheduleSections(SectionID)
)
GO


/* END */


/*
	////////////////////
	Insert Statements to fill tables with needed content
	///////////////////
*/