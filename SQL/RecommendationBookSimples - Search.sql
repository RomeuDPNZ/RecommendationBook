
USE recommendationbook;

DROP PROCEDURE IF EXISTS getSearchAdult;

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
