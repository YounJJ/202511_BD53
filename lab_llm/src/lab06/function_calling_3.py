import json

from src.lab06.gpt_functions import *  # gpt_functions 모듈(파일)의 모든(변수, 함수) 이름들을 가져옴.
from src.utils import openai_client as client


def get_gpt_response(messages, tools=None):
    response = client.chat.completions.create(
        model="gpt-5.4-mini",
        messages=messages,
        tools=tools
    )
    return response



def main():
    messages = [
        {"role": "system", 
        "content": "너는 주식 애널리스트야. 주식 관련 정보들이 주어지면, 그 정보를 바탕으로 사용자에게 주식 관련 정보 및 인사이트를 제공해줘."}
    ]

    while True:
        if user_prompt := input('User>> ').strip():
            if user_prompt == '':  # 사용자가 입력한 문자열이 없으면
                continue
            if user_prompt == '/exit':  # 사용자가 '/exit'을 입력하면
                print('Goodbye~')
                break
            
            # 사용자가 입력한 내용을 messages 리스트에 추가
            messages.append({'role': 'user', 'content': user_prompt})
            # GPT 서버로 요청을 보냄.
            response = get_gpt_response(messages, tools)
            ai_message = response.choices[0].message

            # 기존 대화 이력을 저장하기 위해서
            messages.append(ai_message)

            # 도구 호출 요청이 있을 때의 처리
            if tool_calls := ai_message.tool_calls:
                for tc in tool_calls:  # tool_calls 리스트 안에 있는 도구 호출 목록을 순서대로 반복
                    tool_call_id = tc.id  # 호출할 함수의 아이디
                    function_name = tc.function.name  # 호출할 함수 이름
                    arguments = json.loads(tc.function.arguments)  # 함수를 호출할 때 전달할 아규먼트. (문자열 --> dict로 변환)
                    result = exec_function(function_name, arguments)  # 함수를 호출하고 리턴값을 저장.
                    # 함수 호출 결과를 메시지에 추가
                    messages.append(
                        {
                            "role": "tool",  # 함수 호출 결과 메시지의 역할
                            "tool_call_id": tool_call_id,  # 도구 호출 아이디 - 어떤 함수 호출 결과인 지를 판단하기 위해서
                            "content": result  # 함수 호출 후 리턴값
                        }
                    )

                # 함수 호출 결과들을 다시 GPT 서버로 보냄.
                response = get_gpt_response(messages, tools)
                ai_message = response.choices[0].message
                messages.append(ai_message)  # GPT의 답변을 messages 리스트에 추가!
            
            print('GPT>>', ai_message.content)


if __name__ == '__main__':
    main()