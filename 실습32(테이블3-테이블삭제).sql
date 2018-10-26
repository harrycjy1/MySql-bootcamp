
use sqldb;

/*앞에서 했던 sqldb에 usertbl을 drop하고 아무 제약조건을 주지않고 새로 생성해보자.
fk때문에 drop이 안될것이다 buytbl; 을 제거하고 usertbl을 제거해야한다
*/

drop table if exists buytbl;
create table buytbl(
	num int auto_increment primary key,
	#사용자 아이디(fk) 여기서는 pk가 될수 없다.
    #테이블에 pk는 오로지 하나만 존재할수 있기 때문.
    userID char(8) ,
    prodName char(6),
    groupName char(4),
    price int,
    amount smallint 
);

drop table if exists usertbl;
create table usertbl(
	userID		char(8) PRIMARY KEY,
    name		varchar(10),
    birthyear	int,
    addr		char(2),
    mobile1		char(3),
    mobile2		char(8),
    height		smallint,						
    mdate		date,
    nation varchar(10) not null default 'KOREA'
);

/*
데이터삽입을 해보자
그런데 잘못 삽입을 했다 김범수는 생년월일을 몰라서 null을 입력했고
김경호는 오타로 1871을 입력해버렸다.
일단 넣어보자*/

select *
from usertbl;

insert into usertbl values('LSG','이승기',1987,'서울',	'011',	'1111111',	182,'2008-8-8','USA');
insert into usertbl values('KBS','김범수',NULL,'경남',	'011',	'2222222',	173,'2012-4-4',DEFAULT);
insert into usertbl values('KXH','김경호',1871,DEFAULT,	'019',	'3333333',	177,'2007-7-7',DEFAULT);
insert into usertbl values('JYP','조용필',1950,'경기',	'011',	'4444444',	166,'2009-4-4');

#default 제약조건 추가 

alter table usertbl
	alter column addr set DEFAULT '서울';
    
alter table usertbl
add COLUMN gender varchar(3) default '인간';

alter table usertbl
drop COLUMN gender;

# buytbl 데이터 삽입
insert into buytbl values(null,'KBS','운동화',	null,	30,		2);
insert into buytbl values(null,'KBS','노트북',	'전자',	1000,	1);
insert into buytbl values(null,'JYP','모니터',	'전자',	200,	1);
insert into buytbl values(null,'BBK','모니터',	'전자',	200,	5);

/*
현재 usertbl에는 아무런 제약조건이 없다. 하여 alter table쿼리로 기본키를 추가해보자.
그렇다고  not null은 추가할 필요가 없다. PK를 추가하면 자동 not null이 따라붙는다.
*/


alter table usertbl
add constraint PK_usertbl_userid
primary key (userid);

#확인해보자
desc usertbl;

/*
자 이번에는 buytbl에 외래키 제약조건을 추가해보자 그리고 실행을 하면
에러가 난다 왜일가? 현재 외래키를 설정할려고 보니 데이터값에 usertbl에
'BBK'란 userid가 없어서 에러를 나게 하는 것이다.
그래서 BBK를 지우고 다시 한번 하면 잘 설정이 될것이다.
*/

delete from buytbl
where userid='BBK';

alter table buytbl
add constraint FK_usertbl_buytbl
foreign key (userid) references usertbl(userid);

/* 자 근데 , 먼저 buytbl에 외래키 설정을 해놓고도 아래와 같이 데이터를 삽입하고 싶다면
foreign key기능을 off시키는 방법이 있다 . off시키지않으면 usertbl에 userid가 없는 것들은 데이터가 삽입이 안된다.
하여 아래와 같은 방법으로 삽입이 가능 하긴 하지만, 권장하는 방법은 아니다
usertbl에 회원 정보가 없는데 buytbl에 입력할 수 있다면 절차상의 문제가 생길 수 있다.
하여 usertbl에 회원정보가 있는 자료만 buytbl에 데이터를 넣을 수 있는것이 바람직할 것이다.*/

set foreign_key_checks =0;

insert into buytbl values(null,'BBK','모니터',	'전자',	200,5);
insert into buytbl values(null,'KBS','청바지',	'의류',	50,3);
insert into buytbl values(null,'BBK','메모리',	'전자',	80,10);
insert into buytbl values(null,'SSK','책',		'서적',	15,5);
insert into buytbl values(null,'EJW','책',		'서적',	15,2);
insert into buytbl values(null,'EJW','청바지',	'의류',	50,1);
insert into buytbl values(null,'BBK','운동화',	null,	30,2);
insert into buytbl values(null,'EJW','책',		'서적',	15,1);
insert into buytbl values(null,'BBK','운동화',	null,	30,2);

set foreign_key_checks = 1; #외래키 체크기능 다시 on, 이후에는 데이터삽입시에 외래키 체크한다.

#다시 usertbl에 남은 데이터를 삽입한다.
insert into usertbl values('SSK','성시경',1979,'서울',	null,	null	,	186,	'2013-12-12');
insert into usertbl values('LJB','임재범',1963,'서울',	'016',	'6666666',	182,	'2009-9-9');
insert into usertbl values('YJS','윤종신',1969,'경남',	null,	null	,	170,	'2005-5-5');
insert into usertbl values('EJW','은지원',1972,'경북',	'011',	'8888888',	174,	'2014-3-3');
insert into usertbl values('JKW','조관우',1965,'경기',	'018',	'9999999',	172,	'2010-10-10');
insert into usertbl values('BBK','바비킴',1973,'서울',	'010',	'0000000',	176,	'2013-5-5');


/*
 아래 제약조건 추가는 check제약조건이다. 즉 , 1900이후의 값을 입력받으란 것이다.
 원래 오라클이나 mssql에는 check제약조건이 있다. 하지만 mysql에는 이러한 기능이 없다.
 하지만 이런 check기능은 trigger로써 해결할 수 있으니 별 문제가 없다
 그냥 알아두기만 하자
 */
 
 alter table usertbl
 add constraint CK_birthyear
 check (birthyear >=1900 and birthyear<=year(curdate()));
 
 desc usertbl;
 
 #분명 위에서 check 제약조건을 주었음에도 불구 하고 아래 데이터가 추가가 됨을 알수가 있다.
 insert into usertbl values('SEN','신은혁',1888,'전남','019','33333333',177,'2007-7-7');
 
 delete from usertbl
 where userid = 'SEN';
 
 select *
 from usertbl;
 
 select *
 from buytbl;
 
 #아래 쿼리는 아시다시피 BBK를 VVK로 수정하라는 쿼리문이다.
 #실행 해보면 에러가 난다. 왜? fk때문에
 
 update usertbl
 set userid = 'VVK'
 where userid = 'BBK';
 
 #억지로 바꾸고 싶다면 외래키 체크 해제하고 하면 된다.
 set foreign_key_checks =0;
  update usertbl
 set userid = 'VVK'
 where userid = 'BBK';
 set foreign_key_checks =1;
 
 #확인해보면 바뀌어 있는것을 알수가 있다.
 select *
 from usertbl;
 
 select *
 from buytbl;
 
 
 /* 두테이블을 조인하여 아래와 같이 결과를 도출하였다
 근데 분명히 buytbl은 데이터가 12건이 있었는데도 불구하고,
 8건이 조회가 되었다. 왜? BBK가 VVK로 바뀌었으니 당연히 결과값이 안나올것이다.
 */
 select count(*)
 from buytbl;
 
 select u.userid, u.name,b.prodname,u.addr, u.mobile1+u.mobile2 as'연락처'
 from usertbl u
 inner join buytbl b
	on u.userid = b.userid;
    
/*그래서 buytbl을 outerjoin을 통해서 한번 확인해보자
확인해보니 역시 BBK가 나오긴 하지만 구매부분은 다 null이 되어있다.
위에서 BBK를 VVK로 바꿧으니 참조가 되지 않기 때문*/

select u.userid, u.name,b.prodname,u.addr, u.mobile1+u.mobile2 as'연락처'
from usertbl u
left outer join buytbl b
on u.userid = b.userid;

#다시 복구
set foreign_key_checks =0;
update usertbl
set userid = 'BBK'
where userid = 'VVK';
set foreign_key_checks =1;

#이제 제대로 나올것이다.
select u.userid, u.name,b.prodname,u.addr, u.mobile1+u.mobile2 as'연락처'
from usertbl u
left outer join buytbl b
on u.userid = b.userid;

# 계속해서 BBK를 VVK로 바꿔달라고 하면 외래키를 추가할 때 on update cascade 구문을 사용하면
# buytbl에 있는 BBK가 VVK로 자동으로 바뀐다.

# 먼저 buytbl에 서정되어있는 외래키를 제거하고 다시 추가하자.
alter table buytbl
drop foreign key fk_usertbl_buytbl;

alter table buytbl
add constraint fk_usertbl_buytbl
foreign key (userid) references usertbl(userid)
# 이구문이 들어감으로써 usertbl의 PK가 변경되면 따라서 buytbl의 FK인 userid도 따라 바뀐다.
on update cascade;

update usertbl
set userid = 'VVK'
where userid = 'BBK'; #확인해보면 buytbl의 BBK도 VVK로 바뀐것을 알 수 있다.

select *
from usertbl;

select *
from buytbl;

#하지만 현업에서 PK값을 바꾸는 건 권장사항이 아니다.
select u.userid, u.name,b.prodname,u.addr, u.mobile1+u.mobile2 as'연락처'
from usertbl u
left outer join buytbl b
on u.userid = b.userid;

/* 또 VVK가 탈퇴를 할려고 해도 외래키 제약 조건 때문에 삭제가 안된다.
usertbl에서 VVK가 삭제되면 buytbl에 있는 데이터가 붕 떠버리기 때문
그래서 이때는 on delete cascade제약조건을 추가해주면
 자동으로 따러서 VVK의 buytbl에 있는 데이터도 따라서 삭제가 된다.
 */
 
 delete from usertbl
 where userid = 'VVK';
 
 #먼저 buytbl에 설정되어있는 외래키를 제거하고 다시 추가하자
alter table buytbl
drop foreign key fk_usertbl_buytbl;

alter table buytbl
add constraint fk_usertbl_buytbl
foreign key (userid) references usertbl(userid)
on update cascade
on delete cascade;

delete from usertbl
where userid = 'VVK';#usertbl에서 지운것임에도 buytbl에 VVK값도 지워 졌음을 알 수 있다.

select *
from buytbl;

/*
분명 위에서 birthyear 필드에는 check제약조건이 있음에도 불구하고 삭제가 된다
위에서 말했듯이 mysql에서는 check제약조건은 제대로 그 기능을 하지 않는다.
그래서 삭제가 되는것이다.
*/

alter table usertbl
drop column birthyear;

select *
from usertbl;

alter table usertbl
add column birthyears int after addr;

alter table usertbl
add COLUMN birthyeradf int first;







