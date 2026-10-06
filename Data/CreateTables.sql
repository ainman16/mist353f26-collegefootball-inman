/*
CREATE LOGIN [NandaSurendra] 
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER [NandaSurendra] 
FOR LOGIN [NandaSurendra];

ALTER ROLE db_owner 
ADD MEMBER [NandaSurendra];
*/

if object_id('PunterStats')   
is not null drop table PunterStats;
if object_id('KickerStats')   
is not null drop table KickerStats;
if object_id('ReturnerStats') 
is not null drop table ReturnerStats;
if object_id('DefenderStats') 
is not null drop table DefenderStats;
if object_id('RBStats') 
is not null drop table RBStats;
if object_id('QBStats') 
is not null drop table QBStats;
if object_id('PlayerStats') 
is not null drop table PlayerStats;
if object_id('Roster') 
is not null drop table Roster;
if object_id('Player') 
is not null drop table Player;
if object_id('Position') is not null 
drop table Position;
if object_id('Game') is not null
    drop table Game;
if object_id('Team') is not null
    drop table Team;
if object_id('Stadium') is not null
    drop table Stadium;

go 


CREATE table STADIUM (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCapacity INT NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState VARCHAR(2) NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID),
    constraint UQ_StadiumName UNIQUE (StadiumName),
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go


CREATE table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_UniversityName UNIQUE (UniversityName)
);


go

CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID),
    constraint UQ_Game UNIQUE (GameDate, GameTime),
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES STADIUM(StadiumID)
);

CREATE table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID),
    constraint UQ_PositionName UNIQUE (PositionName)
);

CREATE table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    PositionID INT NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID),
    constraint UQ_PlayerName UNIQUE (PlayerName, PlayerDateOfBirth),
    constraint FK_Player_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

CREATE table Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    TeamID INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    YearNumber INT NOT NULL,
    Position VARCHAR(50) NOT NULL,
    constraint PK_Roster PRIMARY KEY (RosterID),
    constraint UQ_Roster UNIQUE (PlayerID, YearNumber),
    constraint FK_Roster_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

CREATE table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    Position VARCHAR(50) NOT NULL,
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    constraint PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    constraint FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID),
);

CREATE table QBStats (
    QBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Attempts INT NOT NULL,
    Completions INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    INTs INT NOT NULL,
constraint PK_QBStats PRIMARY KEY (QBStatsID),
    constraint FK_QBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);

CREATE table RBStats (
    RBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Carries INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    Long INT NOT NULL,
    Fumbles INT NOT NULL,
    constraint PK_RBStats PRIMARY KEY (RBStatsID),
    constraint FK_RBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);

CREATE table DefenderStats (
    DefenderStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks INT NOT NULL,
    Interceptions INT NOT NULL,
    DefensiveTDs INT NOT NULL,
    constraint PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    constraint FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);

CREATE table ReturnerStats (
    ReturnerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    KickOffAttempts INT NOT NULL,
    KickOffYards INT NOT NULL,
    KickOffLong INT NOT NULL,
    KickOffTDs INT NOT NULL,
    PuntReturnAttempts INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntReturnLong INT NOT NULL,
    PuntReturnTDs INT NOT NULL,
    constraint PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    constraint FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);

CREATE table KickerStats (
    KickerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    FieldGoalAttempts INT NOT NULL,
    FieldGoalsMade INT NOT NULL,
    Long INT NOT NULL,
    ExtraPointAttempts INT NOT NULL,
    ExtraPointsMade INT NOT NULL,
    constraint PK_KickerStats PRIMARY KEY (KickerStatsID),
    constraint FK_KickerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);

CREATE table PunterStats (
    PunterStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Punts INT NOT NULL,
    Yards INT NOT NULL,
    Long INT NOT NULL,
    constraint PK_PunterStats PRIMARY KEY (PunterStatsID),
    constraint FK_PunterStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
);


