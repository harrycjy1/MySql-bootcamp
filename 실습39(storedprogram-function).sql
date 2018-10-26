
#스토어드 함수에 대해서 알아보자

/* 스토어드 프로시져와 스토어드 함수는 매우 유사하지만 활용도는
	역시 스토어드 프로시져가 많이 활용된다.ALTER하지만 한번씩 스토어드 함수를
    사용할대도 있다.
    
    차이점은
    
    1. 스토어드함수
		파라미터에 in,out등을 사용할수 없음.
        모두 입력파라미터로 사용
        returns 문으로 반환할 값의 데이터 형식 지정
        본문안에서는 return문으로 하나의 값 반환
        select문장안에서 호출ALTER
	2. 스토어드 프로시져
		파라미터에 in, out 사용 가능
        별도의 반환구문 없음
        필요하다면 여러개의 out파라미터사용해서 값 반환 가능
        call로 호출
        안에 select문 사용 가능
        여러 sql문이나 숫자 계산등의 다양한 용도로 사용
*/

#sqldb를 사용
use sqldb;

#스토어드 함수는 procedure가 아니라 function이다 헷갈리지 않도록 하자
#아래 함수는 2개의 매개변수를 받아서 더하여 하나의 int값을 리턴하는 것이다.

drop function if exists userfunc;

delimiter $$
# 매개변수가 2개이면 반환(리턴값)의 데이터 형식이 int형이다
create function userfunc(value1 int, value2 int)
	RETURNS int
    
begin 
	RETURN value1+value2;
end$$
delimiter ;

select userfunc(1000,-700);

#출생년도를 입력하면 나이를 반환하는 스토어드함수를 만들어보자
drop function if exists getagefunc;

delimiter $$
create function getagefunc(byear int)
	returns int

begin 
	declare age int;
    set age = year(curdate()) - byear;
    return age;
end$$
delimiter ;

select getagefunc(1978) as '만 나이';

# 두 개의 나이차를 구하고 싶다면 변수를 이요해서 저장해두고 사용하면 된다
select getagefunc(1978) into @age1978;
select getagefunc(2007) into @age2007;

select concat('2007년생과 1978년생의 나이 차이는 : ',@age1978 - @age2007,'살입니다.') as '나이 차이';

#아래와 같은 용도로 스토어드 함수는 많이 쓰인다. 하지만 빈도수는 스토어드 프로시져보다는 미미하다

select userid, name, getagefunc(birthyear)as'만 나이'
from usertbl;

#저장 되어 있는 스토어드 함수의 내용을 보고 싶다면 아래와 같이 하면 된다.
show create function getagefunc;

#함수 제거
drop function getagefunc;


/*	커서를 학습해보자 
	커서는 테이블을 쿼리한 후, 쿼리의 결과인 행 집합을 한 행씩 처리하기 위한 방식이다.
    C나 자바에서 파일입출력과 비슷한 개념이다.
    파일을 처리하기 위해서 먼저 파일을 열고, 첫 번째 데이터를 읽고 
    다음 데이터가 저장되어 있는 공간으로 파일포인터가 이동한다.
    이런 식으로 파일의 끝(EOF)까지 반복한다.
    그리고 파일포인터를 닫는다
*/

#예제로 학습해보자
#고객의 평균키를 구하는것

drop procedure if exists cursorproc;

delimiter $$
create procedure cursorproc()
begin
	declare userheight int;				#고객의 키를 저장할 변수
    declare cnt int default 0;			#고객의 인원수 (=읽은 행의 갯수)
    declare totalheight int DEFAULT 0;	#고객 키의 총합을 저장ㅎㄹ 변수
	#행의 끝인지 아닌지를 알아보는 변수(플래그변수개념) 기본값 : false로 설정
    declare endofrow boolean default false;
    
    #아래와 같이 조회를 하면 키값들이 출력이 될것이다.
    #그리고 난 뒤 cursor가 그 키 값에 처음 부분에 위치하는 것이다.
    declare usercursor CURSOR FOR
		select height
			from usertbl;
            
	#만약 커서가 위치를 움직이면서 마지막에 도달해서 
    #더 이상 데이터를 발견 못하면 endofrow를 true로 설정하게 한다.(물론 자동실행된다)
    declare CONTINUE handler
		for not found set endofrow= true;
        
	open usercursor; -- 커서를 열다
    # 무한 루프를 돈다.
    cursor_loop : loop
		#현재 usercursor가 가리키고 있는 height를 userheight에 저장함
        #저장한 후 , usercursor는 다음 행으로 위치 이동한다.
        FETCH usercursor into userheight;
        #만약 endofrow가 false이면 루프를 진행 true라면 break
        if endofrow then
			leave cursor_loop;
		end if;
        
        set cnt = cnt+1; -- 고객수 증가시킴
        set totalheight = totalheight + userheight; -- 고객 키 누적
	end loop cursor_loop;
    
    select concat('고객의 평균 키 : ',(totalheight/cnt));
    close usercursor;
end $$
delimiter ;

call cursorproc();

#한가지 더 예제를 해보자
#buytbl에 grade 컬럼 추가

alter TABLE usertbl
	add grade varchar(10);
    
select * 
from usertbl;

#이제 스토어드 프로시져를 만들자
drop procedure if exists gradeproc;
delimiter $$
create procedure gradeproc()
begin
	declare id varchar(10);		#사용자 id저장 변수
    declare hap bigint;			#총 구매액 저장 변수
    declare usergrade char(10);	#고객 등급을 저장할 변수

    -- 행의 끝인지 아닌지 알아보는 변수
    declare endofrow boolean default false;
    
    #커서 아래 조회문에 선언
    #right outer join을 하는 이유가? 하나도 구매하지 않은 고객들도 출력하기 위함
    declare usercursor CURSOR FOR
		select u.userid, sum(b.price*b.amount)
			from buytbl b
            right outer join usertbl U
            on b.userid = u.userid
            GROUP BY u.userid;
            
	#가져올 데이터를 발견하지 못하면 true로 설정
    DECLARE continue HANDLER
    for not found set endofrow = true;
    
    open usercursor;
    grade_loop : LOOP
    #위의 조회 결과중 id와 sum값을 각각 대입함 그리고 커서 이동
		fetch usercursor into id, hap;
        
        -- 가져올 데이터가 없으면 loop탈출
        if endofrow then
			leave grade_loop;
        end if;
        
        # 조회 결과 중 hap에 따라 grade설정
        case
			when(hap>=1500)then
				set usergrade = '최우수고객';
			when(hap>=1000)then
				set usergrade = '우수고객';
			when(hap >=1)then
				set usergrade = '일반고객';
			else
				set usergrade = '유령고객';
		END CASE;
        
        #위에서 저장되어진 usergrade변수의 값을 usertbl의 grade필드에 수정한다.]
        update usertbl
		set grade = usergrade
        where userid = id;
	END LOOP grade_loop;
    close usercursor;

end$$
delimiter ;

call gradeproc();

select u.userid '고객아이디', u.name '고객이름',sum(b.amount*b.price)'총 구매액', u.grade '고객등급'
	from usertbl U
    left outer join buytbl b
    on u.userid = b.userid
    group by u.userid, u.name, u.grade
    ORDER BY sum(price*amount) desc;
    
select *
	from usertbl;
    