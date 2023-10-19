with recursive activity_hierarchy as (
  select
    a.activityid,
    a.activitytypeid,
    a.code,
    a.name,
    a.parentid,
    null as areaid,
    1 as level
  from activity a
  where (pn_activityid is null and a.parentid is null)
     or a.activityid = pn_activityid
  
  union all
  
  select
    a.activityid,
    a.activitytypeid,
    a.code,
    a.name,
    a.parentid,
    c.areaid,
    ah.level + 1 as level
  from activity a
  join activity_hierarchy ah on a.parentid = ah.activityid
  left join "contract" c on a.activityid = c.activityid
  
  union all
  
  select
    p.activityid,
    p.activitytypeid,
    p.code,
    p.name,
    p.parentid,
    null as areaid,
    5 as level
  from activity p
  where p.parentid in (select activityid from activity_hierarchy where level = 4)
  
  union all
  
  select
    c.activityid,
    c.activitytypeid,
    c.code,
    c.name,
    c.parentid,
    null as areaid,
    7 as level
  from activity c
  where c.parentid in (select activityid from activity_hierarchy where level = 6)
)
select
  ah.activityid,
  aht.name as activity_type,
  ah.code,
  ah.name,
  ar.name as area,
  ah.level
from activity_hierarchy ah
join activitytype aht on ah.activitytypeid = aht.activitytypeid
left join "area" ar on ah.areaid = ar.areaid
order by ah.activityid;