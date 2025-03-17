WITH combined_data AS (
SELECT
	ad_date,
	url_parameters,
	spend, 
	impressions,
	COALESCE (reach, 0) AS coalesce_reach,
	clicks,
	COALESCE(leads, 0) AS coalesce_leads,
	value
FROM
	public.facebook_ads_basic_daily
UNION ALL
SELECT
	ad_date,
	url_parameters, 
	spend, 
	impressions, 
	COALESCE (reach, 0) AS coalesce_reach,
	clicks,
	COALESCE(leads, 0) AS coalesce_leads,
	value
FROM
	public.google_ads_basic_daily)
SELECT
	ad_date,
    CASE
		WHEN lower(substring(url_parameters, 'utm_campaign=([^\&]+)')) != 'nan' 
		THEN lower(substring(url_parameters, 'utm_campaign=([^\&]+)'))
		ELSE NULL 
	END AS utm_campaign,
    COALESCE (spend, 0) AS c_spend,
    COALESCE (impressions, 0) AS c_impressions,
    COALESCE (clicks, 0) AS c_clicks,
    COALESCE (value, 0) AS c_value,
    CASE
        WHEN impressions !=0
        THEN round ((clicks::NUMERIC/impressions::NUMERIC)*100, 4)
    END AS ctr,
    CASE 
        WHEN clicks !=0
        THEN round (spend::NUMERIC/clicks::NUMERIC, 4)
    END AS cpc,
    CASE 
        WHEN impressions !=0
        THEN round ((spend::NUMERIC/impressions::NUMERIC)*1000, 4)
    END AS cpm,
    CASE 
        WHEN spend !=0
        THEN round (((value::NUMERIC-spend::NUMERIC)/spend::NUMERIC)*100, 4)
    END AS romi
FROM
	combined_data
ORDER BY
	ad_date;




