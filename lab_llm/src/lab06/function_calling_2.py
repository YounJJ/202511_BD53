from datetime import datetime
import pytz  # 타임존 관련 모듈
import json

from src.utils import openai_client as client

# print(pytz.common_timezones)  # 흔히 사용되는 타임존 문자열(예: Asia/Seoul) 목록 출력
# print(pytz.all_timezones)  # 모든 타임존 문자열 출력

def get_current_time(timezone):
    tz = pytz.timezone(timezone)  # 타임존 문자열(예: Asia/Seoul)을 전달받아서 timezone 객체를 생성
    now = datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
    return now



def get_gpt_response(messages, tools=None):
    response = client.chat.completions.create(
        model="gpt-5.4-mini",
        messages=messages,
        tools=tools
    )
    print(response.to_json())
    print('\n' + '-' * 50 + '\n')

    return response


def main():
    # print('서울:', get_current_time("Asia/Seoul"))
    # print('런던:', get_current_time("Europe/London"))
    # print('미국 동부:', get_current_time("US/Eastern"))

    # 초기 시스템 프롬프트만 설정
    messages = [
        {"role": "system", "content": "너는 유능한 AI 비서야."}
    ]

    # 도구 정의 목록
    tools = [
        {
            "type": "function",
            "function": {
                # 함수 이름
                "name": "get_current_time",
                # 함수 설명 - 기능, 아규먼트, 리턴.
                "description": "해당 타임존의 날짜/시간 정보를 %Y-%m-%d %H:%M:%S 형식의 문자열로 반환.",
                # 함수 파라미터 정의
                "parameters": {
                    "type": "object",  # JSON 객체
                    "properties": {
                        # 함수의 파라미터 이름을 키로 사용.
                        "timezone": {
                            "type": "string",  # 파라미터 타입(아규먼트의 데이터 타입)
                            "description": "현재 날짜/시간 정보를 알고 싶은 타임존 문자열(예: Asia/Seoul). pytz.all_timezones에서 정의된 문자열들을 사용함."
                        }
                    },
                    # 필수 파라미터(required argument, 반드시 전달해야만 하는 아규먼트) 리스트.
                    "required": ["timezone"]
                }
            }
        }
    ]

    while True:  # 무한 반복문
        if user_prompt := input('User>> '):  # 사용자가 질문을 입력했을 때
            if user_prompt.strip() == '':  # 사용자가 입력한 내용(문자열)이 없을 때
                continue  # 반복문의 시작부분으로 감.
            if user_prompt.strip() == '/exit':
                print('Goodbye~')
                break  # 반복문을 종료

            # 사용자가 입력한 내용을 메시지에 추가
            messages.append({"role": "user", "content": user_prompt})
            # 도구 목록과 함께 메시지를 LLM 모델에게 전송
            response = get_gpt_response(messages, tools)

            # LLM 모델이 응답한 메시지에 tool_calls(도구 호출)가 포함된 경우, 처리할 코드.
            ai_message = response.choices[0].message
            if tool_calls := ai_message.tool_calls:  # content가 없고, function calling을 요청한 경우
                # 이전 모든 대화 내용을 저장해야 하기 때문에
                messages.append(ai_message)
                # LLM 모델이 텍스트를 생성하기 위해서 도구 호출이 여러개 필요하다고 판단하면
                # tool_calls 리스트에 함수 호출 순서대로 객체들을 전달함.
                for tc in tool_calls:  # tool_calls 리스트에 포함된 모든 function calling에 대해서 반복.
                    tool_call_id = tc.id
                    function_name = tc.function.name
                    arguments = json.loads(tc.function.arguments)  # JSON 문자열을 객체로 만듦.
                    if function_name == 'get_current_time':
                        # 함수 호출 결과를 메시지 리스트에 추가
                        messages.append(
                            {
                            "role": "tool",
                            "tool_call_id": tool_call_id,
                            "content": get_current_time(arguments['timezone'])
                            }
                        )
                
                # 도구 호출의 결과들을 메시지로 다시 LLM 모델에게 전송함.
                response = get_gpt_response(messages, tools)
                ai_message = response.choices[0].message

            # GPT의 답변 컨텐트만 출력
            print('GPT>>', response.choices[0].message.content)
            # multi-turn 대화를 하기 위해서(이전의 user-assistant 대화 내용을 저장하기 위해서)
            messages.append({"role": "assistant", "content": ai_message.content})


if __name__ == "__main__":
    main()