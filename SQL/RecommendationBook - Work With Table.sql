
USE recommendationbook;

DROP PROCEDURE IF EXISTS getWorkWithTable;

DELIMITER // 
CREATE PROCEDURE getWorkWithTable(IN workWithTableRecommenderId SERIAL) 
BEGIN 

(SELECT id, type, thing as thingId, (Select fullName FROM SearchPersons WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Persons WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Person") 
UNION
(SELECT id, type, thing as thingId, (Select groupName FROM Groups WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Groups WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Group") 
UNION
(SELECT id, type, thing as thingId, (Select title FROM Books WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Books WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Book") 
UNION
(SELECT id, type, thing as thingId, (Select title FROM Movies WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Movies WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Movie") 
UNION
(SELECT id, type, thing as thingId, (Select name FROM Bands WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Bands WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Band") 
UNION
(SELECT id, type, thing as thingId, (Select title FROM Albums WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Albums WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Album") 
UNION
(SELECT id, type, thing as thingId, (Select title FROM Songs WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Songs WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Song") 
UNION
(SELECT id, type, thing as thingId, (Select name FROM Projects WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Projects WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Project") 
UNION
(SELECT id, type, thing as thingId, (Select name FROM Websites WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Websites WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Website") 
UNION
(SELECT id, type, thing as thingId, (Select name FROM Companies WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Companies WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Company") 
UNION
(SELECT id, type, thing as thingId, (Select name FROM Products WHERE id=WorkWith.thing) as thingName, (Select recommendations FROM Products WHERE id=WorkWith.thing) as recommendations, (Select id FROM Recommender WHERE id=WorkWith.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=WorkWith.recommender) as recommender, createdOn FROM WorkWith where recommender = workWithTableRecommenderId and type = "Product") 
ORDER BY createdOn DESC;

END // 
DELIMITER ;
