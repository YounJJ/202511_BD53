# import src.myutil1.addition  # addition 모듈을 임포트.
import src.myutil1.addition as addition  # import 문에 별명 추가.

# from ... import 구문
from src.myutil1.subtraction import minus
#> src.myutil1.subtraction 모듈(파일)에서 함수 minus를 임포트.

# myutil2 패키지를 임포트
import src.myutil2 as util

#__name__ 변수: 모든 파이썬 모듈(*.py 파일)이 가지고 있는 특별한 변수.
# (1) 현재 파일을 실행할 때는 `__main__` 문자열이 할당됨.
# (2) 다른 파일에서 import될 때는 파일 (경로) 이름이 할당됨.
# (목적) 단독으로 실행할 코드와 import될 때 실행할 코드를 구분하기 위해서.
print(__name__)


if __name__ == '__main__':
    print('hi')
    # result = src.myutil1.addition.plus(1, 2)
    result = addition.plus(3,4)
    print(result)

    result = minus(2, 4)
    print(result)

    result = util.multiply(3, 4)  # util.multiplication.multiply(3, 4)
    print(result)

    result = util.divide(4, 3)
    print(result)