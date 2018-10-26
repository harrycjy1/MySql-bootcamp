
use sqldb;

drop table if exists pivottest;
create table pivottest(
	uname char(3),
    season char(2),
    amount int
);

select *
from pivottest;

#데이터 삽입시 ,로 구분하여 아래와 같이 해도 된다.
insert into pivottest values('김범수','겨울',10),('윤종신','여름',15),('김범수','가을',25),('김범수','봄',5),('김범수','봄',37)
,('윤종신','겨울',40),('김범수','여름',14),('김범수','겨울',22),('윤종신','여름',64); 

truncate pivottest;
# 피벗테이블을 만들때 sum()집계함수와 if()문을 사용하면 아주 쉽게 완성할수 있다.

select uname,
	#만약 season이 봄이면 amount를 sum 하라는 쿼리문
    
sum(if(season='봄', amount,0))as'봄',
sum(if(season='여름', amount,0))as'여름',
sum(if(season='가을', amount,0))as'가을',
sum(if(season='겨울', amount,0))as'겨울',
sum(amount) as '합계'

from pivottest
group by uname;


select season,
sum(if(uname='김범수',amount,0))as'김범수',
sum(if(uname='윤종신',amount,0))as'윤종신',
sum(amount)as'합계'
from pivottest
group by season;

select uname
from pivottest
group by season;
