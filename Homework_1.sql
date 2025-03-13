SELECT 
ad_date, 
spend, 
clicks,
spend/clicks AS "spend/clicks"
FROM facebook_ads_basic_daily
WHERE clicks != 0
ORDER BY ad_date DESC;