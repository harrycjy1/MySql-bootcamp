#외래키 설정을 drop하자

use sqldb;

alter table buytbl
drop FOREIGN KEY buytbl_ibfk_1;

show create TABLE buytbl;

desc buytbl;
/* 자 조회를 하면 order by를 주지도 않았는데도 불구하고 삽입할때와 다르게 userid가 알파벳순으로
정렬이 되었다. 즉 클러스터 인덱스인 것이다. 영어사전의 단어 역할을 하는 것이다.
즉 다시말해 테이블에 Pk를 주면 그것이 클러스터형 인덱스가 되어서 정렬이 되어진다는 것이다.*/

select *
from usertbl;

drop table if exists tbl1;
create table tbl1(
a int primary key,
b int,
c int
);

/* tbl1에 인덱스를 살펴보는 명령이다 보면 non_unique로 거꾸로 되어있다. 0이라면 unipue라는 것이다.
또한 key_name이 primary로 되어 있다면 클러스터형 인덱스라고 생각하면 된다.
primary가 아니라면 보조인덱스라고 생각하면 된다. 아울러, 그 필드가 a라는 것을 나타낸다.*/

show index from tbl1;

drop table if exists tbl2;
create table tbl2(
a int primary key,	#무조건 중복 불가
b int unique,		#unique제약조건은 중복불가이지만 널은 허용, null의 중복도 허용된다고 앞서 강의에서 설명했다.
c int unique
);

# tbl2에서 보면 a는 primary key로 클러스터형 인덱스이고, b와 c는 unique제약조건으로 보조인덱스가 되는 것이다.
show index from tbl2;

drop table if exists tbl3;
create table tbl3(
a int UNIQUE,
b int UNIQUE,
c int UNIQUE
);

# 확인해보니 보조인덱스로만 구성되어진 테이블이다
#하여 클러스터형 인덱스가 필수 인것은 아니란 것을 알수가 있다.
show index from tbl3;

drop table if EXISTS tbl4;
create table tbl4(
a int UNIQUE not NULL, # unique 와 not null 조건을 걸었으므로 클러스터형 인덱스가 됨을 예상할 수 있다.
b int UNIQUE,
c int UNIQUE,
d int
);

/*확인해보면 a필드에 null값을 허용하지 아니한다라고 나온다.
그럼 클러스터형 인덱스가 되는것이다.
정리를 하자면 클러스터형 인덱스가 되는 2가지 경우는
1. Primary Key
2. Unique && Not null 
*/

show index from tbl4;

/*데이터 삽입후 조회 해보자
분명 3부터 삽입을 했음에도 불구하고 a 필드가 클러스터형 인덱스라 정렬이 되어진 것을 확인할 수 있다.*/

insert into tbl4 values
(3,3,3,3),(2,2,2,2);

select *
from tbl4;

/*만약에 테이블에 Pk와 UNIQUE NOT NULL이 같이 있다면 Pk가 클러스터형 인덱스가 되고 UNIQUE NotNUll은 secondary index가 되는 것이다.
*/

drop table if exists tbl5;
create table tbl5(
#Pk가 없다면 당연 클러스터형 인덱스가 되지만 여기서는 보조인덱스가 된다 (이유는 d가 PRIMARY KEY 이기 때문)
a int unique not null,
b int unique,
c int unique,
d int primary key
);

show index from tbl5;

/*하여 위의 usertbl은 클러스터형 인덱스인 userid를 기준으로 정렬이 되어 지는 것이다.
userid 의 name 컬럼을 primary key 로 수정하고 조회 해보자.
*/
alter table usertbl
drop PRIMARY KEY;

alter table usertbl
add CONSTRAINT pk_name PRIMARY KEY(name);

/*조회를 해보면 name의 가나다...순으로 자동정렬이 되는것을 볼수 있다.
근데 PK드랍하는 미친짓은 하지마라*/

select *
from usertbl;




