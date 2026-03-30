import time

from openai import OpenAI

from src.utils import get_openai_api_key


def get_gpt_response(client, messages):
    """streaming=True 를 사용한 요청과 응답 처리"""
    response = client.chat.completions.create(
        model="gpt-5.4-mini",
        temperature=0.9,
        messages=messages,
        stream=True
    )

    for chunk in response:
        yield chunk.choices[0].delta.content
        




def main():
    client = OpenAI(api_key=get_openai_api_key())
    messages = [
        {'role': 'system', 'content': '너는 유능한 AI 비서야.'}
    ]

    while True:
        user_input = input('User>> ')
        if user_input == '/exit':
            print('Goodbye~')
            break
        
        # 사용자가 입력한 질문을 messages 리스트에 dict로 append.
        messages.append(
            {'role': 'user', 'content': user_input}
        )
        # GPT 채팅 요청을 보내고 응답을 받음.
        response = get_gpt_response(client, messages)
        # 파편화된 답변들(chunk)을 하나로 합치기 위한 변수
        answer = ''
        print('GPT>> ', end='', flush=True)  # flush=True: print 함수가 호출될 때 바로 출력하고, 버퍼를 비움.
        for chunk in response:  # 파현화된 답변(chunk)들을 반복(iteration).
            if chunk:  # 조각난 답변이 있는 경우(None이 아닌 경우)
                answer += chunk  # 나중에 assistant 프롬프트의 컨텐트로 사용하기 위해서
                print(chunk, end='', flush=True)  # 조각난 답변들을 하나씩 출력
                time.sleep(0.05)  # 0.05초 쉼
        print()  # 줄바꿈
        
        # 이전 대화 내용을 저장해서, 이후의 질문들에서 문맥에 맞는 답변을 유도하기 위해서
        messages.append(
            {'role': 'assistant', 'content': answer}
        )


if __name__ == "__main__":
    main()