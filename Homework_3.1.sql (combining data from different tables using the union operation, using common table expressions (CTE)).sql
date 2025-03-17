WITH combined_data AS (
SELECT
	ad_date,
	url_parameters AS media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	public.facebook_ads_basic_daily
UNION ALL
SELECT
	ad_date,
	url_parameters AS media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
FROM
	public.google_ads_basic_daily)
SELECT
	ad_date,
	media_source,
	sum(spend) AS total_spend,
	count(impressions) AS total_views,
	count(clicks) AS total_clicks,
	sum(value) AS total_converson_value
FROM
	combined_data
WHERE
	media_source IS NOT NULL
GROUP BY
	ad_date,
	media_source;

/*SELECT *
FROM public.facebook_ads_basic_daily*/;

/*SELECT *
FROM public.google_ads_basic_daily*/
