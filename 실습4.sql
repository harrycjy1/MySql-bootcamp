#아래와 같은 쿼리문을 자주쓴다라고 가정한다면, 이것을 함수로 만들어서 호출만 하면 될 것이다.
#그것이 바로 StoredProcedure인 것이다.
#현업에는 상당히 StoredProcedure가 많다.

select *
from memberTBL
where memberName = '당탕이';

select *
from productTBL
where productName = '냉장고';


#아래는 위의 쿼리문을 자주쓰니 스토어드 프로시져로 만들었다 
#물론 지금은 어렵다, 살펴보면 delimiter // 는 원래 문장이 ; 로 끝이 나야하는것을
#잠시 실행동안 //로 바꾼다는 것이다.
#그리고 begin과 end사이의 내용을 실행하고 다시 
#delimiter ; 로 하여 문장의 끝을 ; 로 돌린다는 것이다
#지금은 몰라도 좋으니 대충 봐라


delimiter // #저장 프로시저가 완성되지 않은 상태에서 CREATE PROCEDURE 명령이 실행되는걸 막기위해 delimiter사용


create procedure myProc()
begin 
	select *
    from memberTBL
    where memberName = '당탕이'; 
    
    select *
    from productTBL
    where productName = '냉장고';
end //

delimiter ;

#위에 만든 내용을 호출해보겠다.
call myProc();

