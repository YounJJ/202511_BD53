# pdf 파일에서 헤더/푸터를 제외한 텍스트를 추출하고, GPT API를 이용해서 요약하기 (강사님 버전)
from openai import OpenAI
import os
import pymupdf

from src.utils import get_openai_api_key


def pdf_to_txt(pdf_file, header_height=80, footer_height=80):
    """pdf 파일을 읽어서, 헤더/푸터를 제외한 영역에서 텍스트만 추출, 추출된 텍스트를 txt 파일에 저장.
    저장한 파일의 경로를 리턴."""
    # PyMuPDF 모듈을 사용해서 pdf 파일을 오픈.
    with pymupdf.open(pdf_file) as document:
        full_text = ''
        for page in document:
            rect = page.rect  # (왼쪽 상단 x좌표, 왼쪽 상단 y좌표, 가로길이, 세로길이)
            # clip = (왼쪽 상단 x좌표, 왼쪽 상단의 y좌표, 오른쪽 하단 x좌표, 오른쪽 하단의 y좌표) -> 잘라낼 영역.
            clip = (0, header_height, rect.width, rect.height - footer_height)
            full_text += page.get_text(clip=clip)  # 헤더/푸터 제외한 영역에서 텍스트 추출.
            full_text += '\n' + '-' * 50 + '\n'

    # full text에 저장된 문자열을 txt 파일에 저장.
    base_name = os.path.basename(pdf_file)  # 폴더(디렉토리) 경로를 제외한 파일 이름(예: sample.pdf)만 리턴.
    file_name = os.path.splitext(base_name)[0]  # ['sample', 'pdf'] 리스트에서 첫번째 아이템.
    txt_file = f'./src/lab03/output/{file_name}.txt'  # 추출한 텍스트를 저장할 파일 경로
    print('txt 파일 이름:', txt_file)
    with open(txt_file, mode='w', encoding='utf-8') as f:
        f.write(full_text)

    return txt_file
    

def summarize_txt(txt_file):
    """txt 파일을 읽고, GPT API를 이용해서 텍스트 요약을 수행. GPT의 답변을 리턴."""
    # txt 파일 오픈하고 전체 내용을 읽음.
    with open(txt_file, encoding='utf-8') as f:
        txt = f.read()


    # GPT를 사용하기 위한 프롬프트 작성
    prompt = f'''
    너는 문서를 요약하는 비서야.
    아래의 텍스트를 읽고, 저자의 목적과 주장을 파악해서 요약해줘.
    요약하는 형식은 다음과 같아.
    # 제목
    # 논문의 목적(5문장 이내)
    # 논문 요약(10문장 이내)
    # 저자 소개
    # 참고 문헌

    === 아래 텍스트 ===
    
    {txt}
    '''

    client = OpenAI(api_key=get_openai_api_key())
    response = client.chat.completions.create(
        model="gpt-5.4-mini",
        temperature=0.5,
        messages=[
            {"role": "system", "content": prompt},
        ],
    )

    return response.choices[0].message.content  # AI 답변의 컨텐트만 리턴.
    


def main():
    txt_file = pdf_to_txt('./src/lab03/data/sample.pdf') 
    answer = summarize_txt(txt_file)
    print(answer)

if __name__ == "__main__":
    main()