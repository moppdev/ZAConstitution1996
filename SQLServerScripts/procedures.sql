-- SQL Server Script to create the Stored Procedures for Constitution1996 DB by Marco Oppel ©2025

/*
	////////////////////////
	Create stored procedures for API routes
	////////////////////////
*/

/*
	//////////////////
	MainSchema Stored Procedures
	//////////////////
*/

USE Constitution1996;
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetPreamble
AS
BEGIN
	SELECT SectionTitle AS Title, SectionText AS PreambleContents FROM MainSchema.Sections WHERE SectionID = 0; /* Get preamble */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetChapters
AS
BEGIN
	SELECT * FROM MainSchema.Chapters ORDER BY ChapterID ASC; /* Get chapter titles and ids */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetSections
AS
BEGIN
	SELECT SectionID, ChapterID, SectionTitle, SectionText FROM MainSchema.Sections ORDER BY SectionID ASC; /* Get section titles and ids */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetSectionsByChapterID
	@ChapterID int
AS
BEGIN
	SELECT SectionID, SectionTitle, SectionText FROM MainSchema.Sections s
	WHERE s.ChapterID = @ChapterID; /* Get sections per chapter */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetSubSectionsBySectionID
	@SectionID int
AS
BEGIN
	SELECT SubsectionID, SubsectionText FROM MainSchema.Subsections sub
	WHERE sub.SectionID = @SectionID; /* Get subsections per section */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetClausesOfSubsection
	@SubsectionID nvarchar(5),
	@SectionID int
AS
BEGIN
	SELECT c.SectionID, c.SubsectionID, ClauseID, ClauseText FROM MainSchema.Clauses c
	WHERE c.SectionID = @SectionID AND c.SubsectionID = @SubsectionID
	ORDER BY SubsectionID, ClauseID; /* Get clauses per subsection */
END
GO

CREATE OR ALTER PROCEDURE MainSchema.spGetNonDerogableRights
AS
BEGIN
	SELECT * FROM MainSchema.NonDerogableRights; /* Get the Non Derogable Rights table from Chapter 2 */
END
GO

/* END OF MAINSCHEMA STORED PROCEDURES */



/*
	//////////////////
	ScheduleSchema Stored Procedures
	//////////////////
*/

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleOne_NationalFlag
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleOne_NationalFlag; /* Get Schedule 1's contents */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleOneA_GeoAreasProvinces
AS
BEGIN
	SELECT Province, MapCSV FROM ScheduleSchema.ScheduleOneA_GeoAreasProvinces; /* Get Schedule 1A's contents */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleTwo_OathsAffirmations
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleTwo_OathsAffirmations; /* Get Schedule 2's main contents */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleTwo_Subsection
	@SectionID int
AS
BEGIN
	SELECT SectionID, SubsectionID, SubsectionText FROM ScheduleSchema.ScheduleTwo_Subsections WHERE SectionID = @SectionID; /* Get the subsections of a section in Schedule 2 */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleThree
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleThree_ElectionProcedures; /* Get Schedule 3's main contents */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleThree_Subsection
	@SectionID int,
	@SectionThreePart char(1)
AS
BEGIN
	SELECT SectionID, SubsectionID, SectionText FROM ScheduleSchema.ScheduleThree_Subsections WHERE @SectionID = SectionID AND @SectionThreePart = SectionThreePart; /* Get the subsections of a section in Schedule 3 */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleFour_ConcurrentCompetencies
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleFour_ConcurrentCompetencies; /* Get Schedule 4's contents */
END
GO


CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleFive_ExclusiveProvincialCompetencies
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleFive_ExclusiveProvincialCompetencies; /* Get Schedule 5's contents */
END
GO

CREATE OR ALTER PROCEDURE [ScheduleSchema].spGetScheduleSix_TransitionalArrangements
AS
BEGIN
	SELECT * FROM [ScheduleSchema].ScheduleSix_TransitionalArrangements ORDER BY SectionID ASC; /* Get section titles and ids of Schedule 6 */
END
GO


CREATE OR ALTER PROCEDURE [ScheduleSchema].spGetScheduleSix_Subsections
	@SectionID int
AS
BEGIN
	SELECT SubsectionID, SubsectionText FROM ScheduleSchema.ScheduleSix_Subsections sub
	WHERE sub.SectionID = @SectionID; /* Get subsections per section in Schedule 6 */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleSix_Clauses
	@SubsectionID nvarchar(5),
	@SectionID int
AS
BEGIN
	SELECT ClauseID, ClauseText FROM ScheduleSchema.ScheduleSix_Clauses scc
	WHERE scc.SectionID = @SectionID AND scc.SubsectionID = @SubsectionID; /* Get subsections per section in Schedule 6 */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetScheduleSeven_RepealedLaws
AS
BEGIN
	SELECT * FROM ScheduleSchema.ScheduleSeven_RepealedLaws; /* Get Schedule 7's contents */
END
GO



/* Annexures */
CREATE OR ALTER PROCEDURE ScheduleSchema.spGetAnnexures
AS
BEGIN
	SELECT * FROM ScheduleSchema.Annexures; /* Get the annexures' contents */
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetAnnexureSections
	@AnnexureID char(1),
	@SectionID int
AS
BEGIN
	SELECT @AnnexureID AS Annexure, anc.SectionID, anc.SectionTitle, anc.SectionText FROM ScheduleSchema.AnnexureContents anc
	WHERE anc.SectionID = @SectionID AND  anc.AnnexureID = @AnnexureID; /* Get sections of an annexure*/
END
GO

CREATE OR ALTER PROCEDURE ScheduleSchema.spGetAnnexureSubsections
	@AnnexureID char(1),
	@SectionID int
AS
BEGIN
	SELECT @AnnexureID AS Annexure,
	@SectionID AS SectionID, SubsectionID, ans.SectionText FROM ScheduleSchema.AnnexureSubsections ans
	WHERE ans.SectionID = @SectionID AND  ans.AnnexureID = @AnnexureID; /* Get subsections per section of an annexure */
END
GO


/* END OF SCHEDULESCHEMA STORED PROCEDURES */




/*
	//////////////////
	AmendmentSchema Stored Procedures
	//////////////////
*/

CREATE OR ALTER PROCEDURE AmendmentSchema.spGetAmendments
AS
BEGIN
	SELECT AmendmentTitle, DateOfEffect, Reference FROM AmendmentSchema.Amendments ORDER BY DateOfEffect; /* Gets amendments and related info about them */
END
GO

/* END OF AMENDMENTSCHEMA STORED PROCEDURES */
