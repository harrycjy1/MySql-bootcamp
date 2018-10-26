
-- 대용량 데이터를 쉽게 가져오는 방법이 있다.
-- 아래와 같이 일단 테이블을 만들자.

select *
from employees.employees;

desc employees. employees;

use sqldb;

-- 아래와 같이 testtbl4테이블을 만든다
drop table if exists testtbl4;
create table testtbl4(
id int,
fname varchar(14),
lname varchar(16)
);

-- 아래 쿼리는 대용량 데이터를 바로 삽입하는 것이다. 약 30만건
insert into testtbl4
	select emp_no, first_name, last_name
	from employees.employees;

-- 아래 쿼리는 테이블을 만들면서 바로 셀렉

create table testtbl5
	(select emp_no, first_name, last_name
		from employees.employees);


-- 각각 조회 해보면 employees.employees테입ㄹ의 3개필드가 삽입되어 있음
select *
from testtbl4;

select *
from testtbl5;


-- update문에 대해서 알아보자
-- update.. set.. where 의 형태 where가 없어도 되지만 그럴경우 모든데이터 수정해버림 주의할것

select *
from testtbl4
where fname = 'kyoichi';

update testtbl4
set lname = '없음'
where fname = 'kyoichi';

-- 하지만 간혹 전체를 대상으로 update를 치는 경우가 있긴하다
-- 제품단가가 올랐다던지 월급의 인상 등 
-- 조회 후 update를 쳐보자

select *
from buytbl;

update buytbl
set price = price*1.5;

-- delete문에서도 역시 where가 없다면 모든 데이터를 날리니까 어지간하면 넣자

use sqldb;

delete 
from testtbl4
where fname = 'Aamer';

-- 확인해보면 Aamer는 없다

select *
from testtbl4
where fname = 'Aamer';

create table bigtbl1(select*
from employees.employees);

create table bigtbl2(select*
from employees.employees);

create table bigtbl3(select*
from employees.employees);


/* 아래와 같이 데이터를 지우는데엔 3가지 방법이 있다

delete(DML)구문이 가장 늦은것을 알 수 있다.

하여 테이블과 데이터를 다 날리고 싶다면 drop

테이블은 남기고 데이터를 모두 날리고싶다면 truncate를 쓰는것이 바람직하다
*/

drop table bigtbl1;

delete from bigtbl2;

truncate table bigtbl3; -- truncate (DDL)구문 

-- drop한 bigtbl1은 테이블까지 제거가 된것을 확인할수가 있다.

select *
from bigtbl1;

select *
from bigtbl2;

select *
from bigtbl3;

-- 아래와 같이 membertbl을 usertbl에 있는 userid name, addr필드를 3건만으로 만들었따.

drop table if exists membertbl;
create table membertbl(
	select userid, name, addr
	from usertbl
	limit 3
);

select *
from membertbl;

-- 하지만 테이블을 위와같이 만들면, 제약조건은 따로 복사가 안된다고 앞에서 말했다 
-- 하여 아래와 같이 직접 제약조건을 설정

desc usertbl;
desc membertbl;

-- pk를 userid로 설정해주는 쿼리문이다.

alter table membertbl
	add constraint pk_membertbl primary key(userid);
    
desc membertbl;

-- 데이터를 삽입하기 위해 아래와 같이, insert구문을 사용했다.
-- 근데 삽입이 되질 않는다. 왜 일까?
-- pk는 오로지 1개로써 unique한 값만 지닌다고 했다.
-- 그래서 삽입이 되지 않는다. BBK때문에 말이다.
-- 근데, BBK를 제외한 나머지 두줄은 삽입되게 하고 싶다.
-- 그때 insert ignore into문을 사용하면 나머지 2줄은 들어가게 된다.

insert into membertbl values('BBK','비비코','미국');
insert into membertbl values('SKJ','신미나','서울');
insert into membertbl values('CHUNLI','춘리','상해');

insert ignore into membertbl values('BBK','비비코','미국');
insert ignore into membertbl values('SKJ','신미나','서울');
insert ignore into membertbl values('CHUNLI','춘리','상해');

select *
from membertbl;

-- 하지만, duplicate key update문을 사용하면 pk의 내용을 덮어쓰게 된다.
-- 물론 현업에서는 잘 사용하지는 않는다.
-- 다만 책의 내용이 있고 OCP자격증 시험에도 나오니 한번 알아보는 것이다.
-- 쿼리는 아래와 같다.

insert ignore into membertbl values('BBK','비비코','미국')
	on duplicate key update name = '비비코', addr ='미국';


-- DJM은 원래 없던 데이터이기 때문에 그냥 duplicate key update문이 실행되지는 않는다.
insert into membertbl values ('DJM', '동주민', '일본')
   on duplicate key update name='동주민', addr='일본';

    
insert ignore into membertbl values ('SKJ', '신미나', '서울');
insert ignore into membertbl values ('CHUNLI', '춘리', '상해');




