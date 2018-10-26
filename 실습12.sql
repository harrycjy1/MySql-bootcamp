use sqldb;

select *
from usertbl
where name = '김경호';

#관계연산자와 and를 이용하여 조거은 준다.
#and는 둘다 참이여야 참을 반환
#하여 아래 쿼리는 usertbl에서 userid와 name을
#가져오는데 그 조건이 year이 1970을 포함한 이후의 조건과
#키가 182이상인 조건을 둘 다 만족하는 데이터

select userid, name
from usertbl
where birthyear >=1970
and height >=182;

#아래는 or가 조건에 들어갔다 . or 는 둘중 하나만 참이면 무조건 참을 반환

select userId,name
from usertbl
where birthyear >= 1970
or height >= 182;


#아래 뭐리는 키가 180이상이고 183이하의 조건을 충족하는 쿼리

select userid, name
from usertbl
where height >=180
and height <=183;

#위의 코드는 between and 로도 바꿀수 있음
#현업에서 beteween and 굉장히 많이 쓰임!
select userid, name, height
from usertbl
where height between 180 and 183;

#아래 코드는 addr(지역)이 경남, 전남, 경북 전북을 만족하는 데이터 출력

select name, addr
from usertbl
where addr = '경남'
or addr ='전남'
or addr	='경북'
or addr ='전북';

#위의 코드를 in()써서 짜보자

select name, addr
from usertbl
where addr in('경남','전남','경북','전북');

#성이 김씨인 데이터 전부 출력
select name, addr
from usertbl
where name like '김%';

#한글자에 대한것은 _(언더바)로 대체가능
select name, addr
from usertbl
where name like '_종신';