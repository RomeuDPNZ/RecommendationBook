
/*
 *
 * Criado em: 30/08/2016
 *
 */

DROP TRIGGER AwaitingConfirmationOnInsert;
DROP TRIGGER LoginOnInsert;
DROP TRIGGER RecommenderOnInsert;
DROP TRIGGER AddRecOnInsert;
DROP TRIGGER SubscriptionOnInsert;
DROP TRIGGER ReadListOnInsert;
DROP TRIGGER WatchListOnInsert;
DROP TRIGGER ListenListOnInsert;
DROP TRIGGER PersonsOnInsert;
DROP TRIGGER CodeInjectionOnInsert;
DROP TRIGGER PageViewsOnInsert;
DROP TRIGGER ErrorsOnInsert;
DROP TRIGGER ResetPasswordOnInsert;

ALTER TABLE AwaitingConfirmation CHANGE email email CHAR(255) NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE password password CHAR(255) NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE code code CHAR(255) NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE nickName nickName CHAR(255) NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE officialWebsite officialWebsite CHAR(255) NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE sex sex enum('Male', 'Female', 'Other') NOT NULL;
ALTER TABLE AwaitingConfirmation CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE AwaitingConfirmation ADD gender CHAR(255) NOT NULL DEFAULT 'Pending';

ALTER TABLE Login CHANGE email email CHAR(255) NOT NULL UNIQUE;
ALTER TABLE Login CHANGE password password CHAR(255) NOT NULL;
ALTER TABLE Login CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE Login ADD enabled TINYINT NOT NULL DEFAULT 1;
ALTER TABLE Login ADD deletedByRecommender BOOLEAN NOT NULL DEFAULT '0';
ALTER TABLE Login ADD deletedByAdministrator BOOLEAN NOT NULL DEFAULT '0';
ALTER TABLE Login ADD deleteReason CHAR(255) NULL DEFAULT 'Approved';

ALTER TABLE Recommender CHANGE nickName nickName CHAR(255) NOT NULL;
ALTER TABLE Recommender CHANGE sex sex enum('Male', 'Female', 'Other') NOT NULL;
ALTER TABLE Recommender CHANGE officialWebsite officialWebsite CHAR(255) NOT NULL;
ALTER TABLE Recommender CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE Recommender ADD gender CHAR(255) NOT NULL DEFAULT 'Pending';

CREATE TABLE IF NOT EXISTS OtherOfficialWebsitesRecommender (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	other CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS OtherSocialNetworksRecommender (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	other CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS PhonesRecommender (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	phone CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS EmailsRecommender (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	email CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

INSERT INTO Actions (action) VALUES('Added the Entity'),('Recommended the Entity');

ALTER TABLE AddRec CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

UPDATE AddRec SET action=(SELECT id FROM Actions WHERE action LIKE 'Added the Entity') WHERE action IN (SELECT id FROM Actions WHERE action LIKE 'Added%');
UPDATE AddRec SET action=(SELECT id FROM Actions WHERE action LIKE 'Recommended the Entity') WHERE action IN (SELECT id FROM Actions WHERE action LIKE 'Recommended%') AND action NOT IN (SELECT id FROM Actions WHERE action LIKE 'Recommended the Recommender');

ALTER TABLE Subscription CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE TABLE IF NOT EXISTS List (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	name CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS RecommendedList (
	id SERIAL AUTO_INCREMENT,
	list BIGINT UNSIGNED NOT NULL REFERENCES List(id),
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS RecommenderList (
	id SERIAL AUTO_INCREMENT,
	list BIGINT UNSIGNED NOT NULL REFERENCES List(id),
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Books to Read' FROM ReadList WHERE stateRead='ToRead';
INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Books Already Read' FROM ReadList WHERE stateRead='Read';

INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Movies to Watch' FROM WatchList WHERE stateWatch='ToWatch';
INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Movies Already Watched' FROM WatchList WHERE stateWatch='Watched';

INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Albums to Listen' FROM ListenList WHERE stateListen='ToListen';
INSERT INTO List (recommender, name) SELECT DISTINCT recommender, 'Albums Already Listened' FROM ListenList WHERE stateListen='Listened';

INSERT INTO RecommendedList (list, recommended) SELECT List.id, ReadList.book FROM List, ReadList WHERE List.id IN (SELECT id FROM List WHERE name='Books to Read') AND ReadList.book IN (SELECT book FROM ReadList WHERE stateRead='ToRead') AND ReadList.recommender = List.recommender;
INSERT INTO RecommendedList (list, recommended) SELECT List.id, ReadList.book FROM List, ReadList WHERE List.id IN (SELECT id FROM List WHERE name='Books Already Read') AND ReadList.book IN (SELECT book FROM ReadList WHERE stateRead='Read') AND ReadList.recommender = List.recommender;

INSERT INTO RecommendedList (list, recommended) SELECT List.id, WatchList.movie FROM List, WatchList WHERE List.id IN (SELECT id FROM List WHERE name='Movies to Watch') AND WatchList.movie IN (SELECT movie FROM WatchList WHERE stateWatch='ToWatch') AND WatchList.recommender = List.recommender;
INSERT INTO RecommendedList (list, recommended) SELECT List.id, WatchList.movie FROM List, WatchList WHERE List.id IN (SELECT id FROM List WHERE name='Movies Already Watched') AND WatchList.movie IN (SELECT movie FROM WatchList WHERE stateWatch='Watched') AND WatchList.recommender = List.recommender;

INSERT INTO RecommendedList (list, recommended) SELECT List.id, ListenList.album FROM List, ListenList WHERE List.id IN (SELECT id FROM List WHERE name='Albums to Listen') AND ListenList.album IN (SELECT album FROM ListenList WHERE stateListen='ToListen') AND ListenList.recommender = List.recommender;
INSERT INTO RecommendedList (list, recommended) SELECT List.id, ListenList.album FROM List, ListenList WHERE List.id IN (SELECT id FROM List WHERE name='Albums Already Listened') AND ListenList.album IN (SELECT album FROM ListenList WHERE stateListen='Listened') AND ListenList.recommender = List.recommender;

CREATE TABLE IF NOT EXISTS RecommendedCategory (
	id SERIAL AUTO_INCREMENT,
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	category CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS RecommenderCategory (
	id SERIAL AUTO_INCREMENT,
	recommender BIGINT UNSIGNED NOT NULL REFERENCES Recommender(id),
	category CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

INSERT INTO RecommendedCategory (recommended, category) SELECT Recommended.id, RecommendedType.type FROM Recommended, RecommendedType WHERE Recommended.type=RecommendedType.id;

INSERT INTO RecommenderCategory (recommender, category) SELECT Recommender.id, 'Recommender' FROM Recommender;

ALTER TABLE Recommended CHANGE name name CHAR(255) NOT NULL;
ALTER TABLE Recommended DROP COLUMN type;
ALTER TABLE Recommended CHANGE officialWebsite officialWebsite CHAR(255) NOT NULL;
ALTER TABLE Recommended CHANGE descriptionImage descriptionImage CHAR(255) NOT NULL;
ALTER TABLE Recommended CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE TABLE IF NOT EXISTS OtherOfficialWebsitesRecommended (
	id SERIAL AUTO_INCREMENT,
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	other CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS OtherSocialNetworksRecommended (
	id SERIAL AUTO_INCREMENT,
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	other CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS PhonesRecommended (
	id SERIAL AUTO_INCREMENT,
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	phone CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS EmailsRecommended (
	id SERIAL AUTO_INCREMENT,
	recommended BIGINT UNSIGNED NOT NULL REFERENCES Recommended(id),
	email CHAR(255) NOT NULL,
	lastUpdatedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

ALTER TABLE Errors CHANGE createdOn createdOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
