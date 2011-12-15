drop table if exists words;
create table words (
  id int not null auto_increment primary key,
  t varchar(50) not null
);

load data local infile '/usr/share/dict/words'
  into table words (t);

insert into words (t) select reverse(t) from words;

