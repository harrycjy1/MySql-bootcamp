
# json 데이터 (javascript object notation)
# json은 최근들어 언어에 종속되지 않고 교환을 할수 있는 포맷형태이다.
use sqldb;

# usertbl에서 height가 180초과된 데이터를 키와 값형태로 json으로 변환하는 쿼리이다.
# 여기서 키는 이름이고 값은 name컬럼의 데이터가 되는것이다.

select json_object('name',name,'height',height) as 'JSON값'
from usertbl
where height > 180;


# json이라는 변수에 문자열을 대입하고 있다. 단 json형태로 말이다.

set @json = '{"usertbl" : [

{"name":"임재범", "height":182},
{"name":"이승기", "height":182},
{"name":"성시경", "height":186}

]}';

# json변수에 대입된 문자열이 json 형태인지 확인함(맞으면 1을 리턴 틀리면 0을 리턴)
select json_valid(@json);

# json 데이터에서 성시경이 몇번째 인덱스에 있느냐? 배열개념으로 되어있기 때문에
# 인덱스는 0부터 시작하여, 2를 리턴한다. 그리고 인자값중 'one'이 있는데 이것은 
# 'all'로 바꿔도 상관없다 . 문법이다. 눈에 익히도록 하자
select json_search(@json,'one','성시경');

# usertbl의 2번째 인덱스의 값을 가져와라
select json_extract(@json,'$.usertbl[2].name');

#0번째 인덱스에 mdate를 삽입해라
select json_insert(@json, '$.usertbl[0].mdate','2009-10-25');

select json_extract(@json, '$.usertbl[0].mdate'); -- 위의 쿼리는 실제로 2009-10-25값을 입력하지는 못하는거같음

#0번째 인덱스의 이름을 홍길동으로 바꿔라.
select json_replace(@json, '$.usertbl[0].name','홍길동');

#0번째 인덱스를 지워라.
select json_remove(@json,'$.usertbl[0]');



