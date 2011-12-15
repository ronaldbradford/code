
p table if exists dates;
create table dates (
  id int(11) not null auto_increment primary key,
  dt datetime not NULL
) engine=myisam;

delimiter $$

drop procedure if exists make_dates $$
CREATE PROCEDURE make_dates( max_recs int)
begin
  declare start_dt datetime;
  declare numrecs int default 1;
  set start_dt = date_format( now() - interval max_recs minute, '%Y-%m-%d %H:%i:00');

  insert into dates (dt) values (start_dt );

  while numrecs < max_recs
  do
      insert into dates (dt)
          select dt + interval ( numrecs ) minute
          from dates;
      select count(*) into numrecs from dates;
      select numrecs;
  end while;
end $$

delimiter ;
