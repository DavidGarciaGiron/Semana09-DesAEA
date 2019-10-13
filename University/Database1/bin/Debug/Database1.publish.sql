/*
Script de implementación para UniversityDB

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "UniversityDB"
:setvar DefaultFilePrefix "UniversityDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creando [dbo].[Course]...';


GO
CREATE TABLE [dbo].[Course] (
    [CourseID] INT           IDENTITY (1, 1) NOT NULL,
    [Title]    NVARCHAR (50) NULL,
    [Credits]  INT           NULL,
    PRIMARY KEY CLUSTERED ([CourseID] ASC)
);


GO
PRINT N'Creando [dbo].[Enrollment]...';


GO
CREATE TABLE [dbo].[Enrollment] (
    [EnrollmentID] INT            IDENTITY (1, 1) NOT NULL,
    [Grade]        DECIMAL (3, 2) NULL,
    [StudentID]    INT            NOT NULL,
    [CourseID]     INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([EnrollmentID] ASC)
);


GO
PRINT N'Creando [dbo].[Student]...';


GO
CREATE TABLE [dbo].[Student] (
    [StudentID]      INT           IDENTITY (1, 1) NOT NULL,
    [LastName]       NVARCHAR (50) NULL,
    [FirstName]      NVARCHAR (50) NULL,
    [EnrollmentDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([StudentID] ASC)
);


GO
PRINT N'Creando [dbo].[FK_dbo.Enrrollment_dbo.Course_CourseID]...';


GO
ALTER TABLE [dbo].[Enrollment] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Enrrollment_dbo.Course_CourseID] FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course] ([CourseID]) ON DELETE CASCADE;


GO
PRINT N'Creando [dbo].[FK_dbo.Enrrollment_dbo.Student_StudentID]...';


GO
ALTER TABLE [dbo].[Enrollment] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Enrrollment_dbo.Student_StudentID] FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Student] ([StudentID]) ON DELETE CASCADE;


GO
/*
Plantilla de script posterior a la implementación							
--------------------------------------------------------------------------------------
 Este archivo contiene instrucciones de SQL que se anexarán al script de compilación.		
 Use la sintaxis de SQLCMD para incluir un archivo en el script posterior a la implementación.			
 Ejemplo:      :r .\miArchivo.sql								
 Use la sintaxis de SQLCMD para hacer referencia a una variable en el script posterior a la implementación.		
 Ejemplo:      :setvar TableName miTabla							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
MERGE INTO Course AS Target 
USING (VALUES
	(1, 'Economics', 3),
	(2, 'Literature', 3),
	(3, 'Chemistry', 4)
)
AS Source (CourseID, Title, Credits)
ON Target.CourseID = Source.CourseID
WHEN NOT MATCHED BY TARGET THEN
INSERT (Title, Credits)
VALUES (Title, Credits);

MERGE INTO Student AS Target 
USING (VALUES
	(1, 'Garcia', 'David', '2013-09-01'),
	(2, 'Granda', 'Piero', '2012-01-13'),
	(3, 'Torrico', 'Hugo', '2011-09-03')
)
AS Source (StudentID, LastName, FirstName, EnrollmentDate)
ON Target.StudentID = Source.StudentID
WHEN NOT MATCHED BY TARGET THEN
INSERT (LastName, FirstName, EnrollmentDate)
VALUES (LastName, FirstName, EnrollmentDate);

MERGE INTO Enrollment AS Target 
USING (VALUES
	(1, 2.00, 1, 1),
	(2, 3.50, 1, 2),
	(3, 4.00, 2, 3),
	(4, 1.00, 2, 1),
	(5, 4.00, 3, 1),
	(6, 3.00, 3, 2)
)
AS Source (EnrollmentID, Grade, StudentID, CourseID)
ON Target.EnrollmentID = Source.EnrollmentID
WHEN NOT MATCHED BY TARGET THEN
INSERT (Grade, StudentID, CourseID)
VALUES (Grade, StudentID, CourseID);
GO

GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Enrollment] WITH CHECK CHECK CONSTRAINT [FK_dbo.Enrrollment_dbo.Course_CourseID];

ALTER TABLE [dbo].[Enrollment] WITH CHECK CHECK CONSTRAINT [FK_dbo.Enrrollment_dbo.Student_StudentID];


GO
PRINT N'Actualización completada.';


GO
