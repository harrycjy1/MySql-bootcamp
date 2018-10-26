#memberTBL테이블에 하나의 데이터 삽입하는 코드
insert into memberTBL values ('Figure','연아','경기도 군포시');

#아래 코드는 membertbl에서 주소를 바꾸는데, 연아와 동일한 것만 바꾸라는 쿼리문
update membertbl
set memberAddress = '대구 달성군'
where memberName = '연아';

#membertbl테이블에서 '연아'인것만 삭제하라라는 쿼리문
delete from membertbl
where memberName = '연아';

select *
from membertbl;

#아래 쿼리문은 deletedMemberTBL테이블을 직접 코드로 만드는 것이다.
#아직은 몰라도 좋다. 뒷장에서 배운다.
create table deletedMemberTBL(
	memberID char(8),
    memberName char(5),
    memberAddress char(18),
    deletedDate date
    );
    
#아래 코드는 간단한게 trigger를 작성한것이다. 어차피 뒤에서 배우겠지만
#간단히 설명하면, trg_deletedMemberTBL트리거를 만들어라.
#어떻게? memberTBL에서 delete라는 명령어가 실행되면, 삭제된 행(데이터)에 대해
#deletemembertbl에 데이터를 삽입해라라는 내용이다.
#curdate()는 지금(now)의 시각과 날짜를 부르는 함수이다.
#old는 삭제된 이전 즉, 오래된(삭제된)이라는 뜻이다.alter

delimiter //

create trigger trg_deletedMemberTBL #트리거 이름
	after delete					#삭제 후 
    on memberTBL					#memberTBL에서
    for each row					#각 행에 적용함.
    
begin 
	#old는 삭제된 데이터를 의미함.
	insert into deletedmembertbl
	values (old.memberID, old.memberNAme, old.memberAddress, curdate()
	);
end //
    
delimiter ;

select *
from membertbl;

#아래의 delete명령어를 사용하면, 자동으로 위에서 만든 trigger이 실행된다.
delete from membertbl
where memberName = '당탕이';

#trigger가 실행되었다면, 당연히 deletemembertbl에 데이터가 삽입되었을 것이다.
select *
from deletedmembertbl;

#테이블 행 다지움
delete from deletedmembertbl; #delete의 경우 테이블의 행이 굉장히 많은 경우 속도가 굉장히 느리다. 한행 한행 일일이 참조하기 때문

truncate deletedmembertbl;    #truncate의 경우 테이블에 있는 자료 싸그리 한방에 다지운다.
    