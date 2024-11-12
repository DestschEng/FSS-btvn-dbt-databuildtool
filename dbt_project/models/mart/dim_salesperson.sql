SELECT DISTINCT
    employeekey,
    employeeid,
    INITCAP(salesperson) AS salesperson_name,
    title,
    UPPER(upn) AS upn
FROM {{ ref('staging_salesperson') }}
