select 
ad_date, 
campaign_id,
sum(spend) as total_spend,
sum(impressions) as total_impressions,
sum(clicks) as total_clicks,
sum(value) as total_value,
case 
	when sum(clicks) !=0 
	then round(sum(spend)/sum(clicks)::NUMERIC, 3) 
	else 0
end as cpc,
round(sum(impressions)/1000::NUMERIC, 3) as cpm,
case 
	when sum(clicks) !=0 
	then round(sum(clicks)/(sum(impressions)*100)::NUMERIC, 4) 
	else 0
end as ctr,
case 
	when sum(value)-sum(spend) !=0 
	then round((sum(value)-sum(spend))/(sum(spend)*100)::numeric, 4)
	else 0
end as romi
from public.facebook_ads_basic_daily
group by  ad_date, campaign_id
--group by campaign_id
--having sum(spend) > 500000
--order by romi;
order by ad_date;


/*select 
campaign_id,
sum(spend)
from public.facebook_ads_basic_daily
group by campaign_id
having sum(spend) > 500000
order by romi;*/




