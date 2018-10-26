#sql 프로그래밍 기본적 방법
#1. if문, case문

# int형 변수 var1을 선언하였다(즉 메모리에 4바이트만큼 할당)
# 만약 var1이 100이라면 아래문장을 실행해라
# var1에 100을 대입했다
# 아니라면 아래문장을 실행해라 
# 구분자이다. 앞에서 배웠다. 
# 코드옆에 주석문을 달면 실행이 안된다.

use sqldb;

drop procedure if exists ifProc;

delimiter //
create procedure ifProc()
begin
	declare var1 int;
    set var1 = 100;
    
    if var1 = 100 then
		select '100입니다';
	else
		select '100이 아닙니다';
	end if;
end//
delimiter ;


#ifProc()을 호출한다.
call ifProc();

/*
입사한지 5년이 지났는지 직접 확인하는 것을 프로그래밍해보자
먼저 변수를 date타입 2개(현재, 입사년도)를 선언하고, 날짜 계산
하기 위해 days를 int형으로 선언한다.
select hire_date into hiredate는 hire_date를 hiredate에 대입하라는 쿼리문이다
그리고 hiredate라는 변수를 이용해서 계산을 하면 된다.
근무일수는 현재날짜 - 입사년월일 이니깐 datediff()를 이용하여 구하고
그것을 다시 365로 나누면 근무년수가 나온다.
그걸로 결과를 출력하는 것이다
*/

drop procedure if exists ifproc2;

delimiter $$
create procedure ifproc2()
begin
	declare hiredate date;
    declare curdate date;
    declare days int;
    
    select hire_date into hiredate
    from employees.employees
    where emp_no = 10001;
    
    set curdate = curdate();
    set days = datediff(curdate, hiredate);
    
    if(days/365)>= 5 then
		select concat('입사한지',days/365,'년이 넘었군요. 축하해요!')
        as '입사경과 년수';
	else
		select concat('아직',days/365,'년 밖에 안됐군요. 화이팅')
        as '입사경과 년수';
	end if;
end $$

delimiter ;

call ifproc2();

#학점을 출력하는 프로그래밍을 해보자


drop procedure if exists ifproc3;

delimiter //
create procedure ifproc3()
begin
declare point int;
declare credit char(1);

set point=77;

if point>=90 then
set credit ='A';
elseif point>=80 then
set credit = 'B';
elseif point>=70 then
set credit ='C';
elseif point>=60 then
set credit ='D';
else
set credit ='F';
end if;

select concat('취득점수 -->',point) as '점수',concat('학점-->',credit) as '취득학점';

end //
delimiter ;


call ifproc3();

-- 위와 결과는 동일하게 나타내는 구문 중 case문을 이용해보자.
drop procedure if exists caseproc;
delimiter //
create procedure caseproc()
begin
	declare point int;
    declare credit char(1);
    set point = 77;
    
    case
		when point >= 90 then
			set credit = 'A';
		when point >= 80 then
			set credit ='B';
		when point >= 70 then
			set credit = 'C';
		when point >= 60 then
			set credit = 'D';
		else
			set credit = 'F';
	end case;
    
    select concat('취득 점수 -->', point) as '점수', concat('학점 -->',credit)
    as '취득학점';
end //
delimiter ;

call caseproc();

use sqldb;

/*
sqldb를 초기화 시킨후 아래 쿼리를 해보자
결과를 보면 userid, 총구매액이 나온다.
근데 고객이름이 없다
*/

select userid, sum(price*amount) as '총구매액' -- 집계함수가 나왔으므로 반드시 group by를 해주어야한다.
from buytbl
group by userid
order by sum(price*amount) desc;

/*고객이름이 없으니 조인을 이용해 usertbl과 엮도록 하자
결과를 보면 총구매액 별로 내림차순 정렬이 되었고, 구매하지 않는 사람도 있다.
이것을 case문을 이용해서 고객분류를 해보자
*/

select U.userid, u.name, sum(price*amount) as '총구매액'
from buytbl b
	right join usertbl U
		on b.userid = u.userid
group by U.userid, U.name
order by sum(price*amount) desc;

#select문 안에 하나의 필드 처럼 고객등급을 case when then문으로 설정을 하는 쿼리문
select u.userid, u.name, sum(price*amount) as '총구매액',
	case
		when sum(price*amount) >= 1500 then '최우수 고객'
        when sum(price*amount) >= 1000 then '우수 고객'
        when sum(price*amount) >= 1 then '일반 고객'
        else '유령고객'
	end as '고객등급'

from buytbl b
right join usertbl u
on b.userid = u.userid
group by u.userid, u.name
order by sum(price*amount) desc;



    
