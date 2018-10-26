#테이블을 압축하여 사용할 수 있는가를 확인하는 시스템 변수들이다.
#innodb_file_format의 값이 'Barracuda'이고 innodb_large-prefix가 'ON'이 되어잇으면
#압축하여 사용 가능하다.

show variables like 'innodb_file_format';
show variables like 'innodb_large_prefix';

drop database if exists compressdb;
create database compressdb;

use compressdb;

drop table if exists normaltbl;
create table normaltbl(
emp_no int, 
first_name varchar(14)
);

#테이블 생성하는데 row_format = compressed를 설정하여, 이 테이블은 앞으로 물리적으로
#데이터를 압축하여 쓰겠다는 의미이다.

drop table if exists compresstbl;
create table compresstbl(
emp_no int,
first_name varchar(14)
)
row_format = compressed; # 압축하겠다

select *
from employees.employees;

/*employees.employees 테이블에는 30만건 이상의 데이터가 들어있다.
 삽입에 걸리는 시간을 비교해보자
 PC마다 차이는 있겠지만 normaltbl보다 compresstbl이 시간이 더걸린다.
 이유는 데이터를 넣을때마다 압축하고 있기 때문이다.
 */
 
 insert into normaltbl(select emp_no, first_name from employees.employees);
 
 insert into compresstbl select emp_no, first_name from employees.employees;
 
 /* compressdb에 있는 테이블의 상태를 살펴보는 코드이다. 확인해보면 확실히
 compresstbl이 normaltbl보다 압축이 되어서 data_length가 45%정도 물리적 공간을
 절약하고 있는것을 볼 수 있다.
 성능은 좀 떨어지지만 서버의 공간을 절약하고 싶을때 쓸수 있다. (돈ㅇ벗는 회사면 쓸 수 있다)
 */
 
 show table status from compressdb;