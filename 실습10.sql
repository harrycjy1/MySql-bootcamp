#SystemDB인 mysqldb를 사용하겠다고 했다
use mysql;

show tables;

# 하지만 여기서 에러가 발생한다 왜? 그이유는 바로 mysql에는
# employees라는 테이블이 없는것이다. 그럼 어떻게 해야할까?
select *
from employees;

# 이렇게 직접 DB명.테이블명으로써 기재를 하여 select를 해야한다.
# 아니면 use emplyees;를 하고 조회를 하면 된다.
select *
from employees.employees;



select *
from titles;

# 아래와 같이 원하는 열만 가져올수도 있다. 원하는대로 나열을 해주면 된다.
# as는 알리아스(별병)로써, 열의 명을 임의대로 사용자가 바꿀수가 있다.
select first_name as '성', last_name as '이름', gender '성별'
from employees;

# 만약, DB명과 테이블명이 생각이 나지 않는다면,
# 먼저 DB를 조회해보고 DB를 선택한다.

show databases;
use employees;

# 그리고 DB를 선택했는데, 테이블명이 생각이 나지않으면
# 아래와 같이 진행된다.
# 두가지 방법이 있는데 테이블명만 볼꺼면 아래와 같이 한다.

# 두번째 방법은 좀더 자세하게 보고자 할때 사용하는 방법이다.
show table status;

# 위와 같이 진행해서 테이블을 알아냈다면, 그 테이블의 열, 데이터 타입, 널 여부,
# PK 등을 알고 싶을때는 아래와 같이 진행한다.
# 둘다 똑같은 실행결과를 나타낸다.
describe employees;
desc employees;

# 이제 필드까지 알았으면, 아래와 같이 조회를 해보면 된다
select first_name, gender
from employees
where gender = 'M';

