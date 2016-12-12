MATCH (m:Movie)-[ms:MOVIE_STAR]->(s:Star)
MATCH (m:Movie)-->(y:Year)
WITH y, (SUM(toInt(ms.count)*toFloat(s.id)))/SUM(toInt(ms.count)) AS AVG_RATING, SUM(toInt(ms.count)) AS count, m.title AS Title
WHERE count > 10 return Title, AVG_RATING, y.year AS sub order by sub desc, AVG_RATING desc limit 10;

MATCH (m:Movie {id:1})-[ms:MOVIE_STAR]-(s:Star) with (SUM(toInt(ms.count)*toFloat(s.id)))/SUM(toInt(ms.count)) AS AVG_RATING, SUM(toInt(ms.count)) AS count MATCH (y:Year)--(m:Movie {id:1})-->(t) return *;