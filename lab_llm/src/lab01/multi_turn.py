from google import genai

from src.utils import get_gemini_api_key

def get_gemini_response(client, contents, system_instruction):
    response = client.models.generate_content(
        model="gemini-3.1-flash-lite-preview",
        contents=contents,
        config=genai.types.GenerateContentConfig(
            temperature=0.9,
            system_instruction=system_instruction
        )
    )

    return response.candidates[0].content.parts[0].text

def main():
    # Gemini 객체 생성
    client = genai.Client(api_key=get_gemini_api_key())
    
    # 초기 메시지 프롬프트
    system_instruction = "너는 유능한 AI 비서야."

    # Contents 리스트 생성
    contents = []

    while True:
        # 콘솔에서 사용자 입력을 받음
        user_input = input("user>> ")
        if user_input == "exit":
            print('프로그램을 종료합니다...')
            break

        # 사용자가 입력한 내용을 리스트 contents에 'user' 프롬프트로 추가.
        contents.append({'role': 'user', 'parts': [{'text': user_input}]})

        # Gemini 서버로 요청을 보내고 응답을 받음.
        gemini_response = get_gemini_response(client, contents, system_instruction)
        
        # Gemini의 응답을 출력.
        print('Gemini>>', gemini_response)

        # Gemini의 응답을 리스트 contents에 'model' 프롬프트로 추가.
        contents.append({'role': 'model', 'parts': [{'text': gemini_response}]})


if __name__ == '__main__':
    main()