MATCH (m:Movie)-[ms:MOVIE_STAR]->(s:Star)
MATCH (m:Movie)-->(y:Year)
WITH y, (SUM(toInt(ms.count)*toFloat(s.id)))/SUM(toInt(ms.count)) AS AVG_RATING, SUM(toInt(ms.count)) AS count, m.title AS Title
WHERE count > 10 return Title, AVG_RATING, y.year AS sub order by sub desc, AVG_RATING desc limit 10;

MATCH (m:Movie {id:1})-[ms:MOVIE_STAR]-(s:Star) with (SUM(toInt(ms.count)*toFloat(s.id)))/SUM(toInt(ms.count)) AS AVG_RATING, SUM(toInt(ms.count)) AS count MATCH (y:Year)--(m:Movie {id:1})-->(t) return *;

MATCH (m:Movie)-[s:SCORE]->(t:Tag)
where (toFloat(s.relevance) > 0.9 AND t.id = 19)
with collect(m) AS movies
MATCH (m2:Movie)-[s2:SCORE]->(t2:Tag)
where toFloat(s2.relevance) > 0.9 AND t2.id = 159 AND m2 IN movies
with collect(m2) AS movies2
MATCH (m3:Movie)-[s3:SCORE]->(t3:Tag)
where toFloat(s3.relevance) > 0.9 AND t3.id = 18 AND m3 IN movies2
return m3;


MATCH (m:Movie)-[ms:MOVIE_STAR]->(s:Star)
with split(replace(replace(ms.users,'[{',''),'}]',''),'}:{') AS list, m
with extract(x IN list | toInt(split(x,':')[1])) AS l, m
with filter(x IN l WHERE x > 1421020800 AND x > 1421625599) AS l2, m
WHERE size(l2) > 0
return size(l2), m limit 10;


MATCH (g:Genre)<--(m:Movie)-[r:RATEDBY]->(u:User)

with extract(x IN list | toInt(split(x,':')[1])) AS l, m
with filter(x IN l WHERE x > 1421020800 AND x > 1421625599) AS l2, m
WHERE size(l2) > 0
return size(l2), m limit 10;

