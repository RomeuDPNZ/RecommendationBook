
USE recommendationbook;

DROP PROCEDURE IF EXISTS getSearchRecommendersRecommendationBook;

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
