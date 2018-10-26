
use tabledb;
#아래 prodtbl테이블을 만들었다. 하지만 제약조건을 주진 않았다.
drop table if exists prodtbl;
create table prodtbl(
prodcode char(3) not null,
prodid char(4) not null,
proddate datetime not null,
prodcur char(10) null

#constraint PK_prodtbl_prodcode_prodid
#primary key(prodcode,prodid)
);

insert into prodtbl values
('AAA','0001','20191010','판매완료'),
('AAA','0002','20191011','매장진열'),
('BBB','0001','20191012','재고창고'),
('CCC','0001','20191013','판매완료'),
('CCC','0002','20191014','판매완료');

#그래서 아래와 같이 테이블을 수정(alter table table명)하는 구문을 넣어줄수가 있다.
#근데 여기서는 PK를 직접 이름을 주어서 만들었고, 아울러 2개의 필드를 합펴서 하나의 PK로 설정한 것이다.
#어느 필드가 PK가 될 수가 있겠는가?
#이런 경우 아래와 같이 합치는 것이다.

alter table prodtbl
add constraint PK_prodtbl_prodcode_prodid
primary key(prodcode,prodid);

#아래 2개의 쿼리는 비슷하다 테이블 구조를 보면 prodcode와 prodid가 PK로 설정되어 있는것을
#확인할 수 있다.

desc prodtbl;
show index from prodtbl;
show index from buytbl;
