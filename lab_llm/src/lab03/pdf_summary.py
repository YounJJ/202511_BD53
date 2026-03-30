# pdf 파일에서 헤더/푸터를 제외한 텍스트를 추출하고, GPT API를 이용해서 요약하기

import pymupdf
import os
import openai

from src.lab03 import pdf_header_footer_main
from src.utils import get_openai_api_key

def create_client():
    client = openai.OpenAI(api_key=get_openai_api_key())
    return client


def read_txt_file(txt_file):
    with open(txt_file, mode='r', encoding='utf-8') as f:
        txt_file = f.read()
    return txt_file


def main():
    client = create_client()
    txt_file = read_txt_file(pdf_header_footer_main())

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "너는 논문을 읽고 요약해주는 AI비서야."},
            {"role": "user", "content": f"이 논문을 요약해줘.\n\n{txt_file}"},
        ],
    )
    print(response.choices[0].message.content)


if __name__ == "__main__":
    main()
