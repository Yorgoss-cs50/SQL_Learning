USE TSQLV4;
GO

SELECT
studentid,
testid,
score,
CASE
   WHEN score IS NULL THEN 'Missing'
   WHEN score >= 80 THEN 'High'
   WHEN score >= 60 THEN 'Medium'
   ELSE 'Low'
   END AS ScoreClean,
   AVG(CASE WHEN score IS NULL THEN 0 ELSE score END ) OVER() AS AvgCustomerClean
   FROM
   Stats.Scores;