
# 조인은 2테이블 이상을 결합하여 뭐리하여 결과를 출력하는 sql고급부분에 해당한다
# 의미를 잘 이해하고 잘 활용 하도록 하자. 현업에서 많이 씀

use sqldb;
# 아래 코드는 buytbl과 usertbl을 inner join하였다
# 근데 조인의 조건이 buytbl.userid와 usertbl.userid가 같은걸 조인한것이다.
# 그걸 대상으로 하여 또한 조건을 주었는데, buytbl.userid가 "JYP"인것만 출력하도록 한것

select *
from buytbl
	inner join usertbl
    on buytbl.userid = usertbl.userid
where buytbl.userid = 'jyp';

select *
from buytbl;

select *
from usertbl;


-- where절을 주지 아니하면 모든 데이터를 가져온다.
select *
from buytbl
inner join usertbl
on buytbl.userid = usertbl.userid;

-- 통상위의 코드와 동일한 결과를 출력하기 위해 아래와 같이 쿼리를 만드는 개발자도 있다.
-- 선생님도 아래코드를 많이 사용 현업가면 많다

select *
from buytbl B, usertbl U
where b.userid = u.userid
and b.userid = 'JYP';

-- 쿼리를 실행하면 에러가 난다. 왜 에러가 날까?
-- 바로 userid때문, userid는 두테이블에 다 있으므로
-- userid가 어디껀지 모호하다고 에러를 나타내는것

select userid, name,prodname,addr,mobile1 + mobile2 as'연락처'
from buytbl
inner join usertbl
on buytbl.userid = usertbl.userid;

-- 원래 조인을 할때는 필드명 앞에 테이블명을 적어주느게 원칙
-- 하지만 이렇게 하면 쿼리문이 상당히 길어진다 이때 테이블에 알리아스를 주어 쉽게 해결할수 있다.
-- 현업에서도 이렇게 사용한다
select buytbl.userid, usertbl.name, buytbl.prodname,
	usertbl.addr, usertbl.mobile1+usertbl.mobile2 as '연락처'
from buytbl
inner join usertbl
on buytbl.userid = usertbl.userid;

-- 아래 쿼리는 테입르에 직접 알리아스를 주고 활용한 쿼리문
-- 코드가 줄어든거 ㄹ확인할 수 있음

select B.userid, U.name, b.prodname, u.addr , u.mobile1+u.mobile2 as'연락처'
from buytbl as B    #as는 가독성을 위해 넣어주면 좋긴 함
inner join usertbl as u
on b.userid = u.userid
where b.userid = 'jyp';

-- 아래 쿼리는 전체회원들을 구하려고한 쿼리문
-- 하지만 이승기 임재범 윤종신 조관우가 나타나지 않았다 다시말해 구매한 기록(=buytbl에 아이디가 존재하는)이 있는 사람들의 목록만 나옴
-- 무엇을 의미하는가? inner join은 buytbl의 userid와 usertbl의 userid가 같은것만 출력하는것
-- 그럼 전체 회원들을 다 보기 위해서는 outter조인을 사용해야 다보임

select b.userid, U.name, b.prodname, u.addr , u.mobile1+u.mobile2 as'연락처'
from usertbl as u
inner join buytbl as b
on u.userid=b.userid
order by u.userid;

-- 먼저 이부분을 쿼리하고 위에껄 해보자
select *
from usertbl;

select *
from buytbl;

-- 아래 쿼리가 바로 leftouterjoin 이다 즉 왼쪽테이블을 다 출력하라는 것
select B.userid, U.name, b.prodname, u.addr , u.mobile1+u.mobile2 as'연락처'
from usertbl as u
left outer join buytbl as b
on u.userid = b.userid
order by u.userid;

-- 통사 outer join을 오라클에서는 아래 쿼리문으로 대체
select B.userid, U.name, b.prodname, u.addr , u.mobile1+u.mobile2 as'연락처'
from usertbl as u, buytbl b
where u.userid (+)= b.userid
order by u.userid;

-- 작동안됨

select *
from usertbl;

-- 아래는 구매하적이 있는 사람들을 조회해보는 쿼리문이다.
-- 중복방지를 위애 distinct사용해서 구매한적이 있는 사람을 일목요연하게 출력

select distinct u.userid, u.name,u.addr,u.mobile1+u.mobile2 as '연락처'
from usertbl U
inner join buytbl B
on u.userid = b.userid
order by u.userid;

-- 아래 쿼리는 위와 같이 distinct와 같은 결과를 출력한다.
-- exitsts구문은 서브쿼리에 필드가 존재하는지만 확인하여 리턴한다. 즉
-- boolean값을 리턴해준다. 순서는 먼저 첫번째 select를 실행하고 그 결과를 토대로
-- where exist의 select를 비교해서 맞는행이 있다면 리턴하여 출력하게 되므로
-- 결과적으로 distinct 키워드와 같은 역할을 한다.
select u.userid, u.name, u.addr
from usertbl u
where exists (select * from buytbl b where u.userid = b.userid);

-- 다대다의 관계를 테이블로 표현해본다
use sqldb;

-- 다대다 관계를 조인해보기 위해 아래와 같이 3개의 테이블을 만드는 쿼리문을 만들었다.
drop table if exists stdtbl;
create table stdtbl (stdname varchar(10) not null primary key,
					addr char(4) not null
                    );
                    
drop table if exists clubtbl;
create table clubtbl (
clubname varchar(10) not null primary key,
roomno char(4) not null
);

#stdclubtbl 은 외래키(foreign key)를 설정했다 이부분을 잘봐야함
#외래키는 기본키와 함게 조인을 위해 사용하기 때문에 테이블 생성시 
#외래키를 설정하는 것

drop table if exists stdclubtbl;

create table stdclubtbl(
num int auto_increment not null primary key,
stdname varchar(10) not null,
clubname varchar(10) not null,
foreign key(stdname) references stdtbl(stdname),
foreign key(clubname) references clubtbl(clubname)
);

# 각각의 테이블에 데이터를 삽입
insert into stdtbl values ('김범수','경남'),('성시경','서울'),('조용필','경기'),('은지원','경북'),('바비킴','서울');

insert into clubtbl values('수영','101호'),('바둑','102호'),('축구','103호'),('봉사','104호');

insert into stdclubtbl values (null,'김범수','바둑'),(null,'김범수','축구'),(null,'조용필','축구'),
(null,'은지원','축구'),(null,'은지원','봉사'),(null,'바비킴','봉사');

#어제 만든 3개의 테이블을 조인을 해서 이름/지역/도아리명/동아리방 호수를 출력해보자
#여기서 기억할것은 조인을 하기 위해서는 대부분 pk와 fk를 가지고 설정하는 경우가 많다
#아래 쿼리는 학생명을 기준으로 한것이다.
select S.stdname,s.addr,c.clubname, c.roomno
from stdtbl s
inner join stdclubtbl sc
on s.stdname = sc.stdname
inner join clubtbl c
on sc.clubname = c.clubname
order by s.stdname;

#동아리명을 기준으로 
select c.clubname, c.roomno, s.stdname, s.addr
from clubtbl c
inner join stdclubtbl sc
on c.clubname = sc.clubname
inner join stdtbl s
on sc.stdname = s.stdname
order by c.clubname;

