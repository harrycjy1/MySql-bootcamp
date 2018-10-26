
use sqldb;

/*아래는 view 만드는 쿼리이다. 설명하자면 v_userbuytbl를 만드는데
select문의 내용을 view로 만들겠다는 것이다.
매번 저렇게 조회를 하게 되면 계속 쿼리를 길게 쳐야될것이다
한번 만들고 view를 잘 이요하면 된다.*/

create view v_userbuytbl
as
select u.userid as 'USER ID', u.name 'USER NAME', b.prodname 'PROD NAME',
		u.addr '주소', concat(u.mobile1,u.mobile2) 'MOBILE PHONE'
FROM usertbl u
inner join buytbl b
on u.userid=b.userid;

select *
from v_userbuytbl;

#필드별로 조회하고 싶으면 알리아스 준걸로 필드명을 주고 반드시 백틱을 사용하여 감싸야함
select `USER ID`, `USER NAME`
from v_userbuytbl;

#아래는 view를 수정하는 것이다

alter view v_userbuytbl
as 
select u.userid as '사용자 아이디', u.name '이름', b.prodname '제품 이름',
		u.addr '주소', concat(u.mobile1,u.mobile2) '전화번호'
FROM usertbl u
inner join buytbl b
on u.userid=b.userid;

select *
FROM v_userbuytbl;

SELECT `이름`,`전화번호`
from v_userbuytbl;

-- 삭제시 역시 drop을 사용

drop VIEW v_userbuytbl;

/* 또 다른 view를 만들어보자
근데 or replace가 왔다. 이것은 v_usertbl가 있다면 아래것으로 view를 덮어 쓰라는 것이다
없으며 만들고*/

create OR REPLACE view v_usertbl as
SELECT userid, name, addr
from usertbl;

#뷰의 구조를 보면 꼭 테이블과 유사하게 되어있다. 하지만 제약조건들은 보이지 않는다는 것을 기억하자.

desc v_usertbl;

#뷰를 통해서 수정을 하니 수정이 된다. 그리고 실제테이블을 확인해봐도 변경이 되었다.
update v_usertbl
set addr = '부산'
where userid='EJW';

select *
from usertbl;

select *
from v_usertbl;

desc usertbl;

/*하지만 아래삽입은 불가능하다
이유는 usertbl에서는 birthyear필드가 not null이기 때문이다.
하여 삽입이 되지않는 것이다.
아래데이터를 꼭 삽입을 하고 싶다면 view를 birthyear을 추가하던가
birthyear를 default값을 주던 아니면 null이 가능하도록 설정을 바꿔야 할것이다.
*/

insert INTO v_usertbl(userid,name,addr) values('KBM','김병만','충북');

#하여 아래와 같이 view를 수정했다.

CREATE OR REPLACE view v_usertbl as
select userid,name,addr,birthyear
from usertbl;

#그리고 필드를 추가해서 삽입을 하니 잘 되는것을 볼수 있다.
insert into v_usertbl VALUES('KBM','김병만','충북','19750807');

select *
from v_usertbl;

select *
from usertbl;


#집계함수와 groupby와 order by를 이용하는 view도 작성해보자

create or REPLACE view v_sum
as 
SELECT userid 'User ID', sum(price*amount)as '합계'
from buytbl
GROUP BY userid
ORDER BY sum(price*amount) desc;

#SELECT 문의 결과대로 잘 나오는것을 알 수 있다.
#그리고 집계함수가 들어가 view는 데이터를 변경할 수 없음을 명심하자

select *
from v_sum;

/*
이것을 직접 눈으로 확인해보자
information_schema는 시스템 데이터베이스이다.
확인해보면 is_updatable을 보면 no로 설정되어있다.
하여 이 v_sum은 view로는 수정 삭제 삽입이 불가능하다 즉 다시말해 집계함수를 사용한 view는
절대 수정이나 삭제가 되지 않는다
아울러 union all join distinct group by 도 안된다.
*/
select *
from information_schema.VIEWS
where TABLE_SCHEMA ='sqldb'
AND TABLE_NAME = 'v_sum';

#키가 177이상인 사람을 조회하는 view생성
create or replace view v_height177
as select *
	from usertbl where height >= 177;
    
select *
FROM v_height177;

#실행은 되지만 키가 177이하인 사람은 view에 없다.
delete from v_height177
where height<177;  #쓸모없는 코드

#입력을 해보면 입력은 된다 하지만 조회를 하면 나오지 않는다 왜? view가 177이상인 사람만 조회하니깐..

insert into v_height177 values('SEN','신은혁',2000,'구미',null,null,140,'2010-05-05');

select *
from usertbl;

select *
from v_height177;

#혼란이 온다면 177이상인 데이터만 입력을 받기 위해서 with check option 구문을 사용하면 된다.

alter view v_height177
as
select *
from usertbl
where height >=177
with CHECK OPTION;

#다시한번 삽입해보자 에러가 난다 왜?with check option구문 댸문에 177이하는 삽입이 되지 않는것이다.

insert into v_height177 values('KKK','김기군',2000,'구미',null,null,140,'2010-05-05');

#복합 view도 아래와 같이 만들수 있다.

CREATE OR REPLACE view v_userbuytbl as
select u.userid as 'USER ID', u.name 'USER NAME', b.prodname 'PROD NAME',
		u.addr '주소', concat(u.mobile1,u.mobile2) 'MOBILE PHONE'
FROM usertbl u
inner join buytbl b
on u.userid=b.userid;

#복합 뷰에 데이터 삽입은 안된다.
insert into v_userbuytbl values('PKL','박경리','경기','00000000','2010-5-5');

#테이블을 제거하면 뷰는?
drop table buytbl, usertbl;

#실행 안된다

select *
from v_userbuytbl;

#이때는 뷰가 참조하고 있는 테이블을 확인해보면 된다.
CHECK TABLE v_userbuytbl;
