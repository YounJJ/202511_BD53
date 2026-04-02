# Decomposition(분해)

scores = [90, 100, 80]
print(scores)
print(scores[0], scores[1], scores[2])
# korean = scores[0]
# math = scores[1]
# english = scores[2]
korean, math, english = scores  # list decomposition
print(korean, math, english)

score_dict = {
    'science': 90,
    'history': 50,
}
print(score_dict)
print(score_dict['science'], score_dict['history'])
# science = score_dict['science']
# history = score_dict['history']
a, b = score_dict  # dictionary decomposition - dict의 키들이 각각의 변수에 저장.
print(a, b)

# unpacking: dict의 key-value를 함수의 parameter=argument로 분해하는 것.

def hi(name):
    print(f'Hi {name}!')

hi(name='오쌤')
ssam = {'name': '오쌤'}  # dict
hi(**ssam)  # unpacking: {'name': '오쌤'}가 name='오쌤' 변환.
# unpacking으로 사용할 dict를 만들 때, 키는 함수의 파라미터 이름과 같게!
# dict의 아이템 순서는 중요하지 않음.

def introduce(name, age):
    print(f'저는 {name}입니다. 나이는 {age}살입니다.')

introduce('홍길동', 16)  # positional arguments
introduce(age=16, name='홍길동')  # keyword arguments

ssam = {'name': '오쌤', 'age': 20}
# introduce(ssam['name'], ssam['age'])
introduce(**ssam)  # unpacking: name='오쌤', age=20

test = {'age': 11, 'name': '테스트'}
introduce(**test)  # unpacking: age=11, name='테스트'
# introduce(age=11, name='테스트') 문장과 동일.

# Unpacking: 함수의 아규먼트로 객체를 전달할 때 사용
# *list_name, *tuple_name: 가변길이 인수(variable-length arguments)로 전달
# **dict_name: 가변길이 키워드 인수(variable-length keyword arguments)로 전달.
print('a', 'ab', 'abc')
print(*['홍길동', '허균'])  # print('홍길동', '허균') 문장과 동일


def test1(*args):
    pass

def test(**kwargs):
    pass