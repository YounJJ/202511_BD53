def main():
    from google import genai

    from src.utils import get_gemini_api_key
    
    # 신문 기사가 저장된 텍스트 파일의 경로
    # 절대 경로(absolute path)
    # article_file = '/Users/wowjd/Desktop/Private/授業/202511_BD53/202511_BD53/lab_llm/lab03/data/article.txt'
    # 상대 경로(relative path): 현재 작업 디렉토리를 기준으로 파일을 찾아가는 방법
    article_file = 'lab03/data/article.txt'

    with open(article_file, encoding='utf-8') as f:
        txt = f.read()  # 파일 전체를 읽음.
        # print(txt)


    prompt = f'''
    너는 문서를 요약하는 비서야.
    아래의 글을 읽고 저자의 주장과 내용을 요약해줘.
    작성해야 하는 포맷은 다음과 같아.
    # 제목
    ## 부제목
    ## 저자의 주장(10문장 이내)
    ## 저자 소개
    ## 참고 문헌

    ==== 이하 텍스트 ====

    {txt}
    '''
    
    system_instruction = prompt 

    client = genai.Client(api_key=get_gemini_api_key())
    response = client.models.generate_content(
        model="gemini-3.1-flash-lite-preview",
        contents=prompt,
        config=genai.types.GenerateContentConfig(
            temperature=0.9,
            system_instruction=system_instruction
        )
    )

    print(response.candidates[0].content.parts[0].text)
    
    


if __name__ == '__main__':
    main()