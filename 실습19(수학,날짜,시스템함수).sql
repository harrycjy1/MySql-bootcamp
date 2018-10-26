-- 수학함수

select abs(-100);


-- ceiling()은 올림 , floor()는 내림, round()는 반올림 함수

select ceiling(4.7), floor(4.7), round(4.7);

-- conv()는 진법 변환시켜줌, 16진수 ->2진수 10진수-> 8진수

select conv('AA',16,2), conv(100,10,8);

-- mod()는 나머지 값을 구하는 함수
select mod(157,10), 157%10, 157 mod 10;

-- pow()제곱, sqrt는 제곱근
select pow(2,3), sqrt(9);

-- rand()함수는 0.00000..~0.9999...를 임의대로 리턴한다.
-- 우측컬럼은 주사위 눈을 랜덤으로 구하는 공식이다.
select rand(), floor(1+(rand()*(6-1)));

-- sign()은 양수인지 0인지 음수인지 리턴

select sign(100), sign(0), sign(-100);

-- truncate()는 해당 자릿수까지 출력하고 나머지는 버린다.
select truncate(12345.12345,2), truncate(12334.12345,-2);

-- 날짜함수들
-- adddate()는 day, month, year 단위로 interval을 주면
-- 그 interval만큼의 뒷날을 리턴한다.(더하는 개념)
select 	adddate('2020-02-01',interval 31 day),
		adddate('2020-02-01',interval 1 month);	
        
-- subdate()는 interval만큼 앞의 날짜를 리턴(빼는 개념)

select 	subdate('2020-02-01', interval 31 day),
		subdate('2020-02-02', interval 1 month);
        
-- addtime()은 시간을 더하는 함수이다.
select	addtime('2020-02-01 23:59:59', '1:1:1'),
		addtime('15:00:00','2:10:10');

-- subtime()은 반대
select 	subtime('2020-02-01 23:59:59','1:1:1'),
		subtime('15:00:00','2:10:10');


-- year()는 년도 month()는 월 day(),dayofmonth()는 일,
-- dayofyear()는 일년의 몇번째 일을 리턴.

select 	year(curdate()), month(curdate()), day(curdate()), dayofmonth(curdate()),
		dayofyear(Curdate());
        
-- hour()는 시간, minute()은 분, second()는 초를 리턴

select hour(curtime()), minute(curtime()), second(curtime());

-- now()는 현재 날짜 시간을 리턴

select now();

-- date()는 날짜 time()은 시간만 리턴

select date(now()), time(now());


-- 현재부터 인자값까지의 날짜 차이를 리턴한다.
-- 역으로 인자값을 주면 -값이 나온다

select datediff('20200101',now());
select datediff(now(),'20200101');

-- 아래는 시간차이를 리턴한다 .-를 넣으나 안넣으나 결과는 동일

select timediff('232323','121212'), timediff('23:23:23','12:12:12');

-- dayofweek()는 요일을 리턴하는 상수값을 리턴 일요일 :1 부터 토요일 : 6까지
-- monthname()은 달을 리턴 dayofyear()은 1년의 몇번째 일이냐 리턴

select dayofweek(curdate()), monthname(curdate()), dayofyear(curdate());


-- 그달의 마지막 일을 리턴한다.
select last_day('20200201');

-- makedate()는 2020년에서 32일이 지난 날짜를 리턴한다.
select makedate(2020,32);

-- maketime()은 인자값으로 시간을 만든다.
select maketime(12,11,10);

-- period_add()는 더하고 period_diff()는 차이를 리턴

select period_add('202001',11), period_diff(202001,201812);

-- quarter()는 몇사분기인지 리턴한다.
select quarter(20170909);

-- time _to_set()은 시간을 초로 바꾼다

select time_to_set('12:11:10');

-- 시스템함수
-- 현재 사용자와 db명을 리턴

select current_user(), database();

use sqldb;
select *
from usertbl;

-- found_rows()는 방금 조회된 rows의 건수를 리턴한다
select found_rows();

update buytbl
set price = price/2;

-- row_count()는 방금 update한 건수가 리턴된다.(근데 버전별로 상이함)
select row_count();

select sleep(3);
select '3초후에 이게 보입니다';