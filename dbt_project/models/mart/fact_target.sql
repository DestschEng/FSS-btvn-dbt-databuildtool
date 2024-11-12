SELECT
    employeeid,
    COALESCE(target::NUMERIC, 0) AS target,
    targetmonth
FROM {{ ref('staging_target') }}
