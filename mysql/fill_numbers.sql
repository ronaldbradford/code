#http://datacharmer.blogspot.com/2006/06/filling-test-tables-quickly.html
drop table if exists numbers;
create table numbers ( id int not null primary key);

delimiter $$

drop procedure if exists fill_numbers $$
create procedure fill_numbers()
deterministic
begin
  declare counter int default 1;
  insert into numbers values (1);
  while counter < 1000000
  do
      insert into numbers (id)
          select id + counter
          from numbers;
      select count(*) into counter from numbers;
      select counter;
  end while;
end $$
delimiter ;

call fill_numbers();
