
#보안상의 문제로 인하여 일부 데이터만 실제 테이블에서 필요한 열을 복사해서
#view를 만들어준다. 하여, view는 일종의 가상테이블이라고 생각하면 된다.
create view uv_memberTBL
as 
	select memberName,memberAddress
	from memberTBL;
    
#실제 테이블과 같은 조회결과를 지닌다.
select*
from uv_membertbl;

select memberName, memberAddress
from membertbl; #위험함 select대신 delete치면 x됨