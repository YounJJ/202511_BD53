from google import genai

from src.utils import get_gemini_api_key

def main():
    # Gemini client 생성
    client = genai.Client(api_key=get_gemini_api_key())

    # Gemini 클라이언트를 사용해서 요청을 보내고 답변을 받음
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents="거울아, 거울아, 세상에서 누가 가장 예쁘니?",
        config=genai.types.GenerateContentConfig(
            # system_instruction="너는 백설공주 이야기의 마법 거울이야. 마법 거울 캐릭터에 맞게 답변해줘.",
            system_instruction="너는 배트맨 영화의 조커야. 조커처럼 대답해줘.",
            temperature=0.9,
        )
    )
    print(response.candidates[0].content.parts[0].text)

if __name__ == "__main__":
    main()