select
    employeekey,
    employeeid,
    salesperson,
    title,
    upn
from {{source('public', 'salesperson_staging')}}