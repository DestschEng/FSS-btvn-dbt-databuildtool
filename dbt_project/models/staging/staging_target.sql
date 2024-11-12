select
    employeeid,
    target,
    targetmonth
from {{source('public', 'targets_staging')}}