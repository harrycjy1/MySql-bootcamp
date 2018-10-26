# while, iterate(continue문과 동일), leave(break문과 동일)

# 1~100까지의 합을 구해보자

drop procedure if exists whileproc;

delimiter //
create procedure whileproc()
begin
	declare i int;
    declare hap int;
    
    set i =1;
    set hap =0;
    
    while(i<=100) do
    -- set hap += i; mysql에서는 복합대입연산자가 적용이 안된다.
    set hap = hap +i;
    -- set i++; mysql에서는 증감연산자도 안먹힌다.
    set i = i+1;
    end while;
    
    select hap;
end //
delimiter ;

call whileproc();


-- 이제는 합계를 구하는데 7을 제외하고 1000을 넘으면 그만 루프를 나가는 procedure를 만들어 보자

drop procedure if exists whileproc2;

delimiter //
create procedure whileproc2()
begin
	declare i int;
    declare hap int;
    
    set i =0;
    set hap =0;
    
    #while문을 mywhile이란 라벨로 설정했다 (저급언어에서 많이 사용)
    mywhile: while(i<=100) do
		if ((i%7)=0) then -- 7로 나눠서 나머지가 0이면 7의 배수란 소리다
			set i = i+1;
            iterate mywhile;
		end if;
        
        set hap = hap +i;
        -- leave는 다른언어에서 break문과 동일하다. 지정한 mywhile라벨을 떠나라.
        -- 즉 루프를 그만하라라는 것이다.
        if( hap > 1000) then
			leave mywhile;
		end if;
        set i = i+1;
	end while;
    select hap as '7제외 100이하 합계';
end //
delimiter ;


call whileproc2();
        
        
        
        
    
    


