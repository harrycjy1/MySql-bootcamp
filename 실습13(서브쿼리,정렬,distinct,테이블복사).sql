#서브 쿼리는 쿼리문안에 또 쿼리


#김경호의 키보다 큰사람을 보고 싶을떄
#김경호의 키를 안다면 아래 코드로 작성가능하다
select name, height
from usertbl
where height > 177;

#하지만 김경호의 키를 모른다면 서브쿼리를 이용해야 한다.
#실행순서는 먼저 서브쿼리가 실행 결과값으로 상위 커리 진행
select name,height
from usertbl
where height > (select height 
				from usertbl 
                where name = '김경호');

#아래 쿼리문이 오류뜨느 이유는??
#하위 쿼리의 결과값은 무조건 하나만 나와야 한다.
select name, height
from usertbl
where height >(select height 
				from usertbl
                where addr = '경남');

#하여 위의 코드를 실행하고자 한다면 아래와 같이 쿼리 작성해야한다.
#any키워드를 이용하여 실행
#서브 쿼리의 값이 173,170이었다 서브쿼리 앞에 any의 의미는 or와 비슷한 개념이다
#즉 다시말해 170이상인 데이터를 다 출력하겠다는 의미가 되는것이다
#기억할것은 서브쿼리가 반환하는 값은 키(height)라는 것


select name, height, addr
from usertbl
where height > any(select height
					from usertbl
                    where addr = '경남');


#any 대신 some써도 상관없다.
select name, height, addr
from usertbl
where height > some(select height
					from usertbl
                    where addr = '경남');


#all은 서브쿼리의 결과값 둘다 만족하는 데이터만 출력한다.
#즉 다시말해 170, 173둘다 만족하는 값은 173

select name, height, addr
from usertbl
where height > all(select height
					from usertbl
					where addr = '경남');

#부등호를 바꾸면 170,173과 똑같은 결과값만 리턴하게 되어있다.
select name, height, addr
from usertbl
where height = any(select height from usertbl where addr = '경남');

#또한 위와 똑같은 결과를 얻고자 한다면 앞에서 배운 in을 사용해보자

select name, height, addr
from usertbl
where height in (select height from usertbl where addr = '경남');

-- 다음은 정렬과 관련된 내용이다
-- 기본적으로 orderby를 쓰면 오름차순 정렬된다.
select *
from usertbl
order by mdate;

-- 반대로 내림차순으로 정렬하고 싶다면, desc 를 붙여주면 된다.
select *
from usertbl
order by mdate desc;

-- 아래 쿼리는 키에의해 오름차순 정렬 이름이 같은경우 이름순으로 정렬
select *
from usertbl
order by height;

select *
from usertbl
order by height desc, name asc;

-- 회원테이블에서 회원들의 사는지역을 알고싶다
-- 하지만 아래와 같이 쿼리하면 중복된 데이터가 나온다
select addr
from usertbl;

-- 중복제거

select distinct addr
from usertbl;

-- 이제 데이터개수 제한 두는 limit키워드에 대해서 알아보자

use employees;

-- 근속년수가 가장 많은 5명순으로 출력
select emp_no, hire_date, first_name, last_name
from employees
order by hire_date
limit 5;

-- limit 100,5 -> 좌측처럼 100번부터 5건 이렇게 조건을 줄수도 있다.


-- 테이블 복사방법
use sqldb;
create table buytbl2 (select *from buytbl);

select *
from buytbl2;

-- 테이블을 복사하더라도 제약조건은 복사 안됨(pk,fk)

desc buytbl;
desc buytbl2;

