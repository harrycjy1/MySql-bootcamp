#아래 쿼리문은 항상 쌍으로 실행을 현업에서 한다
#설명을 하자면, 만약 sqlDB가 존재한다면 삭제를 하고,
#다시 sqlDB를 만들어라라는 의미를 지니고 있다.

drop database if exists sqlDB;

#아래 쿼리문은 에러가난다 왜나면 sqldb가 없기때문에 삭제가 불가능하다
#drop database sqlDB;
create database sqlDB;

use sqlDB;

#회원 테이블 생성
create table usertbl(
	userID		char(8) not null primary key,	#사용자 아이디
    name		varchar(10) not null,
    birthyear	int not null,
    addr		char(2) not null,
    mobile1		char(3),
    mobile2		char(8),
    height		smallint,						#키(smallint는 2바이트임)
    mdate		date							#회원가입일
);

#회원 구매 테이블 생성
create table buytbl(
	num int auto_increment not null primary key,
	#사용자 아이디(fk) 여기서는 pk가 될수 없다.
    #테이블에 pk는 오로지 하나만 존재할수 있기 때문.
    userID char(8) not null,
    prodName char(6) not null,
    groupName char(4),
    price int,
    amount smallint not null,
    #usertbl에 있는 userID를 참조해라 무엇으로? 외래키로
    foreign key(userID) references usertbl(userID)
);

#usertbl에 데이터 삽입
insert into usertbl values('LSG','이승기',1987,'서울',	'011',	'1111111',	182,	'2008-8-8');
insert into usertbl values('KBS','김범수',1979,'경남',	'011',	'2222222',	173,	'2012-4-4');
insert into usertbl values('KXH','김경호',1971,'전남',	'019',	'3333333',	177,	'2007-7-7');
insert into usertbl values('JYP','조용필',1950,'경기',	'011',	'4444444',	166,	'2009-4-4');
insert into usertbl values('SSK','성시경',1979,'서울',	null,	null	,	186,	'2013-12-12');
insert into usertbl values('LJB','임재범',1963,'서울',	'016',	'6666666',	182,	'2009-9-9');
insert into usertbl values('YJS','윤종신',1969,'경남',	null,	null	,	170,	'2005-5-5');
insert into usertbl values('EJW','은지원',1972,'경북',	'011',	'8888888',	174,	'2014-3-3');
insert into usertbl values('JKW','조관우',1965,'경기',	'018',	'9999999',	172,	'2010-10-10');
insert into usertbl values('BBK','바비킴',1973,'서울',	'010',	'0000000',	176,	'2013-5-5');

#buytbl에 데이터 삽입
insert into buytbl values(null,'KBS','운동화',	null,	30,2);
insert into buytbl values(null,'KBS','노트북',	'전자',	1000,1);
insert into buytbl values(null,'JYP','모니터',	'전자',	200,1);
insert into buytbl values(null,'BBK','모니터',	'전자',	200,5);
insert into buytbl values(null,'KBS','청바지',	'의류',	50,3);
insert into buytbl values(null,'BBK','메모리',	'전자',	80,10);
insert into buytbl values(null,'SSK','책',		'서적',	15,5);
insert into buytbl values(null,'EJW','책',		'서적',	15,2);
insert into buytbl values(null,'EJW','청바지',	'의류',	50,1);
insert into buytbl values(null,'BBK','운동화',	null,	30,2);
insert into buytbl values(null,'EJW','책',		'서적',	15,1);
insert into buytbl values(null,'BBK','운동화',	null,	30,2);

select *
from usertbl;

select *
from buytbl;