

-- 기본적 쿼리문의 순서 생략가능하지만 모두 사용한다면 순서를 외워서 작성해야함
/*
select ...
from...
where...
group by ...
having ...
order by...
*/

use sqldb;

-- 고객이 구매한 건수 확인해보는 쿼리문 중복이 많다
-- 아울러 집계가 되지않아 한눈에 보기 어렵다 이럴때 group by를 사용해보자

select userid, amount
from buytbl
order by userid;

-- 아래 쿼리문을 실행하면 고객별로 구매한 건수가 바로 하눈ㄴ에 들어옴 여기서
-- sum()은 집계함수이며, group by 를 할때 즉 
-- 그룹 지을때 userid로 하겠다는 의미이다
-- 일단 집계함수가 나오면 무조건 group by절이 나와야한다.

select userid, sum(amount)
from buytbl
group by userid
order by userid;

-- 보기좋게 알리아스를 사용
select userid as '사용자아이디', sum(amount) as '구매한 건수'
from buytbl
group by userid
order by userid;

-- 이제 총구매액을 한번 집계하여 보자
-- 총구매액 수량 * 단가가 될것이다

select *
from buytbl;

select userid as '사용자아이디', sum(price*amount) as '총구매액'
from buytbl
group by userid
order by sum(price*amount) desc;

-- 이제는 평균을 구하는 avg()에대해 알아보자.
-- 아래 쿼리는 모든 고객을 대상으로 하여 평균 구매갯수를 알아보는 쿼리이다.
select avg(amount)
from buytbl;

-- 아래는 사용자 별로 평균 구매건수를 구하는 쿼리이다.
-- 역시 userid별로 그룹을 짓고 avg(amount)로 내림차순
select userid as '사용자아이디', avg(amount) as '평균 구매 갯수'
from buytbl
group by userid
order by avg(amount) desc;

-- max(최대값)와 min(최소값)알아보자

select name, height
from usertbl;

-- 아래 쿼리를 치게되면 원하는 결과를 얻지 못함
-- 기준이 없기 때문

select name, max(height),min(height)
from usertbl;

-- 하여, 아래와 같이 코드를 바꿔도 역시 원하는 값을 얻을 수 없다.
-- 이름별로 그룹을 지어버리면 10이 다 나오게 되어있다.

select name, max(height), min(height)
from usertbl
group by name;

-- 그래서 이때는 앞서 배운 서브쿼리를 사용해 결과값을 도출해라

select name, height
from usertbl
where height = (select max(height) from usertbl)
or height = (select min(height) from usertbl);

-- 이제는 건수를 집계하는 count()에 대해서 살펴보자
-- 아래 쿼리는 현재 usertbl에 있는 데이터 건수 집계

select count(*)
from usertbl;

-- 그럼 핸드폰을 가지고 잇는 사람의 건수만 집계해보려는 쿼리를 만들어본다

select count(*) as '휴대폰이 없는사람'
from usertbl
where mobile1 is null;

select *
from usertbl;

select count(mobile1) as'휴대폰이 있는사람'
from usertbl;

use employees;
-- 단순히 건수만 확인하려면 아래와 같이 쿼리를 작성하면 모든 데이터 다 참조해 부하가 상당히 걸림
-- 건수만 확인하고자 한다면 count(*)을 사용

select *
from employees;

select count(*)
from employees;

use sqldb;

-- 아래 쿼리는 아까 사용했던 사용자별 총 구매액을 내림차순으로 정렬한것이다.
-- 이제는 having 절을 이용하는 법을 살펴보자

select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
group by userid
order by sum(price*amount) desc;

/* 그럼 위와 같이 정렬한후 총 구매액이 1000만원 이상만 보고싶다면??
	where절에는 집계함수를 쓸수 없다
    그럼 어떡하냐? having 절을 사용하면 된다.
*/

select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
where sum(price*amount) > 1000
group by userid
order by sum(price*amount) desc;

select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
group by userid
having sum(price*amount) >1000
order by sum(price*amount) desc;

/* 이제 with rollup 에 대해서 살펴보면, 아래 쿼리를 결과를 보면 각각 groupname별로
소합계를 내어주고 마지막에는 총합계를 보여준다
아주 유용한 키워드니 기억하도록 하자.
*/

	select num, groupname, sum(price*amount)
    from buytbl
    group by groupname,num
    with rollup;
   
    select num, groupname
    from buytbl;
    
    select groupname, sum(price*amount)
    from buytbl
    group by groupname
    with rollup;

