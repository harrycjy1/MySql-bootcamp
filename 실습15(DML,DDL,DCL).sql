/*
통상 sql은 아래와 같은 불류로 나뉜다
1. DML(Data Manipulation Language) - update, select, insert, delete 
dml은 얼마든지 취소가능하다 rollback

2. DDL(Data Definition Language) - Create, drop, alter , truncate
취소 불가 바로 실행됨

3. DCL(Data Control Language) - GRANT REVOKE DENY
사용자에게 권한을 부여거나 없앨때 사용*/

-- 새로운 테이블인 testtbl1을 만들고 안에 데이터를 insert into를 통해서 삽입
use sqldb;

drop table if exists testtbl1;

create table testtbl1(
id int,
username char(3),
age int
);

insert into testtbl1 values (1,'홍길동',25);

select *
from testtbl1;

-- 만약 insert할때 사용자가 원하는 필드만 넣고싶을때는 테이블명(컬럼명,컬럼명)형태로 지정
-- 넣어주지 않은 필드는 당연히 null이 된다.
insert into testtbl1(id,username) values(2,'김연아');

-- 필드를 사용자 맘대로 설정해서 넣어줄수도 있다.
insert into testtbl1(username,age,id) values('초아',29,3);

use sqldb;
drop table if exists testtbl2;
create table testtbl2(
id int auto_increment primary key,
username char(3),
age int
);

insert into testtbl2 values
(null,'지민',33),
(null,'강민',22),
(null,'은수',11);

-- 만약 직접넣어주게되면 auto_increment는 적용되지 않는다

insert into testtbl2 values(9,'연수',23);


delete from testtbl2
where id=9;

select *
from testtbl2;

-- autoincrement한 필드가 마지막으로 삽입된것을 조회할때는 last_insert_id()함수를 이용
select last_insert_id();

-- 만약 건너뛰어서 100번부터 증가시키면서 넣고 싶을땐 아래와같이 수정해보자

alter table testtbl2 auto_increment = 100;

insert into testtbl2 values(null,'연수',23);

select * from testtbl2;

use sqldb;

create table testtbl3(
id int auto_increment primary key,
username char(3),
age int
);

-- 다시 testtbl3의 자동증가를 1000부터 시작하게끔 testtbl3테이블의
-- auto_increment를 1000으로 수정
alter table testtbl3 auto_increment=1000;

-- 생소하지만 알아둘 필요가 있는 서버변수이다
-- set 키워드다음 @@가 붙으면 서버변수
-- 3씩 자동증가 하게끔 설정하는것
set @@auto_increment_increment = 3;

insert into testtbl3 values
(null,'나연',33),
(null,'동수',22),
(null,'은혁',11);


-- 조회해보면 id가 3씩 증가되는것을 볼수가 있다
select *
from testtbl3; 