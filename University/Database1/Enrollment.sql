CREATE TABLE [dbo].[Enrollment]
(
	[EnrollmentID]  INT IDENTITY (1, 1)   NOT NULL,
	[Grade]         DECIMAL      (3, 2)   NULL,
	[StudentID]     INT                   NOT NULL,
	[CourseID]      INT                   NOT NULL,
	PRIMARY KEY CLUSTERED ([EnrollmentID] ASC),
	CONSTRAINT [FK_dbo.Enrrollment_dbo.Course_CourseID] FOREIGN KEY ([CourseID])
		REFERENCES [dbo].[Course] ([CourseID]) ON DELETE CASCADE,
	CONSTRAINT [FK_dbo.Enrrollment_dbo.Student_StudentID] FOREIGN KEY ([StudentID])
		REFERENCES [dbo].[Student] ([StudentID]) ON DELETE CASCADE,
 )
