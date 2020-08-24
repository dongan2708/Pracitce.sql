CREATE DATABASE MyBlog
GO
USE MyBlog
GO
CREATE TABLE Users (
	UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserName varchar(20) NOT NULL,
	Password varchar(30) NOT NULL,
	Email varchar(30) NOT NULL UNIQUE,
	Address nvarchar(200),
)
GO

CREATE TABLE Posts(
PostID int IDENTITY(1,1) NOT NULL PRIMARY KEY ,
Title nvarchar(200) NOT NULL,
Content nvarchar (MAX) NOT NULL,
Tag nvarchar(100) NULL,
Status bit,
CreateTime datetime DEFAULT(getdate()),
UpdateTime datetime,
UsereID int,
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

GO
CREATE TABLE Comments(
CommentID int INDENTITY(1,1) NOT NULL PRIMARY KEY,
Content nvarchar(500),
Status bit,
CreateTime datetime DFEAULT(getdate()),
Author nvarchar(30),
Email varchar(50) NOT NULL,
PostID int,
FOREIGN KEY(PostID) REFERENCES Posts(PostsID))
)
GO

ALTER TABLE Comments
ADD CHECK (Email like '%@%')

ALTER TABLE Users
ADD CHECK (Email like '%@%')

CREATE INDEX IX_UserName
ON User(userName)

---
INSERT INTO Users VALUES('Nguyen Van A','123123','NVA@gmail,com','Ha Noi')
INSERT INTO Users VALUES('Nguyen Van A2','1234123','NVA2@gmail.com','Cau Giay')
INSERT INTO Users VALUES('Nguyen Van A3','12345123','NVA3@gmail.com','Thanh Xuan')

INSERT INTO Posts VALUES ('Hello', N'Hello hello', 'Social', 'true', getdate(),getdate(), 1 )
INSERT INTO Posts VALUES ('Hello2', N'Hello hello', 'hello2', 'true', getdate(),getdate(), 2 )
INSERT INTO Posts VALUES ('Hello3', N'Hello hello', 'hello3', 'true', getdate(),getdate(), 3 )

INSERT INTO Comments VALUES ('Chao tat ca cac ban','true', getdate()+5, 'Nguyen Van A','NVA@gmail.com', 1)
INSERT INTO Comments VALUES ('Hello anh em','true', getdate()-4, 'Canhars','canhars@gmail.com', 2)
INSERT INTO Comments VALUES ('Chao tat ca cac ban lan 2','true', getdate()-40, 'Hunghoi','NVA@gmail.com', 3)

SELECT * FROM Posts WHERE Tag = 'Social'

SELECT * FROM Posts WHERE UserID in (SELECT UserID From Users WHERE Email='NVA@gmail.com')

SELECT COUNT(*) as Count FROM Comments

CREATE VIEW v_NewPost AS
SELECT  TOP 2 dbo.Posts.Title, dbo.Users.UserName, dbo.Posts.CreateTime
FROM            dbo.Posts INNER JOIN
                         dbo.Users ON dbo.Posts.UserID = dbo.Users.UserID
ORDER BY dbo.Posts.CreateTime DESC

CREATE Procedure sp_GetComment 
	@PostID int
AS
BEGIN
	select * from Comments where PostID = @PostID
END

GO

CREATE TRIGGER tg_UpdateTime
ON Posts
AFTER  INSERT,UPDATE AS
BEGIN
   UPDATE Posts 
   SET UpdateTime = GETDATE()
   FROM Posts
   JOIN deleted ON Posts.PostID = deleted.PostID    
END