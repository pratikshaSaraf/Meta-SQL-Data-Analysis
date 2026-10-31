# 📊 Social Media Engagement Analysis | SQL Project

## 📌 Project Overview

This project focuses on analysing Instagram user behaviour and engagement using **MySQL**. The objective is to extract meaningful insights from social media data and help Meta's Marketing team make data-driven decisions to improve user engagement, retention, acquisition and marketing strategies.

The analysis explores user activity, post engagement, hashtags, followers, inactive users and potential influencers. SQL queries are used to transform raw data into actionable business insights and marketing recommendations.

## 🎯 Business Problem

Meta has access to a large volume of Instagram user data but needs a better understanding of:

- Who are the most active and valuable users?
- Which users are inactive or have low engagement?
- What content topics and hashtags attract the most engagement?
- Which users have the potential to become influencers or brand ambassadors?
- How can user behaviour be used to create personalized marketing campaigns?

This project addresses these questions through SQL-based analysis.

## 🗂️ Dataset Overview

The project uses an Instagram database consisting of **7 relational tables**:

| Table Name | Description |
|---|---|
| `users` | Stores user information and account creation dates. |
| `photos` | Contains posts uploaded by users. |
| `comments` | Stores comments made on posts. |
| `likes` | Records user likes on posts. |
| `follows` | Contains follower and following relationships. |
| `tags` | Stores hashtags used on the platform. |
| `photo_tags` | Maps posts to their associated hashtags. |

## 🛠️ Tools & Technologies

- **MySQL:** Database management and SQL-based analysis.
- **SQL:** Data exploration, manipulation and querying.
- **Microsoft PowerPoint:** Presentation of findings and recommendations.

## 🔍 Analysis Performed

The project covers the following analytical areas:

### 1. Data Quality Assessment
- Identified missing values using `IS NULL`.
- Checked duplicate records using `GROUP BY` and `HAVING`.
- Evaluated data consistency across relational tables.

### 2. User Activity Analysis
- Measured total posts, likes and comments for each user.
- Identified inactive and low-activity users.
- Analysed user engagement patterns.

### 3. Engagement Analysis
- Calculated average tags per post.
- Identified users with the highest post engagement.
- Calculated average engagement per post.
- Ranked users using window functions.

### 4. Hashtag Analysis
- Identified frequently used hashtags.
- Analysed hashtag-wise likes, comments and engagement.
- Used CTEs to calculate average likes per hashtag.

### 5. Follower & Influencer Analysis
- Calculated follower and following counts.
- Identified potential influencers and brand ambassadors.
- Analysed reciprocal following relationships.

### 6. Marketing & Business Analysis
- Segmented users based on their activity levels.
- Identified opportunities to re-engage inactive users.
- Explored personalized advertising strategies.
- Developed recommendations for improving user retention and engagement.

## 💡 Key Insights

The analysis revealed several important findings:

- **User Activity:** User engagement is unevenly distributed, with a smaller group of users demonstrating significantly higher activity.
- **Inactive Users:** 13 users (21.31%) were identified as completely inactive, while 48 users (78.69%) fell into the low-activity category in the reported segmentation.
- **Hashtag Performance:** #smile recorded the highest engagement among the displayed hashtags, followed by #beach, #party and #fun.
- **Posting Behaviour:** Users making 12 posts recorded the highest average engagement in the analysed posting-frequency comparison.
- **Engagement Patterns:** Likes generally contribute more interactions than comments.

## 📈 Business Recommendations

Based on the analysis, the following strategies are recommended:

1. **Re-engage Inactive Users:** Use personalized notifications and content recommendations to encourage participation.
2. **Reward Loyal Users:** Introduce recognition badges, loyalty rewards and exclusive campaigns for highly active users.
3. **Optimize Hashtag Strategies:** Prioritize relevant high-performing hashtags in promotional campaigns.
4. **Improve Content Recommendations:** Suggest posts based on users' interests and previous interactions.
5. **Influencer Marketing:** Collaborate with users who demonstrate strong follower counts and engagement.
6. **Encourage Consistent Posting:** Introduce challenges and reminders to motivate users to create more content.

## 🧠 SQL Concepts & Functions Used

This project demonstrates practical application of:

- SELECT, WHERE, ORDER BY and LIMIT
- DISTINCT and aggregate functions (`COUNT`, `SUM`, `AVG`)
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- Subqueries and correlated subqueries
- Common Table Expressions (CTEs)
- Window Functions (`RANK`, `DENSE_RANK`)
- CASE statements
- COALESCE and IFNULL
- Date and Time Functions
- UNION ALL
- Data manipulation using UPDATE


```

## 🚀 Project Outcome

This project demonstrates how SQL can be used to analyse relational social media data, identify user engagement patterns, segment customers and generate actionable business recommendations.

It strengthened my understanding of relational databases, complex SQL queries, data analysis and translating analytical results into business insights.

## 👩‍💻 Author

**Pratiksha Saraf**


---
