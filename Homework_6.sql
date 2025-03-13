WITH combined_data AS (
SELECT
	ad_date,
	url_parameters,
	COALESCE (spend, 0) AS coalesce_spend, 
	COALESCE (impressions, 0) AS coalesce_impressions, 
	COALESCE (reach, 0) AS coalesce_reach,
	COALESCE (clicks, 0) AS coalesce_clicks,
	COALESCE(leads, 0) AS coalesce_leads,
	COALESCE (value, 0) AS coalesce_value
FROM
	public.facebook_ads_basic_daily
UNION ALL
SELECT
	ad_date,
	url_parameters, 
	COALESCE (spend, 0) AS coalesce_spend, 
	COALESCE (impressions, 0) AS coalesce_impressions, 
	COALESCE (reach, 0) AS coalesce_reach,
	COALESCE (clicks, 0) AS coalesce_clicks,
	COALESCE(leads, 0) AS coalesce_leads,
	COALESCE (value, 0) AS coalesce_value
FROM
	public.google_ads_basic_daily),
agregate_data AS (	
SELECT
	date_trunc ('month', ad_date) AS ad_month,
	CASE  
        WHEN substring(lower(url_parameters) FROM POSITION ('utm_campaign' IN lower(url_parameters)) + 13) = 'nan'
        THEN NULL 
        ELSE substring(lower(url_parameters) FROM POSITION ('utm_campaign' IN lower(url_parameters)) + 13)
    END AS utm_campaign,
    coalesce_spend,
    coalesce_impressions,
    coalesce_clicks,
    coalesce_value,
    CASE
        WHEN coalesce_impressions !=0
        THEN round ((coalesce_clicks::NUMERIC/coalesce_impressions::NUMERIC)*100, 4)
    END AS ctr,
    CASE 
        WHEN coalesce_clicks !=0
        THEN round (coalesce_spend::NUMERIC/coalesce_clicks::NUMERIC, 4)
    END AS cpc,
    CASE 
        WHEN coalesce_impressions !=0
        THEN round ((coalesce_value::NUMERIC/coalesce_impressions::NUMERIC)*1000, 4)
    END AS cpm,
    CASE 
        WHEN coalesce_spend !=0
        THEN round (((coalesce_value::NUMERIC-coalesce_spend::NUMERIC)/coalesce_spend::NUMERIC)*100, 4)
    END AS romi
FROM
	combined_data)
SELECT 	
    ad_month,
    utm_campaign,
    coalesce_spend,
    coalesce_impressions,
    coalesce_clicks,
    coalesce_value,
    ctr,
    CASE 
    	WHEN ctr !=0
    	THEN round ((ctr - LAG (ctr, 1) OVER (PARTITION BY ad_month ORDER BY ctr))*100/ctr, 3)
    END AS cur_prev_diff_ctr,
    cpc,
    cpm,
    CASE
    	WHEN cpm !=0
    	THEN round ((cpm - LAG (cpm, 1) OVER (PARTITION BY ad_month ORDER BY cpm))*100/cpm, 3)
    END AS cur_prev_diff_cpm,
    romi,
    CASE 
    	WHEN romi !=0
    	THEN round ((romi - LAG (romi, 1) OVER (PARTITION BY ad_month ORDER BY romi))*100/romi, 3) 
    END AS cur_prev_diff_romi
FROM 
    agregate_data
ORDER BY 
    ad_month;

    
    
	