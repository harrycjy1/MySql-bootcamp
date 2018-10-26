#먼저 밑에 백업폴더를 하나 만든다

#db를 선택하는 코드문(더블클릭의 효과와 동일)
use shopdb;

select *
from producttbl;

#producttbl을 백업을 하기 위해 좌측 management의 dataexport를 선택하자
#또한 dumpr...관련된것을 다 체크하고 export to self-contained file을 체크하고
#create dump a single transaction체크, include create schema도 체크하고,
#start export를 클릭하고 만든 DB백업 폴더를 확인해보자.
#하나의 shopdb.sql이 생성이 되었을 것이다.

#이제 producttbl테이블에 있는 데이터를 다 삭제해보자(현업에서 실수로 그랬다고 가정)
delete from producttbl;

#이제 날린 데이터를 복원하는 작업을 아래와 같이 진행해보자
#먼저, shopdb가 아닌 다른 db를 선택하고 management를 선택하자.
#그리고 data import/restore를 선택하자
#import from self-contained file을 체크하고 좀전에 백업햇던 sql문을 선택하고
#import target schema를 shopdb를 선택하고 import start를 실행하자.

#다시 조회를 해보면 잘 복원된 걸 확인할 수 있다.
select *
from producttbl;
