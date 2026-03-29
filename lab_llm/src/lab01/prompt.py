from google import genai

from src.utils import get_gemini_api_key

def chat(contents, system_instruction, client):
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=contents,
        config=genai.types.GenerateContentConfig(
            temperature=0.9,
            system_instruction=system_instruction
        )
    )
    print(response.candidates[0].content.parts[0].text)


def main():
    client = genai.Client(api_key=get_gemini_api_key())

    # no prompting: messages에 assistant 프롬프트를 제공하지 않는 것.
    no_prompt_msg = "오리"
    system_instruction = "유치원생처럼 대답해줘."
    chat(no_prompt_msg, system_instruction, client)

    print('\n' + '*' * 30 + '\n')

    # one-shot prompting: user-assistant 프롬프트를 한개 작성하고 질문을 작성.
    # gemini가 사용자가 원하는 패턴에 맞춰서 답변을 생성하도록 예시를 한 번 제시해서 답변을 유도.
    system_instruction = "유치원생처럼 대답해줘."
    
    # Gemini에서는 리스트를 사용해 대화 기록(role과 parts)을 만들어 전달합니다.
    # 주의: OpenAI는 'assistant'를 쓰지만, Gemini는 'model'을 사용합니다!
    one_shot_contents = [
        {'role': 'user', 'parts': [{'text': '참새'}]},      # 예시 - 질문
        {'role': 'model', 'parts': [{'text': '짹짹'}]},     # 예시 - 답변 (one-shot)
        {'role': 'user', 'parts': [{'text': '오리'}]}       # 진짜 하고 싶은 질문
    ]
    
    print("=== One-Shot Prompting ===")
    chat(one_shot_contents, system_instruction, client)

    print('\n' + '*' * 30 + '\n')

    # few-shot prompting: 원하는 답변을 유도하기 위해서 user-assistant 프롬프트 예시를 여러개 전달하는 것.
    system_instruction = "유치원생처럼 대답해줘."

    few_shot_contents = [
        {'role': 'user', 'parts': [{'text': '참새'}]},
        {'role': 'model', 'parts': [{'text': '짹짹'}]},
        {'role': 'user', 'parts': [{'text': '개구리'}]},
        {'role': 'model', 'parts': [{'text': '개굴개굴'}]},
        {'role': 'user' , 'parts': [{'text': '소'}]},
        {'role': 'model', 'parts': [{'text': '음머'}]},
        {'role': 'user', 'parts': [{'text': '오리'}]}
    ]
    
    print("=== Few-Shot Prompting ===")
    chat(few_shot_contents, system_instruction, client)

        

if __name__ == "__main__":
    main()