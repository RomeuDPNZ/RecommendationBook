
CREATE TABLE IF NOT EXISTS Countries (
	id SERIAL AUTO_INCREMENT,
	country CHAR(55) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO Countries (country) VALUES('World Wide Entity'),
('Afghanistan'),
('Albania'),
('Algeria'),
('Andorra'),
('Angola'),
('Antigua and Barbuda'),
('Argentina'),
('Armenia'),
('Australia'),
('Austria'),
('Azerbaijan'),
('Bahamas'),
('Bahrain'),
('Bangladesh'),
('Barbados'),
('Belarus'),
('Belgium'),
('Belize'),
('Benin'),
('Bolivia'),
('Bosnia and Herzegovina'),
('Botswana'),
('Brazil'),
('Brunei'),
('Bulgaria'),
('Burkina Faso'),
('Burma'),
('Burundi'),
('Cambodia'),
('Cameroon'),
('Canada'),
('Cape Verde'),
('Central African Republic'),
('Chad'),
('Chile'),
('China'),
('Hong Kong'),
('Macau'),
('Colombia'),
('Comoros'),
('Congo, Democratic Republic of the Congo-Kinshasa'),
('Congo, Republic of the Congo-Brazzaville'),
('Costa Rica'),
('Cote d Ivoire'),
('Croatia'),
('Cuba'),
('Cyprus'),
('Czech Republic'),
('Denmark'),
('Djibouti'),
('Dominica'),
('Dominican Republic'),
('East Timor'),
('Ecuador'),
('Egypt'),
('El Salvador'),
('Equatorial Guinea'),
('Eritrea'),
('Estonia'),
('Ethiopia'),
('Fiji'),
('Finland'),
('France'),
('Gabon'),
('The Gambia'),
('Georgia'),
('Germany'),
('Ghana'),
('Greece'),
('Grenada'),
('Guatemala'),
('Guinea'),
('Guinea-Bissau'),
('Guyana'),
('Haiti'),
('Honduras'),
('Hungary'),
('Iceland'),
('India'),
('Indonesia'),
('Iran'),
('Iraq'),
('Ireland'),
('Israel'),
('Italy'),
('Jamaica'),
('Japan'),
('Jordan'),
('Kazakhstan'),
('Kenya'),
('Kiribati'),
('Korea, North'),
('Korea, South'),
('Kuwait'),
('Kyrgyzstan'),
('Laos'),
('Latvia'),
('Lebanon'),
('Lesotho'),
('Liberia'),
('Libya'),
('Liechtenstein'),
('Lithuania'),
('Luxembourg'),
('Macedonia'),
('Madagascar'),
('Malawi'),
('Malaysia'),
('Maldives'),
('Mali'),
('Malta'),
('Marshall Islands'),
('Mauritania'),
('Mauritius'),
('Mexico'),
('Micronesia'),
('Moldova'),
('Monaco'),
('Mongolia'),
('Montenegro'),
('Morocco'),
('Mozambique'),
('Namibia'),
('Nauru'),
('Nepal'),
('Netherlands'),
('New Zealand'),
('Nicaragua'),
('Niger'),
('Nigeria'),
('Norway'),
('Oman'),
('Pakistan'),
('Palau'),
('Panama'),
('Papua New Guinea'),
('Paraguay'),
('Peru'),
('Philippines'),
('Poland'),
('Portugal'),
('Qatar'),
('Romania'),
('Russia'),
('Rwanda'),
('Saint Kitts and Nevis'),
('Saint Lucia'),
('Saint Vincent and the Grenadines'),
('Samoa'),
('San Marino'),
('São Tomé and Príncipe'),
('Saudi Arabia'),
('Senegal'),
('Serbia'),
('Seychelles'),
('Sierra Leone'),
('Singapore'),
('Slovakia'),
('Slovenia'),
('Solomon Islands'),
('Somalia'),
('South Africa'),
('South Sudan'),
('Spain'),
('Sri Lanka'),
('Sudan'),
('Suriname'),
('Swaziland'),
('Sweden'),
('Switzerland'),
('Syria'),
('Tajikistan'),
('Tanzania'),
('Thailand'),
('Togo'),
('Tonga'),
('Trinidad and Tobago'),
('Tunisia'),
('Turkey'),
('Turkmenistan'),
('Tuvalu'),
('Uganda'),
('Ukraine'),
('United Arab Emirates'),
('United Kingdom'),
('United States'),
('Uruguay'),
('Uzbekistan'),
('Vanuatu'),
('Venezuela'),
('Vietnam'),
('Yemen'),
('Zambia'),
('Zimbabwe');

CREATE TABLE IF NOT EXISTS AwaitingConfirmation (
	id SERIAL AUTO_INCREMENT,
	email CHAR(100) NOT NULL,
	password CHAR(50) NOT NULL,
	role enum('Recommender', 'Administrator') NOT NULL DEFAULT 'Recommender',
	code CHAR(50) NOT NULL,
	nickName CHAR(50) NOT NULL,
	sex enum('Male', 'Female') NOT NULL,
	country TINYINT UNSIGNED NOT NULL REFERENCES Countries(id),
	birthDate DATE NOT NULL,
	officialWebsite CHAR(100),
	about TEXT,
	extensionImage CHAR(10),
	image MEDIUMBLOB,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER AwaitingConfirmationOnInsert BEFORE INSERT ON `AwaitingConfirmation` FOR EACH ROW SET NEW.createdOn = NOW();

/*O campo email na tabela Login deve ser UNIQUE */

CREATE TABLE IF NOT EXISTS Login (
	id SERIAL AUTO_INCREMENT,
	email CHAR(100) NOT NULL UNIQUE,
	password CHAR(50) NOT NULL,
	role enum('Recommender', 'Administrator') NOT NULL DEFAULT 'Recommender',
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER LoginOnInsert BEFORE INSERT ON `Login` FOR EACH ROW SET NEW.createdOn = NOW();

/*O campo nickName na tabela Recommender deve ser UNIQUE */

CREATE TABLE IF NOT EXISTS Recommender (
	id SERIAL AUTO_INCREMENT,
	login BIGINT UNSIGNED NOT NULL REFERENCES Login(id),
	recommendations BIGINT UNSIGNED NOT NULL,
	pageViews BIGINT UNSIGNED NOT NULL,
	nickName CHAR(50) NOT NULL UNIQUE,
	sex enum('Male', 'Female') NOT NULL,
	country TINYINT UNSIGNED NOT NULL REFERENCES Countries(id),
	birthDate DATE NOT NULL,
	showSex BOOLEAN NOT NULL DEFAULT '1',
	showCountry BOOLEAN NOT NULL DEFAULT '1',
	showBirth BOOLEAN NOT NULL DEFAULT '1',
	officialWebsite CHAR(100),
	about TEXT,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id, nickName)
);

CREATE TRIGGER RecommenderOnInsert BEFORE INSERT ON `Recommender` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS Actions (
	id SERIAL AUTO_INCREMENT,
	action CHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO Actions (action) VALUES('Added the Person'), 
('Added the Group'), 
('Added the Book'), 
('Added the Movie'), 
('Added the Band'), 
('Added the Album'),
('Added the Song'), 
('Added the Project'), 
('Added the Website'), 
('Added the Company'), 
('Added the Product'), 
('Added the Place'), 
('Added the Food'), 
('Added the Game'), 
('Added the Gun'), 
('Added the Knife'), 
('Added the Car'), 
('Added the Motorcycle'), 
('Recommended the Person'), 
('Recommended the Group'), 
('Recommended the Book'), 
('Recommended the Movie'), 
('Recommended the Band'), 
('Recommended the Album'), 
('Recommended the Song'), 
('Recommended the Project'), 
('Recommended the Website'), 
('Recommended the Company'), 
('Recommended the Product'), 
('Recommended the Place'), 
('Recommended the Food'), 
('Recommended the Game'),
('Recommended the Gun'),
('Recommended the Knife'),
('Recommended the Car'),
('Recommended the Motorcycle'),
('Recommended the Recommender');

CREATE TABLE IF NOT EXISTS AddRec (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	addRec BIGINT UNSIGNED NOT NULL,
	action TINYINT UNSIGNED NOT NULL REFERENCES Actions(id),
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER AddRecOnInsert BEFORE INSERT ON `AddRec` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS Subscription (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	subscriber BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER SubscriptionOnInsert BEFORE INSERT ON `Subscription` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS ReadList (
	id SERIAL AUTO_INCREMENT,
	book BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	stateRead enum('ToRead', 'Read'),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER ReadListOnInsert BEFORE INSERT ON `ReadList` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS WatchList (
	id SERIAL AUTO_INCREMENT,
	movie BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	stateWatch enum('ToWatch', 'Watched'),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER WatchListOnInsert BEFORE INSERT ON `WatchList` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS ListenList (
	id SERIAL AUTO_INCREMENT,
	album BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	stateListen enum('ToListen', 'Listened'),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER ListenListOnInsert BEFORE INSERT ON `ListenList` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS RecommendedType (
	id SERIAL AUTO_INCREMENT,
	type CHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO RecommendedType (type) VALUES('Person'), 
('Group'), 
('Book'), 
('Movie'), 
('Band'), 
('Album'), 
('Song'), 
('Project'), 
('Website'), 
('Company'), 
('Product'), 
('Place'), 
('Food'), 
('Game'),
('Gun'),
('Knife'),
('Car'),
('Motorcycle');

CREATE TABLE IF NOT EXISTS Recommended (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	recommendations BIGINT UNSIGNED NOT NULL,
	pageViews BIGINT UNSIGNED NOT NULL,
	name CHAR(50) NOT NULL,
	type SMALLINT UNSIGNED NOT NULL REFERENCES RecommendedType(id),
	country TINYINT UNSIGNED NOT NULL REFERENCES Countries(id),
	officialWebsite CHAR(100),
	about TEXT,
	descriptionImage CHAR(150),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER PersonsOnInsert BEFORE INSERT ON `Recommended` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS CodeInjection (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	ip CHAR(20) NOT NULL,
	codeInjection TINYTEXT NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER CodeInjectionOnInsert BEFORE INSERT ON `CodeInjection` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE TABLE IF NOT EXISTS PageViews (
	id SERIAL AUTO_INCREMENT,
	page CHAR(100) NOT NULL,
	pageViews BIGINT UNSIGNED NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER PageViewsOnInsert BEFORE INSERT ON `PageViews` FOR EACH ROW SET NEW.createdOn = NOW();

INSERT INTO PageViews (page,pageViews) VALUES('About',0), 
('AddRecommended',0), 
('AddRecommender',0), 
('SaveRecommended',0), 
('SaveRecommender',0), 
('BeforeUpdateRecommended',0), 
('BeforeUpdateRecommender',0), 
('BeforeDeleteRecommended',0),
('SaveUpdateRecommended',0), 
('SaveUpdateRecommender',0), 
('SaveDeleteRecommended',0), 
('DoLogin',0), 
('Login',0), 
('DoResetPassword',0), 
('ResetPassword',0), 
('DoSearch',0),
('DoRecommendersRBSearch',0),
('Search',0), 
('Error',0), 
('index',0), 
('Login',0), 
('LogOut',0), 
('Contact',0), 
('ContactValidation',0), 
('MessageToRecommender',0);

CREATE TABLE IF NOT EXISTS Errors (
	id SERIAL AUTO_INCREMENT,
	message TEXT NOT NULL,
	stacktrace TEXT NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn DATETIME,
	PRIMARY KEY (id)
);

CREATE TRIGGER ErrorsOnInsert BEFORE INSERT ON `Errors` FOR EACH ROW SET NEW.createdOn = NOW();

CREATE VIEW MostRecommendedRecommenders AS SELECT id, nickName as name, recommendations FROM Recommender ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedPersons AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Person') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedGroups AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Group') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedBooks AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Book') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedMovies AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Movie') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedBands AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Band') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedAlbums AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Album') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedSongs AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Song') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedProjects AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Project') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedWebsites AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Website') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedCompanies AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Company') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedProducts AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Product') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedPlaces AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Place') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedFoods AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Food') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedGames AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Game') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedGuns AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Gun') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedKnives AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Knife') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedCars AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Car') ORDER BY recommendations DESC LIMIT 10;

CREATE VIEW MostRecommendedMotorcycles AS SELECT id, name, recommendations FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type='Motorcycle') ORDER BY recommendations DESC LIMIT 10;

/* Cuidado com as quebras de linha nas comparações de strings como Actions.action != 'Recommended the Recommender' */

DELIMITER // 
CREATE PROCEDURE getSubscriptionInformation(IN recommenderId BIGINT,IN limitForRecommender INT,IN age INT) 
BEGIN 

(SELECT Recommender.nickName, Recommender.id, Actions.action as RAction, Recommended.name as thingName, Recommended.id as ThingId, AddRec.createdOn FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Recommended ON AddRec.addRec=Recommended.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action != 'Recommended the Recommender' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, Recommender.id, Actions.action, (SELECT Recommender.nickName FROM Recommender WHERE id=AddRec.addRec), (SELECT Recommender.id FROM Recommender WHERE id=AddRec.addRec), AddRec.createdOn FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE Actions.action='Recommended the Recommender' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
ORDER BY createdOn DESC LIMIT limitForRecommender;

END // 
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE getSearchAdult(IN search CHAR(250), IN searchLimit INT) 
BEGIN 

SET @wildcardSearch = CONCAT("%",search,"%"); 

(SELECT 1 as ordem, (Select type FROM RecommendedType WHERE id=Recommended.type) as type, id, name, recommendations, (Select id FROM Recommender WHERE id=Recommended.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=Recommended.recommender) as recommender FROM Recommended WHERE name = search) 
UNION 
(SELECT 2 as ordem, (Select type FROM RecommendedType WHERE id=Recommended.type) as type, id, name, recommendations, (Select id FROM Recommender WHERE id=Recommended.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=Recommended.recommender) as recommender FROM Recommended WHERE name SOUNDS LIKE search OR name LIKE @wildcardSearch) 

UNION 
(SELECT 1 as ordem, "Recommender" as type, id, nickName as name, recommendations, id as recommenderId, nickName as recommender FROM Recommender WHERE nickName = search) 
UNION 
(SELECT 2 as ordem, "Recommender" as type, id, nickName as name, recommendations, id as recommenderId, nickName as recommender FROM Recommender WHERE nickName SOUNDS LIKE search OR nickName LIKE @wildcardSearch) 

ORDER BY ordem ASC, recommendations DESC LIMIT searchLimit;

END // 
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE getSearchRecommendersRecommendationBook(IN search CHAR(250), IN searchRegex CHAR(250), IN searchLimit INT, IN recId BIGINT) 
BEGIN 

SET @wildcardSearch = CONCAT("%",search,"%"); 

(SELECT 1 as ordem, Actions.action as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM AddRec INNER JOIN Recommended ON AddRec.addRec=Recommended.id INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action != 'Recommended the Recommender' AND name = search) 
UNION 
(SELECT 2 as ordem, Actions.action as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM AddRec INNER JOIN Recommended ON AddRec.addRec=Recommended.id INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action != 'Recommended the Recommender' AND (name SOUNDS LIKE search OR name LIKE @wildcardSearch)) 
UNION 
(SELECT 3 as ordem, Actions.action as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM AddRec INNER JOIN Recommended ON AddRec.addRec=Recommended.id INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action != 'Recommended the Recommender' AND name REGEXP searchRegex) 

UNION 
(SELECT 1 as ordem, 'Recommended the Recommender' as RAction, Recommender.id as id, nickName as name, Recommender.recommendations as recommendations FROM AddRec INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action = 'Recommended the Recommender' AND nickName = search) 
UNION 
(SELECT 2 as ordem, 'Recommended the Recommender' as RAction, Recommender.id as id, nickName as name, Recommender.recommendations as recommendations FROM AddRec INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action = 'Recommended the Recommender' AND (nickName SOUNDS LIKE search OR nickName LIKE @wildcardSearch)) 
UNION 
(SELECT 3 as ordem, 'Recommended the Recommender' as RAction, Recommender.id as id, nickName as name, Recommender.recommendations as recommendations FROM AddRec INNER JOIN Recommender ON AddRec.recommender=recId INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action = 'Recommended the Recommender' AND nickName REGEXP searchRegex) 

UNION 
(SELECT 1 as ordem, IF(WatchList.stateWatch = 'ToWatch','To-Watch','Watched') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM WatchList INNER JOIN Recommended ON WatchList.movie=Recommended.id AND WatchList.recommender=recId WHERE name = search) 
UNION 
(SELECT 2 as ordem, IF(WatchList.stateWatch = 'ToWatch','To-Watch','Watched') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM WatchList INNER JOIN Recommended ON WatchList.movie=Recommended.id AND WatchList.recommender=recId WHERE name SOUNDS LIKE search OR name LIKE @wildcardSearch) 
UNION 
(SELECT 3 as ordem, IF(WatchList.stateWatch = 'ToWatch','To-Watch','Watched') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM WatchList INNER JOIN Recommended ON WatchList.movie=Recommended.id AND WatchList.recommender=recId WHERE name REGEXP searchRegex) 

UNION 
(SELECT 1 as ordem, IF(ListenList.stateListen = 'ToListen','To-Listen','Listened') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ListenList INNER JOIN Recommended ON ListenList.album=Recommended.id AND ListenList.recommender=recId WHERE name = search) 
UNION 
(SELECT 2 as ordem, IF(ListenList.stateListen = 'ToListen','To-Listen','Listened') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ListenList INNER JOIN Recommended ON ListenList.album=Recommended.id AND ListenList.recommender=recId WHERE name SOUNDS LIKE search OR name LIKE @wildcardSearch) 
UNION 
(SELECT 3 as ordem, IF(ListenList.stateListen = 'ToListen','To-Listen','Listened') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ListenList INNER JOIN Recommended ON ListenList.album=Recommended.id AND ListenList.recommender=recId WHERE name REGEXP searchRegex) 

UNION 
(SELECT 1 as ordem, IF(ReadList.stateRead = 'ToRead','To-Read','Read') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ReadList INNER JOIN Recommended ON ReadList.book=Recommended.id AND ReadList.recommender=recId WHERE name = search) 
UNION 
(SELECT 2 as ordem, IF(ReadList.stateRead = 'ToRead','To-Read','Read') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ReadList INNER JOIN Recommended ON ReadList.book=Recommended.id AND ReadList.recommender=recId WHERE name SOUNDS LIKE search OR name LIKE @wildcardSearch) 
UNION 
(SELECT 3 as ordem, IF(ReadList.stateRead = 'ToRead','To-Read','Read') as RAction, Recommended.id as id, name as name, Recommended.recommendations as recommendations FROM ReadList INNER JOIN Recommended ON ReadList.book=Recommended.id AND ReadList.recommender=recId WHERE name REGEXP searchRegex) 

ORDER BY ordem ASC LIMIT searchLimit;

END // 
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE getRecommenderAge(IN recommenderId BIGINT) 
BEGIN 

SELECT TIMESTAMPDIFF(YEAR,birthDate,CURDATE()) AS age FROM Recommender WHERE id=recommenderId;

END // 
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE getPersonAge(IN personId BIGINT) 
BEGIN 

SELECT TIMESTAMPDIFF(YEAR,birthDate,CURDATE()) AS age FROM Persons WHERE id=personId;

END // 
DELIMITER ;
