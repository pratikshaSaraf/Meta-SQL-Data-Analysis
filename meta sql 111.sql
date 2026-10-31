/* =====================================================================
   SOCIAL MEDIA (IG CLONE) — STUDENT ANSWER TEMPLATE
   ===================================================================== */

USE ig_clone;


/* =====================================================================
   OBJECTIVE QUESTIONS
   ===================================================================== */

-- O1.
-- Are there any tables with duplicate or missing null values? If so, how
-- would you handle them?
select * from users 
where id is null or
	username is null or 
    created_at is null;
    
select * from tags
where id is null
 or tag_name is null 
 or created_at is null ;
 
select * from photos where 
id is null or
image_url is null or
user_id is null or 
created_dat is null ;

select * from photo_tags where 
photo_id is null or 
tag_id is null ;

select * from follows where 
follower_id is null or 
followee_id is null or 
created_at is null ;


select * from likes where 
user_id is null or 
photo_id is null or 
created_at is null ;

select * from comments where 
id is null or
comment_text is null or
user_id is null or 
photo_id is null or
created_at is null;


SELECT username, COUNT(*) as duplicates
FROM users
GROUP BY username
HAVING COUNT(*) > 1;

select id , count(*) as duplicates 
from tags
group by id
having count(*) >1 ;

select id , count(*) as duplicates 
from photos
group by id
having count(*) >1 ;

select photo_id, tag_id, count(*) as duplicates
from photo_tags
group by photo_id, tag_id
having count(*) > 1;

select follower_id, followee_id, count(*) as duplicates
from follows
group by follower_id, followee_id
having count(*) > 1;


select user_id, photo_id, count(*) as duplicates
from likes
group by user_id, photo_id
having count(*) > 1;

select id, count(*) as duplicates
from comments
group by id
having count(*) > 1;



-- O2.
-- What is the distribution of user activity levels (e.g., number of posts,
-- likes, comments) across the user base?

select u.id as user_id , u.username ,
		count(distinct p.id) as  total_posts,
		count(distinct l.photo_id) as  total_likes_given,
		count(distinct c.id) as  total_comments_made from users u 
left join photos p on
		u.id = p.user_id
left join likes l on
		u.id = l.user_id
left join comments c on
		u.id = c.user_id
group by user_id,
		 u.username
ORDER BY total_posts DESC,
		 total_likes_given DESC,
		 total_comments_made DESC;





-- O3.
-- Calculate the average number of tags per post (photo_tags and photos
-- tables).

SELECT 
		ROUND(AVG(tag_count), 2) AS avg_tags_per_post
FROM (
	SELECT p.id,  
    COUNT(pt.tag_id) AS tag_count 
		FROM photos p
LEFT JOIN photo_tags pt 
	ON p.id = pt.photo_id
GROUP BY p.id
) AS photo_tag_counts;


-- O4.
-- Identify the top users with the highest engagement rates (likes, comments)
-- on their posts and rank them
SELECT p.user_id,
	COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement,
RANK() OVER (
	ORDER BY COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) DESC
    ) AS engagement_rank
FROM photos p 	
	JOIN likes l
		ON p.id = l.photo_id 
    JOIN comments c
		ON p.id = c.photo_id
GROUP BY p.user_id
ORDER BY engagement_rank, p.user_id;


-- O5.
-- Which users have the highest number of followers and followings?
SELECT u.id AS user_id,	
	u.username,
	COUNT(DISTINCT f1.follower_id) AS followers,
	COUNT(DISTINCT f2.followee_id) AS following
	FROM users u
    LEFT JOIN follows f1 
		ON u.id = f1.followee_id
LEFT JOIN follows f2
		ON u.id = f2.follower_id
GROUP BY u.id,
		u.username 
ORDER BY followers DESC,
			following DESC;


-- O6.
-- Calculate the average engagement rate (likes, comments) per post for each
-- user.
SELECT u.id,
		u.username,
        COUNT(DISTINCT p.id) AS total_posts,
	COUNT(DISTINCT l.user_id) AS total_likes_received,
	COUNT(DISTINCT c.id) AS total_comments_received,
	ROUND((COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id)) /COUNT(DISTINCT p.id),2) AS avg_engagement_per_post
FROM users u 
JOIN photos p 
	ON u.id = p.user_id
LEFT JOIN likes l 
	ON p.id = l.photo_id
LEFT JOIN comments c 
	ON p.id = c.photo_id
GROUP BY u.id,
		u.username 
ORDER BY avg_engagement_per_post DESC;


-- O7.
-- Get the list of users who have never liked any post (users and likes
-- tables)

SELECT
    u.id,
    u.username
FROM users u 
LEFT JOIN likes l 
	ON u.id = l.user_id
WHERE l.user_id IS NULL;

-- O8.
-- How can you leverage user-generated content (posts, hashtags, photo tags)
-- to create more personalized and engaging ad campaigns?
SELECT u.id AS user_id, 
	u.username,
    t.tag_name,
	COUNT(DISTINCT p.id) AS tag_usage,
	COALESCE(SUM(pl.c), 0) AS total_likes_received,
	COALESCE(SUM(pc.c), 0) AS total_comments_received, 
    COALESCE(SUM(pl.c), 0) + COALESCE(SUM(pc.c), 0) AS total_engagement
FROM users u
	JOIN photos p 
    ON p.user_id = u.id 
JOIN photo_tags pt 
	ON pt.photo_id = p.id
JOIN tags t
	ON t.id = pt.tag_id
LEFT JOIN (SELECT photo_id, COUNT(*) c 
	FROM likes 
    GROUP BY photo_id) pl 
		ON pl.photo_id = p.id
LEFT JOIN
 (SELECT photo_id, COUNT(*) c 
	FROM comments
    GROUP BY photo_id) pc 
ON pc.photo_id = p.id
GROUP BY u.id,
 u.username, 
 t.id,
 t.tag_name 
 ORDER BY total_engagement DESC;



-- O9.
-- Are there any correlations between user activity levels and specific
-- content types (e.g., photos, videos, reels)? How can this information
-- guide content creation and curation strategies?
SELECT p.user_id AS user_id,
	COUNT(DISTINCT p.id) AS total_posts,
    COUNT(DISTINCT l.user_id, l.photo_id) AS total_likes,
	COUNT(DISTINCT c.id) AS total_comments,
    COUNT(DISTINCT l.user_id, l.photo_id) + COUNT(DISTINCT c.id) AS total_engagement
	FROM photos p 	
    LEFT JOIN likes l 
    ON p.id = l.photo_id
	LEFT JOIN comments c 
    ON p.id = c.photo_id
GROUP BY p.user_id
HAVING COUNT(DISTINCT p.id) >= 1;

-- O10.
-- Calculate the total number of likes, comments, and photo tags for each
-- user.

SELECT u.id AS user_id,
		u.username,
	COALESCE(l.total_likes, 0) AS total_likes,
	COALESCE(c.total_comments, 0) AS total_comments,
	COALESCE(t.total_tags, 0) AS total_tags
FROM users u 
LEFT JOIN (
			SELECT user_id,
            COUNT(*) AS total_likes 
            FROM likes 
            GROUP BY user_id ) l
ON u.id = l.user_id
LEFT JOIN
 ( SELECT user_id, COUNT(*) AS total_comments 
	FROM comments 
    GROUP BY user_id ) c
ON u.id = c.user_id
LEFT JOIN
( SELECT p.user_id, COUNT(*) AS total_tags
	FROM photos p
JOIN photo_tags pt 
	ON p.id = pt.photo_id 
    GROUP BY p.user_id ) t
    ON u.id = t.user_id ;

-- O11.
-- Rank users based on their total engagement (likes, comments, shares) over a
-- month.

SELECT u.id AS user_id, u.username,
COALESCE(l.likes_given, 0) AS likes_given,
COALESCE(c.comments_made, 0) AS comments_made,
COALESCE(l.likes_given, 0) + COALESCE(c.comments_made, 0) AS total_engagement,
RANK() OVER ( ORDER BY
            COALESCE(l.likes_given, 0) + COALESCE(c.comments_made, 0) DESC ) AS engagement_rank
FROM users u
LEFT JOIN (
SELECT user_id, COUNT(*) AS likes_given
FROM likes
GROUP BY user_id
) l
ON u.id = l.user_id
LEFT JOIN ( SELECT user_id,
COUNT(*) AS comments_made
FROM comments 
GROUP BY user_id
) c ON u.id = c.user_id  ORDER BY engagement_rank, u.id;

-- O12.
-- Retrieve the hashtags that have been used in posts with the highest average
-- number of likes. Use a CTE to calculate the average likes for each
-- hashtag first.
WITH hashtag_likes AS ( 
SELECT t.id AS tag_id,
		t.tag_name, 
        p.id AS photo_id,
COUNT(l.photo_id) AS photo_likes 
FROM tags t 
JOIN photo_tags pt
	ON t.id = pt.tag_id 
JOIN photos p 
	ON pt.photo_id = p.id
LEFT JOIN likes l 
	ON p.id = l.photo_id
GROUP BY t.id, t.tag_name, p.id
),
tag_summary AS (
    SELECT tag_id,
    tag_name, 
    ROUND(AVG(photo_likes), 2) AS avg_likes_per_photo,
	SUM(photo_likes) AS total_likes, 
    COUNT(photo_id) AS total_photos
FROM hashtag_likes
GROUP BY tag_id, tag_name
)
SELECT tag_id,
 tag_name,
 avg_likes_per_photo, 
 total_likes, 
 total_photos
FROM tag_summary
ORDER BY avg_likes_per_photo DESC
limit 10
;


-- O13.
-- Retrieve the users who have started following someone after being followed
-- by that person.

SELECT DISTINCT u.id, u.username
FROM users u
JOIN follows f1 ON f1.follower_id = u.id
JOIN follows f2 ON f2.follower_id = f1.followee_id
               AND f2.followee_id = f1.follower_id
WHERE f1.created_at > f2.created_at;
/* =====================================================================
   SUBJECTIVE QUESTIONS
   ===================================================================== */

-- S1.
-- Based on user engagement and activity levels, which users would you
-- consider the most loyal or valuable? How would you reward or incentivize
-- these users?
WITH stats AS 
	(SELECT u.id, 
		u.username,
(SELECT 
COUNT(*) 
	FROM photos p 
		WHERE p.user_id = u.id) AS photos_posted,
(SELECT
 COUNT(*) 
	FROM likes l 
		JOIN photos p 
        ON l.photo_id = p.id
WHERE p.user_id = u.id) AS likes_received,
(SELECT COUNT(*) 
	FROM comments c 
    JOIN photos p 
    ON c.photo_id = p.id
WHERE 
	p.user_id = u.id) AS comments_received,
(SELECT COUNT(*) 
	FROM follows f
    WHERE f.followee_id = u.id) AS followers,
(SELECT 
	COUNT(*) 
		FROM likes l 
        WHERE l.user_id = u.id) AS likes_given,
(SELECT 
	COUNT(*) 
    FROM comments c 
    WHERE c.user_id = u.id) AS comments_given
FROM users u )
SELECT *, 
	likes_received + comments_received + likes_given + comments_given
AS total_engagement 
FROM stats 
ORDER BY total_engagement DESC
LIMIT 10;


-- S2.
-- For inactive users, what strategies would you recommend to re-engage them
-- and encourage them to start posting or engaging again?

WITH activity AS 
	( SELECT u.id,
		u.username,
        u.created_at,
(SELECT COUNT(*) 
	FROM photos   p 
    WHERE p.user_id = u.id) AS photos_posted,
	(SELECT COUNT(*) 
		FROM likes    l 
        WHERE l.user_id = u.id) AS likes_given,
(SELECT COUNT(*) 
	FROM comments c 
    WHERE c.user_id = u.id) AS comments_given
FROM users u )
SELECT id,
	username, 
    photos_posted, 
    likes_given,
    comments_given, 
    likes_given + comments_given AS total_given,
  CASE
    WHEN photos_posted = 0 
    AND likes_given = 0 
    AND comments_given = 0
      THEN 'Completely inactive'
    WHEN likes_given    < (SELECT AVG(likes_given)    FROM activity)
     AND comments_given < (SELECT AVG(comments_given) FROM activity)
      THEN 'Low activity'
  END AS user_status
FROM activity
WHERE (photos_posted = 0 AND likes_given = 0 AND comments_given = 0)
   OR (likes_given    < (SELECT AVG(likes_given)    FROM activity)
   AND comments_given < (SELECT AVG(comments_given) FROM activity))
ORDER BY total_given ASC, 
		photos_posted ASC;


-- S3.
-- Which hashtags or content topics have the highest engagement rates? How can
-- this information guide content strategy and ad campaigns?
WITH photo_engagement AS 
( SELECT p.id AS photo_id,
(SELECT COUNT(*) 	
	FROM likes l 
    WHERE l.photo_id = p.id) AS likes_count,
(SELECT COUNT(*) 
	FROM comments c 
    WHERE c.photo_id = p.id) AS comments_count 
    FROM photos p)
SELECT
t.tag_name,
	COUNT(pt.photo_id) AS photos_using_tag,
	SUM(pe.likes_count) AS total_likes,
	SUM(pe.comments_count) AS total_comments,
	SUM(pe.likes_count + pe.comments_count)AS total_engagement,
	ROUND(SUM(pe.likes_count + pe.comments_count) / COUNT(pt.photo_id), 2) AS engagement_per_photo
FROM tags t 
	JOIN photo_tags pt
    ON pt.tag_id   = t.id
	JOIN photo_engagement pe 
    ON pe.photo_id = pt.photo_id
GROUP BY t.id,
		t.tag_name
ORDER BY engagement_per_photo DESC, 
		total_engagement DESC 
        LIMIT 10;


-- S4.
-- Are there any patterns or trends in user engagement based on demographics
-- (age, location, gender) or posting times? How can these insights inform
-- targeted marketing campaigns?
WITH pe AS ( SELECT p.id, p.created_dat, 
			(SELECT COUNT(*) 
            FROM likes l
            WHERE l.photo_id = p.id)
  + (SELECT COUNT(*) 
	FROM comments c 
    WHERE c.photo_id = p.id) AS eng 
    FROM photos p
),
b AS (
	SELECT id, 
    eng, 
    DAYOFWEEK(created_dat) AS dow,
	CASE 
    WHEN HOUR(created_dat) BETWEEN 5  AND 11 THEN 'Morning'
	WHEN HOUR(created_dat) BETWEEN 12 AND 16 THEN 'Afternoon'
	WHEN HOUR(created_dat) BETWEEN 17 AND 20 THEN 'Evening'
		ELSE 'Night' END AS time_period FROM pe )
	SELECT d.day_name,
    t.time_period,
		COUNT(b.id) AS photos_posted,
		IFNULL(SUM(b.eng), 0)  AS total_engagement,
		IFNULL(ROUND(AVG(b.eng), 2), 0)  AS engagement_per_photo
FROM (
	SELECT 1 dow,
    'Sunday' day_name UNION ALL SELECT 2,
    'Monday' UNION ALL SELECT 3,
    'Tuesday'
UNION ALL SELECT 4,
	'Wednesday' UNION ALL SELECT 5,
    'Thursday'
UNION ALL SELECT 6,
	'Friday' UNION ALL SELECT 7,
    'Saturday') d
CROSS JOIN (
	SELECT 1 o,
    'Morning' time_period UNION ALL SELECT 2,
    'Afternoon' 
UNION ALL SELECT 3,
	'Evening' UNION ALL SELECT 4,
	'Night') t
LEFT JOIN b
 ON b.dow = d.dow 
 AND b.time_period = t.time_period
GROUP BY d.dow,
 d.day_name,
 t.o,
 t.time_period 
 ORDER BY d.dow,
			t.o;

-- S5.
-- Based on follower counts and engagement rates, which users would be ideal
-- candidates for influencer marketing campaigns? How would you approach
-- and collaborate with these influencers?

WITH followers AS ( SELECT followee_id AS user_id,
					COUNT(*) AS total_followers
	FROM follows 
    GROUP BY followee_id ),
likes_received AS ( SELECT p.user_id,
					COUNT(*) AS total_likes_received
FROM photos p
	JOIN likes l 
    ON p.id = l.photo_id
GROUP BY p.user_id ),
comments_received AS ( SELECT p.user_id,
		COUNT(*) AS total_comments_received
FROM photos p 
		JOIN comments c 
        ON p.id = c.photo_id
		GROUP BY p.user_id )
SELECT u.id, u.username,
		COALESCE(f.total_followers,0) AS total_followers,
		COALESCE(l.total_likes_received,0) AS total_likes_received,
		COALESCE(c.total_comments_received,0) AS total_comments_received,
		(COALESCE(l.total_likes_received,0) +
		COALESCE(c.total_comments_received,0)) AS total_engagement,
DENSE_RANK() OVER(
        ORDER BY
            COALESCE(f.total_followers,0) DESC,
            (COALESCE(l.total_likes_received,0) +
             COALESCE(c.total_comments_received,0)) DESC
    ) AS influencer_rank
FROM users u
	LEFT JOIN followers f
		ON u.id=f.user_id
	LEFT JOIN likes_received l
		ON u.id=l.user_id
	LEFT JOIN comments_received c
		ON u.id=c.user_id
	ORDER BY influencer_rank;


-- S6.
-- Based on user behavior and engagement data, how would you segment the user
-- base for targeted marketing campaigns or personalized recommendations?
WITH a AS 
		( SELECT u.id, u.username,
		(SELECT COUNT(*) FROM photos p WHERE p.user_id = u.id) AS photos_posted,
		(SELECT COUNT(*) FROM likes l JOIN photos p ON l.photo_id = p.id
				WHERE p.user_id = u.id) AS likes_received,
		(SELECT COUNT(*) FROM likes l WHERE l.user_id = u.id) AS likes_given,
		(SELECT COUNT(*) FROM comments c WHERE c.user_id = u.id) AS comments_given 
        FROM users u
),
s AS (
SELECT *,
    CASE WHEN photos_posted = 0 AND likes_given = 0 AND comments_given = 0
        THEN 'Inactive'
      WHEN photos_posted  >= (SELECT AVG(photos_posted)  FROM a)
       AND likes_received >= (SELECT AVG(likes_received) FROM a)
        THEN 'Top Contributors'
      WHEN likes_given + comments_given >=
           (SELECT AVG(likes_given + comments_given) FROM a)
        THEN 'Active Engagers'
      WHEN photos_posted = 0
        THEN 'Non-Posters'
      ELSE 'Low Activity'
    END AS segment
  FROM a
)
SELECT id, username, segment, photos_posted, likes_received, likes_given, comments_given
FROM s
ORDER BY segment, id;


-- S7.
-- If data on ad campaigns (impressions, clicks, conversions) is available,
-- how would you measure their effectiveness and optimize future campaigns?



-- S8.
-- How can you use user activity data to identify potential brand ambassadors
-- or advocates who could help promote Instagram's initiatives or events?
WITH followers AS (
    SELECT followee_id AS user_id,
    COUNT(*) AS total_followers
    FROM follows
    GROUP BY followee_id
),
engagement AS (
    SELECT p.user_id,
	COUNT(DISTINCT p.id) AS total_posts,
	COUNT(DISTINCT l.photo_id) AS total_likes_received,
	COUNT(DISTINCT c.id) AS total_comments_received
    FROM photos p 
    LEFT JOIN likes l 
		ON p.id = l.photo_id 
	LEFT JOIN comments c 
		ON p.id = c.photo_id
GROUP BY p.user_id)
SELECT 
    u.id AS user_id,u.username,
		COALESCE(f.total_followers, 0) AS total_followers,
		COALESCE(e.total_posts, 0) AS total_posts,
		COALESCE(e.total_likes_received, 0) AS total_likes_received,
		COALESCE(e.total_comments_received, 0) AS total_comments_received,
		COALESCE(e.total_likes_received, 0)  + COALESCE(e.total_comments_received, 0) AS total_engagement
FROM users u 
	LEFT JOIN followers f 
    ON u.id = f.user_id
LEFT JOIN engagement e 
	ON u.id = e.user_id
ORDER BY total_engagement DESC,
		total_followers DESC;


-- S9.
-- How would you approach this problem, if the objective and subjective
-- questions weren't given?



-- S10.
-- Assuming there's a "User_Interactions" table tracking user engagements, how
-- can you update the "Engagement_Type" column to change all instances of
-- "Like" to "Heart" to align with Instagram's terminology?

UPDATE User_Interactions
	SET Engagement_Type = 'Heart'
WHERE Engagement_Type = 'Like';

-- ps 
-- pps
/* ===================================== END OF FILE ===================================== */
