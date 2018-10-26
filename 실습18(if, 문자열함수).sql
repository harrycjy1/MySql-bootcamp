
-- mysql의 내장함수들

-- if(a,b) 참이면 a , 거짓이면 b출력

select if(100>200, '참','거짓');

-- ifnull은 1번째 인자가 null이면 2번째 인자값을 출력
-- 1번째 인자값이 null이 아니면 1번 출력

select ifnull(null,'널이 아니군요');

-- nullif는 1번째 인자값과 2번째 인자값이 같으면 null반환
-- 같지 않다면 1번째 인자값 출력
select nullif(100,100), nullif(200,'널이아니군');

-- switch문과 흡사
-- case 가 10이면 when10에 걸려서 then '십'을 출력
-- case when then else end 형으로 기억
select case 10
when 1 then '십'
when 5 then '오'
when 10 then '십'
else '모름'
end;

-- ascii함수는 인자값을 아스키코드값으로 출력
-- a의 아스키코드값은 65 

select ascii('A'),char(65);

-- mysql은 문자셋을 utf-8사용 영문은 1바이트 한글은 3바이트 사용한다
-- 하여, bit_length는 비트수를 반환하고, char_length()는 문자열의 길이, length()는 바이트수를 리턴

select bit_length('abc'), char_length('abc'),length('abc');
select bit_length('가나다'), char_length('가나다'), length('가나다');

-- 문자열 함수들 시작

-- concat_ws()는 첫번째 인자값을 가지고 뒤에오는 인자값들을 구분 지어준다
select concat_ws('/','2020','02','09');

-- 찾기 함수들이다
-- 결과를 보면 이해하기 수월, elt()는 첫번째인자값의 인덱스에 가서 있는것을 출력하는것
-- field() 는 첫번째값과 동일한 것의 인덱스를 반환해준다
-- find_in_set()은 첫번째 인자값을 문자열의 값 중 어디 있는지 위치를 반환(,를 구분자로써야함)해주고,
-- instr()는 첫번째 인자값중 두번째 인자값이 시작하는 위치를 반환
-- locate()는 instr()과 동일하지만 인자값이 반대로 입력

select elt(2,'하나','둘','셋'), field('둘','하나','둘','셋'),
		find_in_set('넷','하나,둘,셋,넷'),instr('하나둘셋','둘'),
        locate('둘','하나둘셋');
        
-- format은 엑셀의 round()와 유사하다. 소숫자리 지정하는데 반올림을 해준다.
-- 그리고 1000단위 구분도 해준다.

select format(123456.123456,4); # 소수점 넷째자리에서 반올림

-- bin()은 인자값을 이진수로, hex()는 16진수로, oct()는 8진수로 변환해준다.
-- 진법변환 못하면 안된다

select bin(31),hex(31),oct(31);

-- insert()는 replace개념과 같다 3번째부터 4자리를 !!!!로 대체해라라는 함수
select insert('abcdefghi',3,4,'!!!!'), insert('abcdefghi',3,2,'aaaa');

-- left()는 왼쪽에서 3자를, right() 오른쪽에서 3자를 출력한다.
select left('abcdefg',3), right('낭ㄹ호하아라',3);

-- ucase 대문자 lcase소문자

select lower('abCd'),upper('abcD');
select lcase('ABCD'), ucase('abcd');

-- ltrim(),rtrim()은 문자열의 왼쪽/오른쪽 공백을 제거 단 중간의 공백은 제거 되지 않는다.
select ltrim('        dfd fg'), rtrim('dkfgk fkg           ');

-- trim()은 양쪽공백 다제거 trim(both..from..)은 양쪽의 'ㅋ'문자를 지운다
select trim('    this is hell    '), trim(both 'z' from 'zzzz cheer up zzzz');

-- trim(leading..from)은 왼쪽의 ㅋ를 지움
select trim(leading 'z'from 'zzzz hi zzzz');

select trim(trailing 'z'from'zzzzhizzzz');

# repeat 은 인자값을 반복
select repeat('이것이 mysql이다',5);

# replace()는 문자열 대치 함수이다.
select replace('이것이 mysql이다', 'mysql이','java');

# reverse()는 문자열 뒤집기
select reverse('mysql');

# space()는 공백을 만들어 준다.
select concat('이것이', space(30), 'mysql이다');

#substring()는 문자열 잘라내기 함수이다.
select substring('우리나라만세',5,2);

-- substring_index()는 구분자. 을 가지고 2째이후는 출력하지 않게 한다.
select subString_index('cafe.naver.com','.',2);

-- -가 되어버리면 오른쪽 부터 시작하여 2번째 이후로는 출력하지 않게 된다.
select substring_index('cafe.naver.com','.',-2);




