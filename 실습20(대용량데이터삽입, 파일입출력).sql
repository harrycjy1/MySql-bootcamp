use sqldb;

#대용량 데이터 삽입해보기
#일단 먼저 maxtbl생성, 필드의 데이터타입이 longtext이다
#longtext는 4GB만큼 text데이터를 넣을수 있음

drop table if exists maxtbl;
create table maxtbl (col1 longtext, col2 longtext);

# A라는 문자를 10만번 반복해서 col1에 넣고, 가라는 한글을 10만번 col2에 삽입
insert into maxtbl values( repeat('A',100000), repeat('가',100000));

#앞에서 배운 length()는 필드의 바이트수를 리턴한다. col1은 영어라서 1바이트를 
#가진다고 했다. 하지만 한글은 3바이트이다. UTF-8문자셋에서는 말이다.

select length(col1), length(col2) -- col1 약0.1MB , col2 약 0.3MB
from maxtbl;

#분명 longtext는 4GB저장할 수 있다고 했는데, 1000만바이트가 안들어간다고 에러가 난다.
#기본적으로 mysql은 4MB까지만 저장을 허용한다. 이때는 워크벤치의 설정을 바꿔줘야한다.
# C:\Programdata\MySQL\MySQL Server 5.7\my.ini파일(숨김폴더 보임체크 해야함)에 max_allow부분이 기본적으로
#4MB로 설정되어 있는걸 확인할수 있다. 이걸을 1000MB로 바꿔주면 된다.
#설정이 바뀌면 재부팅을 하는것이 원칙이지만, cmd창을 관리자모드로 열고 net stop mysql을 치자.
# 그럼 mysql서버가 중지되고 , net start mysql을 치면 서비스를 시작하여 적용이 된다. 이제 아래코드를 치면 에러가 발생하지 않는다.

insert into maxtbl values( repeat('A',10000000), repeat('가',10000000));


# 방금 수정한 my.ini의 시스템변수들을 보는 ㅜ커리문이다.
show variables like 'max%';

#다시말하지만 my.ini파일을 수정하게 되면 mysql서비스를 중단했다가 다시 시작해야한다.
# 명심하자 설정이 되었는지 확인할것

show variables like 'secure%';

use sqldb;

#버전이 바뀌면서 책과는 다르게 역슬래쉬 2개를 표시해야만 경로를 인식한다.
#into outfile경로는 usertbl의 내용을 텍스트 파일로 내보내겠다는 것이다.
# 파일을 열어보면 깨지는 경우도 있고 한데 . ms_word로 열면 잘보인다.

-- 텍스트 파일로 내보내기
select * from usertbl
into outfile 'D:\\mysql test folder\\userTBL.txt' char set utf8
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY ','
ESCAPED BY '\\'
LINES TERMINATED BY'\n';

-- 엑셀파일로 내보내기
select * from employees.employees
into outfile 'D:\\mysql test folder\\employees.csv' char set euckr
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY ','
ESCAPED BY '\\'
LINES TERMINATED BY'\n';

select *
from membertbl;

#이제는 외부데이터를 가져와보자. 먼저 기존에 썻던 membertbl을 날리자
drop table if exists membertbl;

#그리고 아래 쿼리는 테이블의 구조를 복사해오는 거이다. (물론 PK까지 복사해욘다)
create table membertbl like usertbl;

desc membertbl;
#이제 불러와서 import를 해보자

-- 텍스트 파일 테이블로 불러 오기
load data local infile 'D:\\mysql test folder\\userTBL.txt'
into table membertbl
character set utf8
FIELDS TERMINATED BY ','
ENCLOSED BY '*'
LINES TERMINATED BY'\n'
IGNORE 1 ROWS;

-- 엑셀 파일 테이블로 불러오기
load data local infile 'D:\\mysql test folder\\employees.csv'
into table membertbl
character set euckr
FIELDS TERMINATED BY ','
ENCLOSED BY '*'
LINES TERMINATED BY'\n'
IGNORE 1 ROWS;

# 잘불러온걸 확인 할수가 있다.
select *
from membertbl;

truncate membertbl;

#위의 파일로 내보는것, 파일로부터 테이블로 데이터 옮기는것 정말 중요
#현업에서 너무 많이 쓰니깐 명령어 잊지 않도록하자.
#1. 파일내보내기 : select * into outfile '파일경로' from 내보낼 테이블명
#2. 파일 테입르로 가져오기 : load data local infile '가져올 파일경로' into table 테이블명



