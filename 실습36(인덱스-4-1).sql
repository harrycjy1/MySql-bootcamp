
#인덱스의 성능을 비교하기 위해 indexdb를 만들고 대용량 데이터를 복사해와서 테스트를 해보자

create database if not exists indexdb;

use indexdb;

# 약 30만건이 들어있다. 
select count(*)
from employees.employees;

#먼저 데이터를 복사해서 테이블을 생성해보자
#1. 인덱스가 없는 테이블
drop table if exists emp;

create table emp
select *
from employees.employees
order by rand(); #rand는 순서를 으미의로 가져오라는 것.

# 클러스터형 인덱스가 있는 테이블
drop table if exists emp_c;
create table emp_c
select *
from employees.employees
order by rand();

#3. 보조인덱스가 있는 테이블
drop table if exists emp_se;
create table emp_se
select *
from employees.employees
order by rand();

#테이블별로 데이터가 잘 섞였는지 확인해보자
#해당 PC마다 다를수 있다 상관안해도 된다

select *
from emp
limit 5;

select *
from emp_c
limit 5;

select *
from emp_se
limit 5;


#테이블의 상태를 확인해보자 똑같이 3개의 테이블이 준비되어 있는 것을 볼 수 있다.
show table status;

#emp_c테이블에 PK 즉 클러스터형 인덱스를 추가했다.
alter table emp_c
	add CONSTRAINT primary key(emp_no);
    
#emp_se테이블에 보조 인덱스를 추가했다.
alter table emp_se
	add index idx_emp_no(emp_no);
    
/*다시 아래의 내용을 실행해보면 뭔가 다르다는 것을 알 수 있을것이다
emp는 인덱스가 없으므로 그대로 나올것이다.
emp_c는 클러스터형 인덱스가 추가되었기 때문에 emp_no로 오름차순 정렬이 될것이다.
(인덱스 페이지와 리프페이지를 만들기 때문에 시간이 좀 걸릴것이다.)
emp_se는 보조형 인덱스이므로 역시 인덱스 페이지를 만드는데 데이터의 주소값을 
지니고 있는 부분만 정렬이 될것이고 실제 데이터는 변경이 없을 것이다.
*/

select *
from emp
limit 5;

select *
from emp_c
limit 5;

select *
from emp_se
limit 5;

analyze table emp, emp_c, emp_se;

show index from emp;		#인덱스가 없다
show index from emp_c;		#PK 클러스터형인덱스가 있다.
show index from emp_se;		#보조 인덱스가 있다.

/* 클러스터형 인덱스는 데이터 그자체가 인덱스를 내포하고있다.
index_length는 보조 인덱스를 나타내는 것이다. 하여 emp_se는 잡혀져있는것을 확인 할 수가 있다
data free가 인덱스가 있는 것들은 줄어든것을 확인할수가 있다. 인덱스 역시 저장공간을 차지함
*/
show table status;

#자 이제 성능 테스트를 하기 위해 mysql의 서비스를 잠시 종료했다가 다시 스타트하도록하자
#물론 워크벤치도 닫도록 하자





