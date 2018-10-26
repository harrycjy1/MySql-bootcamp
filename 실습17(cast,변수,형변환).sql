-- 아래 cast문은 현재 문자열을 date데이터타입으로 캐스팅해주는 것이다.
-- date는 날짜,time은 시간, datetime은 둘다 나타남

select cast('2020-10-12 12:22:12:456' as date) as'DATE'
from dual;
select cast('2020-10-12 12:22:12:456' as time) as'TIME';
select cast('2020-10-12 12:22:12:456' as datetime) as'DATETIME';

-- 이제 변수를 한번 사용해보자 나중에 스토어드프로시져에서 변수 자주등장 

use sqldb;

-- 변수는 set이란 키워드로 시작하여 @변수형으로 지정을 할수가 있다.
set @myvar1 = 5;
set @myvar2 = 3;
set @myvar3 = 4.25;
set @myvar4 = '가수이름 ===>';

select @myvar1;
select @myvar2+ @myvar3;

-- 보기 좋게 출력하기 위하여 변수르 이용한 것이다.

select @myvar4, name
from usertbl
where height > 180;

-- 하지만 ,변수는 limit다음에는 쓸수가 없다. syntax 에러가 발생함

select @myvar4, name
from usertbl
where height > 180
limit @myvar2;

-- 하여 prepare .. execute .. using 문을 사용하면 된다.
-- 일단 아래 쿼리는 변수 지정후 myquery명으로 ''안에 있는 쿼리문을 준비하는것이다
-- ? 는 @myvar1 변수값이 저장이되어 execute문이 실행되는 것
-- 예를 들어 응용프로그램에서 사용자로부터 입력을 받아서 출력한다면
-- 이렇게 변수를 사용하면 좋을것이다.

set @myvar1 = 3;


prepare myquery
from 'select name, height
from usertbl
order by height
limit ? ';
        
execute myquery using @myvar1;


 
 

use sqldb;

-- 아래쿼리 실행하면 buytbl의 amount의 평균을 나타낸다
-- 하지만 소숫점을 반올림을 하고 싶을때는 cast, convert를 사용하면 된다.
select avg(amount) as '평균구매갯수'
from buytbl;

-- 똑같은 결과를 주지만 문법만 조금 차이가 있다. cast는 as,convert는 ,로 된다는것

select cast(avg(amount) as signed integer) as '평균구매갯수'
from buytbl;

select convert(avg(amount), signed integer) as '평균구매갯수'
from buytbl;

-- 날짜 형식 안에 어떤 구분자가 들어가도 상관없이 date타입으로 casting된다

select cast('12@12@11' as date);
select cast('12/12/11' as date);
select cast('12?12?11' as date);
select cast('12#12#11' as date);

-- concat()은 문자를 연결해주는 역할을 하는 함수

select num, concat(cast(price as char(10)), '*',cast(amount as char(4))) as '단가*수량',
price *amount as '구매액'
from buytbl;

-- cast나 convert를 쓰면 이것은 명시적 형변환을 의미한다
-- 하지만 아래의 경우는 묵시적 형변환에 속한다. 용어를 잘 숙지하자.

select '100'+'100'; -- 문자와 문자를 더한다. 이런경우는 정수로 변환되어 200을 리턴
select concat('100','200'); -- concat()은 문자들을 연결하는 함수이다. 하여 100200을 리턴
select concat(100,'200'); -- concat()안에 정수가 있더라도 문자로 변환되어 연결된다.100200리턴

-- 사실 아래와 같이 쓰는 경우는 잘 없는데 
-- 그래도 여기서 기억할 부분은 프로그래밍 언어에서도 마찬가지니 잘 알자

select 1 > '2mega'; -- 구문은 앞에 2로 시작하니 2가 되어 비교
					-- 결과는 false이므로 0값을 리턴
select 3 > '2mega'; -- true이므로 1을 리턴
select 0 = 'mega2'; -- 문자는 0으로 변환되어 비교된다. 하여 true이다 결과는 1리턴



