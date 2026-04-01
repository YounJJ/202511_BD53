from click import argument
import json

# json 모듈: 직렬화(serialization), 역직렬화(de-serialization) 기능 모듈
# JSON(JavaScript Object Notation): 자바스크립트 언어의 객체 표현 방법.
# - 속성(property, field)의 이름과 속성의 값으로 객체를 표현하는 방법.
# - 파이썬의 dict와 유사한 개념.
# 직렬화(serialization): 객체 --> JSON 형식의 문자열로 변환.
# 역직렬화(de-serialization): JSON 형식의 문자열 --> 객체(dict) 변환.
# json.dumps(object): 객체(object)를 JSON 형식의 문자열로 리턴. (예) dict --> str
# json.loads(str): JSON 형식의 문자열을 객체로 만들어서 리턴. (예) str --> dict

# 직렬화: 객체 --> 문자열
student = {
    'id': 1,
    'name': '오쌤',
    'department': 'Physics',
}
student_str = json.dumps(student)  # 직렬화: dict --> str
print(student_str)

# 역직렬화: 문자열 --> 객체
arguments = "{\"timezone\": \"Asia/Seoul\"}"
# '{\'timezone\': \'Asia/Seoul\'}'
# '{"timezone": "Asia/Seoul"}'
# "{'timezone': 'Asia/Seoul'}"
print(arguments)
arg_object = json.loads(arguments)
print(type(arg_object))
print(arg_object['timezone'])

