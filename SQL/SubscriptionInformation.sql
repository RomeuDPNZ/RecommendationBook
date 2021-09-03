USE RecommendationBook;

DROP VIEW IF EXISTS SubscriptionInformation;
DROP PROCEDURE IF EXISTS getSubscriptionInformation;

DELIMITER // 
CREATE PROCEDURE getSubscriptionInformation(IN recommenderId BIGINT,IN limitForRecommender INT,IN age INT) 
BEGIN 

(SELECT Recommender.nickName, CONCAT(Actions.action,': ',(Select occupation FROM Occupations WHERE id=Persons.primaryOccupation)) as RAction, CONCAT(Persons.firstName,' ',Persons.lastName) as name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Persons ON AddRec.addRec=Persons.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE Actions.action='Added the Person' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, Actions.action, Groups.groupName, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Groups ON AddRec.addRec=Groups.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Group' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, Actions.action, Books.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Books ON AddRec.addRec=Books.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Book' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Books.category NOT IN (SELECT id FROM BookCategories WHERE category='Fiction - Erotic' OR category='Nonfiction - Erotic')),(Books.category=Books.category)))
UNION
(SELECT Recommender.nickName, Actions.action, Movies.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Movies ON AddRec.addRec=Movies.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Movie' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Movies.genre NOT IN (SELECT id FROM MovieGenres WHERE genre='Erotic')),(Movies.genre=Movies.genre))) 
UNION
(SELECT Recommender.nickName, Actions.action, Bands.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Bands ON AddRec.addRec=Bands.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Band' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Bands.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Bands.genre=Bands.genre))) 
UNION
(SELECT Recommender.nickName, Actions.action, Albums.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Albums ON AddRec.addRec=Albums.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Album' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Albums.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Albums.genre=Albums.genre)))  
UNION
(SELECT Recommender.nickName, Actions.action, Songs.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Songs ON AddRec.addRec=Songs.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Song' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Songs.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Songs.genre=Songs.genre)))  
UNION
(SELECT Recommender.nickName, Actions.action, Projects.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Projects ON AddRec.addRec=Projects.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Project' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Projects.category NOT IN (SELECT id FROM ProjectsCategory WHERE category='Erotic')),(Projects.category=Projects.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Websites.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Websites ON AddRec.addRec=Websites.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Website' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Websites.category NOT IN (SELECT id FROM WebsitesCategory WHERE category='Erotic')),(Websites.category=Websites.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Companies.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Companies ON AddRec.addRec=Companies.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Company' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Companies.category NOT IN (SELECT id FROM CompaniesCategory WHERE category='Erotic')),(Companies.category=Companies.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Products.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Products ON AddRec.addRec=Products.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Added the Product' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Products.category NOT IN (SELECT id FROM ProductsCategory WHERE category='Erotic')),(Products.category=Products.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, (SELECT Recommender.nickName FROM Recommender WHERE id=AddRec.addRec), AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Recommender' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, CONCAT(Actions.action,': ',(Select occupation FROM Occupations WHERE id=Persons.primaryOccupation)) as RAction, CONCAT(Persons.firstName,' ',Persons.lastName) as name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Persons ON AddRec.addRec=Persons.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE Actions.action='Recommended the Person' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, Actions.action, Groups.groupName, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Groups ON AddRec.addRec=Groups.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Group' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId)) 
UNION
(SELECT Recommender.nickName, Actions.action, Books.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Books ON AddRec.addRec=Books.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Book' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Books.category NOT IN (SELECT id FROM BookCategories WHERE category='Fiction - Erotic' OR category='Nonfiction - Erotic')),(Books.category=Books.category)))
UNION
(SELECT Recommender.nickName, Actions.action, Movies.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Movies ON AddRec.addRec=Movies.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Movie' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Movies.genre NOT IN (SELECT id FROM MovieGenres WHERE genre='Erotic')),(Movies.genre=Movies.genre))) 
UNION
(SELECT Recommender.nickName, Actions.action, Bands.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Bands ON AddRec.addRec=Bands.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Band' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Bands.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Bands.genre=Bands.genre))) 
UNION
(SELECT Recommender.nickName, Actions.action, Albums.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Albums ON AddRec.addRec=Albums.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Album' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Albums.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Albums.genre=Albums.genre)))  
UNION
(SELECT Recommender.nickName, Actions.action, Songs.title, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Songs ON AddRec.addRec=Songs.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Song' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Songs.genre NOT IN (SELECT id FROM MusicGenres WHERE genre='Erotic')),(Songs.genre=Songs.genre)))  
UNION
(SELECT Recommender.nickName, Actions.action, Projects.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Projects ON AddRec.addRec=Projects.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Project' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Projects.category NOT IN (SELECT id FROM ProjectsCategory WHERE category='Erotic')),(Projects.category=Projects.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Websites.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Websites ON AddRec.addRec=Websites.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Website' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Websites.category NOT IN (SELECT id FROM WebsitesCategory WHERE category='Erotic')),(Websites.category=Websites.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Companies.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Companies ON AddRec.addRec=Companies.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Company' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Companies.category NOT IN (SELECT id FROM CompaniesCategory WHERE category='Erotic')),(Companies.category=Companies.category))) 
UNION
(SELECT Recommender.nickName, Actions.action, Products.name, AddRec.ts FROM AddRec INNER JOIN Recommender ON AddRec.recommender=Recommender.id INNER JOIN Products ON AddRec.addRec=Products.id INNER JOIN Actions ON Actions.id=AddRec.action WHERE 
Actions.action='Recommended the Product' AND AddRec.recommender IN (SELECT recommender FROM Subscription WHERE subscriber=recommenderId) AND IF(age<18,(Products.category NOT IN (SELECT id FROM ProductsCategory WHERE category='Erotic')),(Products.category=Products.category))) 
ORDER BY ts DESC LIMIT limitForRecommender;

END // 
DELIMITER ;
