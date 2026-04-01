from datetime import datetime  # datetime 모듈(py)에서 datetime 클래스 이름을 가져옴.

from src.utils import openai_client as client


def get_current_time():
    # 현재 날짜와 시간을 2026-04-01 11:12:18 형식의 문자열로 만듦.
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # print(now)
    return now


def get_gpt_response(messages, tools=None):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',       # LLM 모델 선택
        messages=messages,          # LLM 모델에게 전송하는 메시지
        tools=tools                 # LLM 모델에게 제공하는 도구 목록
    )
    print(response.to_json())
    print('\n' + '-' * 50 + '\n')

    return response




def main():
    # LLM 모델에게 제공할 도구 정의(tool definitions) 리스트.
    tools = [
        {
            'type': 'function',
            'function': {
                'name': 'get_current_time',
                'description': '해당 타임존의 날짜와 시간을 %Y-%m-%d %H:%M:%S 형식의 문자열로 반환.'
           },
        }
    ]

    # LLM 모델에게 보낼 메시지
    messages = [
        {'role': 'system', 'content': '너는 유능한 AI 비서야.'},
        {'role': 'user', 'content': '현재 시간은?'}
    ]

    # LLM 모델에게 메시지와 함께 우리가 가지고 있는 도구 목록을 제공.
    response = get_gpt_response(messages, tools)
    ai_message = response.choices[0].message
    # tool_calls = ai_message.tool_calls
    # if tool_calls:
    #   pass
    if tool_calls := ai_message.tool_calls:  # LLM 모델이 응답으로 보낸 메시지 안에 도구 호출 요청이 있으면
        tool_call_id = tool_calls[0].id
        function_name = tool_calls[0].function.name
        if function_name == 'get_current_time':  # 도구 호출에서 사용할 함수 이름이 get_current_time 이면
            # 1. 이전의 모든 메시지를 포함시킴(assistant가 도구 호출을 요충한 메시지를 포함시킴).
            messages.append(ai_message)
            # 2. 도구 호출 결과(함수 호출 리턴값)를 포함하는 메시지를 추가.
            messages.append(
                {
                    'role': 'tool',
                    'tool_call_id': tool_call_id,
                    'name': function_name,
                    'content': get_current_time()
                }
            )
            # 3. 도구 호출(function calling) 결과를 포함하는 메시지를 다시 LLM 모델에게 전송
            response = get_gpt_response(messages, tool_calls)           

            # 최종 LLM 모델의 답변
            print('GPT>>>') 
            print(response.choices[0].message.content)


if __name__ == '__main__':
    main()