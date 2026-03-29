from google import genai

from src.utils import get_gemini_api_key

if __name__ == "__main__":
    # 환경 변수에 저장된 Gemini API 키를 읽어 옴
    api_key = get_gemini_api_key()
    
    # Gemini 클라이언트: Gemini로 질문(요청)을 보내고, 그에 대한 응답(답변)을 전달받는 객체.
    # Gemini 클라이언트: 객체 생성.
    client = genai.Client(api_key=api_key)

    # Gemini 클라이언트를 사용해서 요청을 보냄
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents="넌 누구니?",
        config=genai.types.GenerateContentConfig(
            system_instruction="너는 나를 도와주는 인공지능 비서야.",
            temperature=0.9,
        )
    )
    print(response)  #> GenerateContentResponse 객체
    print('-' * 30)
    print(response.candidates)  #> list
    print(len(response.candidates))  #> list의 아이템 개수 1개.
    print(response.candidates[0])  #> Candidate 객체
    print(response.candidates[0].content)  #> Content 객체
    print(response.candidates[0].content.parts)  #> list
    print(response.candidates[0].content.parts[0])  #> Part 객체
    print('-' * 30)
    print(response.candidates[0].content.parts[0].text)  #> gemini의 답변
    
    