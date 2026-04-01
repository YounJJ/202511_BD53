from src.utils import openai_client as client


def main():
    messages = [
        {'role': 'system', 'content': '너는 유능한 AI 비서야.'},
        {'role': 'user', 'content': '현재 시간은?'}
    ]


    # GPT API를 사용해서 질문을 주고, 답변을 받음.
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=messages
    )

    print(response)  #> ChatCompletion
    print('-' * 50)
    print(response.to_json())  #> ChatCompletion 객체를 JSON 형식의 문자열로 표현해서 출력.
    print('-' * 50)
    print(response.choices[0].message.content)  #> GPT는 현재 시간을 모름.



if __name__== '__main__':
    main()

