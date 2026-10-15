/*
CREATE LOGIN [NandaSurendra] 
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER [NandaSurendra] 
FOR LOGIN [NandaSurendra];

ALTER ROLE db_owner 
ADD MEMBER [NandaSurendra];
*/



if object_id('CoachRoster') is not null
drop table CoachRoster;
if object_id('WeeklyPredictionResults') is not null
    drop table WeeklyPredictionResults;
    if object_id('GamePrediction') is not null
    drop table GamePrediction;
if object_id('AppUser') is not null
    drop table AppUser; 
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
if object_id('PlayerPosition')
is not null drop table PlayerPosition; 
if object_id('Player')
is not null drop table  Player;
if object_id('Position') is not null 
drop table Position;    
if object_id('Coach')
is not null drop table Coach; 
if object_id('Game') is not null
    drop table Game;
if object_id('Team') is not null
    drop table Team;
if object_id('Conference') is not null
    drop table Conference;  
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

CREATE table Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName VARCHAR(50) NOT NULL,
    constraint PK_Conference PRIMARY KEY (ConferenceID),
    constraint UQ_ConferenceName UNIQUE (ConferenceName)
);

go

CREATE table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    ConferenceID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES STADIUM(StadiumID),
    constraint FK_Team_Conference FOREIGN KEY (ConferenceID) REFERENCES Conference(ConferenceID)
);

go

CREATE table Coach(
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(50) NOT NULL,
    constraint PK_Coach PRIMARY KEY (CoachID),
);


go


CREATE table CoachRoster (
    CoachRosterID INT NOT NULL IDENTITY(1,1),
    TeamID INT NOT NULL,
    CoachID INT NOT NULL,
    YearNumber INT NOT NULL,
    constraint PK_CoachRoster PRIMARY KEY (CoachRosterID),
    constraint UQ_CoachRoster UNIQUE (TeamID, CoachID, YearNumber),
    constraint FK_CoachRoster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    constraint FK_CoachRoster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID)
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


go

CREATE table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID),
    constraint UQ_PositionName UNIQUE (PositionName),
    constraint CK_PositionName CHECK (PositionName IN ('QB', 'RB', 'WR', 'TE', 'OL', 'DL', 'LB', 'DB', 'K', 'P'))
);

go

CREATE table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID),
    constraint UQ_PlayerName UNIQUE (PlayerName, PlayerDateOfBirth),
);


go

CREATE table PlayerPosition(
    PlayerPositionID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    PositionID INT NOT NULL,
    constraint PK_PlayerPosition PRIMARY KEY (PlayerPositionID),
    constraint UQ_PlayerPosition UNIQUE (PlayerID, PositionID),
    constraint FK_PlayerPosition_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerPosition_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

go


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



go

CREATE table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
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

CREATE table AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    AppUserFirstName VARCHAR(50) NOT NULL,
    AppUserLastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(100) NOT NULL,
    AppUserPasswordHash VARBINARY(64) NOT NULL,
    AppUserRole VARCHAR(128) NOT NULL,
    constraint PK_AppUser PRIMARY KEY (AppUserID),
    constraint UQ_AppUserEmail UNIQUE (AppUserEmail),
    constraint CK_AppUserRole Check (AppUserRole IN ('Admin', 'User'))
);

go

CREATE table GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    PredictedWinnerTeamID INT NOT NULL,
    PredictionDateTime DATETIME2 NOT NULL,
    PredictedMargin INT NOT NULL,
    constraint PK_GamePrediction PRIMARY KEY (GamePredictionID),
    constraint UQ_GamePrediction UNIQUE (AppUserID, GameID),
    constraint CK_PredictedMargin CHECK (PredictedMargin >= 0),
    constraint FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    constraint FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    constraint FK_GamePrediction_PredictedWinnerTeam FOREIGN KEY (PredictedWinnerTeamID) REFERENCES Team(TeamID)
);

go

CREATE table WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    AppUserID INT NOT NULL,
    StartDate DATE NOT NULL,
    NumberOfCorrectPredictions INT NOT NULL,
    TotalDifferenceFromPredictedMargins INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID),
    constraint UQ_WeeklyPredictionResults UNIQUE (AppUserID, StartDate),
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);
