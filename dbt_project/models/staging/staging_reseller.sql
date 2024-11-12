SELECT 
    resellerid,
    resellername,
    businesstype,
    city,
    stateprovince,
    countryregion
FROM {{source('public', 'reseller')}}