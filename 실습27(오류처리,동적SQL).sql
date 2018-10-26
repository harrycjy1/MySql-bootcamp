-- 실습-27(오류처리,동적SQL)
-- 오류처리 구문, 다른언어에서는 예외처리구문에 해당한다.

-- 아래 내용은 직접 우리가 오류코드를 처리해주는 구문을 procedure로 만든것이다.
drop procedure if exists errorproc;
delimiter //
create procedure errorproc()
begin
-- 액션은 계속 continue를 하라는데, 1146이란 오류가 뜨면 '테이블이 없네요'를 출력하는 것이다.
-- 1146은 테이블이 없을때 mysql에서 직접 발생시키는 오류코드번호이고 sqlstate '42502'도 역시
-- 테이블이 없는 sql상태를 나타내는 구문이다.. 오류코드나 오류상태를 ppt에서 말해준 사이트에서
-- 찾아서 넣어주면 여러분들도 오류코드처리구문을 만들수가 있다.
-- 일반적으로 1106이나 이런 숫자가 나오는 것보다 사용자가 알아보기 쉽게 오류처리 구문을 넣어주면
-- 디버깅할때 상당한 도움이 될것이다.
	declare continue handler for 1146 select '테이블이 없네요' as '오류메시지';
-- declare continue handler for sqlstate '42502' select '테이블이 없네요' as '오류메시지';
-- notable이란 테이블은 없다.
select *
from notable;
end//
delimiter ;

call errorproc();

drop procedure if exists errorproc2;
delimiter //
create procedure errorproc2()
begin
declare continue handler for sqlexception
begin
show errors; -- 오류메시지를 보여준다.
select ' 기본키는 중복될수 없네요. 작업을 취소시킵니다' as '메시지';
rollback; -- 작업을 되돌린다.
end;
-- usertbl에서는 userid가 기본키이므로 분명 오류가 발생할것이다.
insert into usertbl values ('LSG','이상구',1988,'서울',null,null,170,current_date());
end//
delimiter ;


call errorproc2();

-- 동적sql문,prepare,execute문
use sqldb;
-- myquery는 변수라고 생각하자. 그 변수에 쿼리문을 대입을 시킨것이다.
-- 즉, 준비만 한다는 것이다. 결과물이 나오진 않는다. 일종의 메모리 할당 개념이다.
prepare myquery from 'select * from usertbl where userid = "EJW"';

-- execute를 해야 비로소 출력물이 나온다.
execute myquery;

-- 메모리를 할당했으면 해제를 해주도록 하자. 아래와 같이..
-- 메모리를 해제를 해줘야 완벽히 이루어진다고 보면된다.
deallocate prepare myquery;

use sqldb;
drop table if exists mytable;
create table mytable ( id int auto_increment primary key, mdate datetime);

-- 여러번 실행해보자.
-- 현재 날짜와 시간을 curdate변수에 넣는다. 즉 실행시점에 날짜와 시간이 들어가는것이다.
-- ex) 회원가입이나, 구매시점, 등하교 등 어느 시점을 기록하고 싶을때 종종 쓰인다.
set @curdate=current_timestamp();

prepare myquery from 'insert into mytable values (null,?)'; -- 쿼리문을 준비한다. 근데 ?가 있다.

-- 쿼리문을 실행하는데 @curdate를 사용해서 ?에 대입을 해주는 것이다.
execute myquery using @curdate;
deallocate prepare myquery; -- 메모리 해제
-- 조회해본다
select *
from mytable;