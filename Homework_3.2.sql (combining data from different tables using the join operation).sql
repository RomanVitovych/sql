WITH combined_data AS (
SELECT
	ad_date,
	campaign_name,
	adset_name,
	spend, 
	impressions,
	reach, 
	clicks, 
	leads, 
	value,
	url_parameters
FROM
	public.facebook_ads_basic_daily fabd
LEFT JOIN public.facebook_adset fa ON
	fa.adset_id = fabd.adset_id
LEFT JOIN public.facebook_campaign fc ON
    fc.campaign_id = fabd.campaign_id),
union_combined_data AS (
SELECT 
    ad_date,
	campaign_name,
	adset_name,
	spend, 
	impressions,
	reach, 
	clicks, 
	leads, 
	value,
	url_parameters
FROM public.google_ads_basic_daily
UNION ALL
SELECT 
    ad_date,
	campaign_name,
	adset_name,
	spend, 
	impressions,
	reach, 
	clicks, 
	leads, 
	value,
	url_parameters
FROM combined_data)
SELECT
    ad_date,   --коментувати при виконанні додаткового завдання
	url_parameters AS media_source,   --коментувати при виконанні додаткового завдання
	campaign_name,
	adset_name,
	sum(spend) AS total_spend,
	sum(impressions) AS total_impressions,
	sum(clicks) AS total_clicks,
	sum(value) AS total_value,
	CASE
		WHEN SUM(spend) > 0
        THEN ROUND((SUM(value)::NUMERIC - SUM(spend)::NUMERIC) / SUM(spend)::NUMERIC * 100, 2)
		ELSE 0
	END AS romi
FROM union_combined_data
GROUP BY   --коментувати GROUP BY (ad_date, media_source, campaign_name, adset_name) при виконанні додаткового завдання 
    ad_date,
    media_source,
    campaign_name,
    adset_name
/*GROUP BY
    campaign_name,
    adset_name
HAVING
    sum(spend) > 500000*/
ORDER BY   --коментувати ORDER BY (ad_date, media_source, campaign_name, adset_name) при виконанні додаткового завдання 
    ad_date
/*ORDER BY
    romi DESC*/    
	