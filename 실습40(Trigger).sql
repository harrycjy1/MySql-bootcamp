
#트리거에 대해서 이제 본격적으로 알아보자
#장표에서 말했듯이 트리거는 어떤  특정한 테이블에 부착이 되어
#그 테이블에 삽입, 수정, 삭제의 작업이 일어나면 자동실행되는
#스토어드프로그램의 부류이다
#물론 스토어드 함수, 스토어드 프로시져 처럼 IN,OUT등 인자값을 가질 수는 없다.

use testdb;
drop table if exists testtbl;
create table testtbl(
	id int,
    txt varchar(10)
);

insert into testtbl values
(1,'EXID'),(2,'애프터스쿨'),(3,'아이오아이');

#이제 testtbl에 부착시킬 트리거를 만들어본다.

drop TRIGGER if exists trgtrigger;
delimiter $$
create trigger trgtrigger		#트리거이름
	after delete				#testtbl에 데이터가 삭제된 액션
    on testtbl
    for each row 				#각 행마다 적용
    
begin 
	declare txt_singer varchar(10);
    
    set @msg = concat('삭제된 가수 이름 : ',old.txt);
end$$
delimiter ;


#삽입을 했는데도 msg가 출력되지 않았다 그이유는?
#트리거를 정의 했을 때 delete부분 트리거만 부착시킨 것이다.
set @msg = '';
insert into testtbl values(4,'나인뮤지스');
select @msg;

#역시 수정할때도 트리거를 부착시키지 않았기 때문에 결과가 안나옴
set @msg = '';
update testtbl set txt = '에이핑크'
where id = 3;
select @msg;

#delete시에는 됨
set @msg = '';
delete from testtbl
	where id =4;
select @msg;

select *
from testtbl;

#이제 로그데이터를 남기는 트리거를 만들어 보자

use sqldb;
drop table buytbl;

# 로그데이터를 남기기 위해 usertbl의 백업테이블인 backup_usertbl을 생성해보자
# 기존 usertbl에 3개의 컬럼을 더 추가했다
drop table if exists backup_userTbl;
create table backup_userTbl(
userID		char(8) not null primary key,	#사용자 아이디
    name		varchar(10) not null,
    birthyear	int not null,
    addr		char(2) not null,
    mobile1		char(3),
    mobile2		char(8),
    height		smallint,						#키(smallint는 2바이트임)
    mdate		date,
    
    modtype char(2),		#변경된 작업을 명시하기 위해 추가(수정이냐? 삭제냐
    moddate DATETIME,		#변경된 날짜 저장
    moduser varchar(256)	#변경한 사용자
);

#이제 usertbl에 수정시 자동 실행되는 트리거를 생성하여 부착시키자
drop trigger if exists backusertbl_updatetrg;
delimiter $$
create trigger backusertbl_updatetrg
	after UPDATE
    on usertbl
    for each row
begin
	#데이터를 update후 자동으로 실행되는 트리거이다.
    #여기서 old는 시스템 DB로써 트리거에 의해서 변경되기전 데이터를
    #잠시 보관하는 것이다. 하여, 위에서 3개 추가한 컬럼에 각각 데이터를 삽입하고있다.
    
    insert into backup_userTbl values	(old.userid,old.name, old.birthyear, old.addr,old.mobile1,
										old.mobile2,old.height,old.mdate,'수정',sysdate(),current_user()
										);
end$$
delimiter ;


#데이터 수정
update usertbl
	set birthyear = 1885
    where userid = 'BBK';
    
#각 테이블마다 확인해보자
select *
from userTbl;

select *
from backup_userTbl;


#이제는 삭제 될 때 자동 시행되는 트리거를 만들어보자
drop trigger if exists backusertbl_deletetrg;
delimiter $$
create trigger backusertbl_deletetr
	after delete
    on usertbl
    for each row
begin
	#delete 시 자동으로 실행되는 트리거이다
    #여기서 old는 시스템 DB로써 트리거에 의해서 변경되기전 데이터를 잠시 보관
    #하여, 위에서 3개 추가한 컬럼에 각각 데이터를 삽입하고 있다.
    insert into backup_userTbl values	( 	old.userid,old.name, old.birthyear, old.addr,old.mobile1,
										old.mobile2,old.height,old.mdate,'삭제',sysdate(),current_user()
										);
end $$
delimiter ;

#데이터를 삭제했다
delete from usertbl
	where height = 174;
    
#테이블 확인
select *
from usertbl;
select *
from backup_usertbl;

#truncate는 DML이 아닌 DDL이므로 transaction이 발생하지 않아 트리거가 작동하지 않는다
truncate table usertbl;

select *
from usertbl;

select *
from backup_usertbl;

#하지만, backup_usertbl을 확인해보면 역시나 트리거가 작동안한것을 볼 수 있다.
#하여 권한 설정시 일반 유저나 초보전산직에겐 truncate권한을 주지말자

select *
	from backup_usertbl;
    
    
#권한 설정으로 insert나 delete,update등을 사용자 별로 제한할 수도 있지만,
#아래와 같이 강제로 오류를 발생시켜 입력을 테이블에 못하도록 할 수도 있다.
drop trigger if exists usertbl_inserttrg;

delimiter //
create trigger usertbl_inserttfg
	after insert
    on usertbl
    for each row
begin
	signal sqlstate '45000' #사용자가 강제로 오류를 발생시키는 함수
    set MESSAGE_TEXT = '데이터를 저장할 수 없습니다. 전산팀에 문의하세요';
end //
delimiter ;

#삽입을 시도했지만, 삽입이 되지 않는다
insert into usertbl values('BBC','비비씨',1977,'현풍','010','00000000',175,'2013-5-5');

#조회 해도 없다
select * from usertbl;

#하지만 가장 깔끔한 방법은 권한을 주지 않는것이 가장 좋다
#위처럼 테이블마다 일일히 다 해주면 번거롭다
#트리거는 임시테이블을 생성한다 즉 앞서 잠깐 보였던 NEW, OLD가 바로 시스템 임시테이블이다
#하여 insert시에는 NEW임시테이블만 생성되고, DELETE시에는 OLD임시테이블만 생성된다.
#하지만 update시에는 NEW,OLD 테이블 2개다 생성한다 기억하자.

#이번에는 before 트리거에 대해서 알아보자
#before트리거는 테이블에[ 데이터를 저장하기 전에 NEW임시테이블로 값들의 유효성을 미리 검사 할 수 있다.
#잘못된 입력값을 바꿔서 입력시킬수 있다는 것이다.

#다시 sqldb초기화

drop trigger if exists usertbl_beforeinserttrg;
delimiter //
create trigger usertbl_beforeinserttrg
	before insert
    on usertbl
    for each row
begin
	if new.birthyear < 1900 then 
    set new.birthyear =0;
    #입력 데이터가 현재년도 이후라면 현재 연도를 값으로 지정
    elseif new.birthyear > year(curdate()) then
		set new.birthyear = year(curdate());
	end if;

end //
delimiter ;

#데이터의 출생년도가 이상하지만 저장이 잘되고 조회하면 입력값이 다르게 나온것을 알 수 있다.
insert into usertbl values('CCC','시시시',1888,'현풍','010','12345667',187,'2017-10-05'),
('AAA','dfdf',2578,'대구','123','12345678',180,'2011-09-05');

select * from usertbl;

show triggers from sqldb;

drop trigger usertbl_beforeinserttrg;

#트리거는 테이블에 하상 부착이 되어 자동실행되기 때문에 테이블이 삭제되면
#자동으로 그 테이블에 부착되어 있는 트리거는 제거가 된다.
#하여 sqldb초기화하면 당연히 트리거는 없을거다

#중첩 트리거에 대하여 실습해보자
#먼저 실습할 공간이 되는 triggerdb를 생성하자

drop database if exists triggerdb;
create database triggerdb;

use triggerdb;

drop table if exists ordertbl;
create table ordertbl(
		orderno int AUTO_INCREMENT PRIMARY key,
        userid varchar(5),
        prodname varchar(5),
        orderamount int
);

drop table if exists prodtbl;
create table prodtbl(
	prodname varchar(5),
    account int,
    warehousing datetime DEFAULT CURRENT_TIMESTAMP 
);

drop table if exists delivertbl;
create table delivertbl(
		deliverno int AUTO_INCREMENT primary key,
        prodname varchar(5),
        account int UNIQUE
);

insert into prodtbl(prodname, account) values
('사과',100),('배',100),('귤',100);

select *
	from prodtbl;
    
#이제 중첩 트리거를 만들어 구매테이블과 물품테이블에 부착하자
#구매 테이블에 구매가 발생(삽입)이 되면 무품 테이블에서 재고를 감소시키는 트리거 생성
drop trigger if exists ordertrg;
delimiter //
create trigger ordertrg
	after insert
    on ordertbl
    for each row
begin 
	#현재 있는 재고 - 주문 개수를 하면 현 재고가 다시 업데이트 될 것이다.
    #이 update문이 시행되면, prdtrg트리거도 자동실행된다. 이것이 중첩트리거인 것이다.
    update prodtbl
		set account = account - new.orderamount
        where prodname = new.prodname;
end //
delimiter ;

drop trigger if exists prdtrg;
delimiter //
create trigger prdtrg
	after update
    on prodtbl
    for each row
begin
	declare orderamount int;
    #주문 개수를 연산하는데 기존의 재고가 100개(old.account)이고
	#만약 주문이 10개 들어와서 위의 ordertrg가 실행되면 update후의 값은 90이 된다.
    #update시에는 임시테이블이 2개 만들어진다고 하엿다.
    #하여ㅡ, 100-90을 하면 주문개수 즉, 배송할 개수가 되는 것이다.
    set orderamount = old.account - new.account;
    #배송 테이블에 물품명과 배송개수를 삽입한다.
    insert into delivertbl(prodname,account) values (new.prodname,orderamount);
 end//
 delimiter ;
 
 #oldertl에 데이터를 삽입을 하니 위의 중첩트리거가 자동실행된다.
 insert into ordertbl values(null,'신은혁','사과',10);
 
 #각각의 테이블을 다 확인해보면 역시 트리거에 설정한데로 ㅔ이터가 들어가 있는것을 알수가 있다.
 select * from ordertbl;
 select * from prodtbl;
 select * from delivertbl;
 
 #근데 이번엔 delivertbl의 컬럼 중 하나를 이름을 변경하여 보자.
 #그럼 당연히 트리거가 실행하면서 오류를 발생시킬 것이다.
 
 #delivertbl의 prodname컬럼을 productname으로 변경시켰다.
 alter table delivertbl
	change prodname productname varchar(5);
    
#삽입해보니 prdtrg트리거에서 에러가 난 것이다.
#필드명이 없다는 것이다. 그럼 앞에 실행한것은 제대로 되었을까?
#아니다. 이건 연결된 하나의 작업으로 보아야 하기 때문에
#저장 자체가 안되는 것이다.

insert into ordertbl values(null,'신은비','귤',35);

#확인을 해보면 역시 저장자체가 안되어 있는 것을 볼 수가있다.
select * from ordertbl;
select * from prodtbl;
select * from delivertbl;
    
    
    