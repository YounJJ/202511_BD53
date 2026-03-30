import pymupdf

def main():
    pdf_file = './src/lab03/data/sample.pdf'  # 원본 pdf 파일 경로
    txt_file = './src/lab03/output/sample_2.txt'  # pdf에서 헤더와 푸터를 제외한 텍스트를 저장할 파일 경로
    header_height = 80  # pdf 파일 헤더의 높이(세로 길이)
    footer_height = 80  # pdf 파일 푸터의 높이(세로 길이)
    full_text = ''  # pdf 파일에서 추출한 텍스트를 저장하기 위한 문자열 변수

    with pymupdf.open(pdf_file) as document:
        for page in document:
            rect = page.rect  # Rect(왼쪽 상단 x 좌표, 왼쪽 상단 y 좌표, 직사각형의 가로길이, 직사각형의 세로길이)
            # print(rect)
            # print(rect.width, rect.height)
            # clip: pdf 파일에서 잘라낼 영역(헤더와 푸터를 제외하고 텍스트를 추출할 영역)
            # clip = (좌상단의 x 좌표, 좌상단 y 좌표, 우하단 x 좌표, 우하단 y 좌표)
            clip = (0, header_height, rect.width, rect.height - footer_height)
            # 잘려진 영역(clip) 안에서만 텍스트 추출
            text = page.get_text(clip=clip)
            full_text += text  # clip 안에서 추출한 텍스트를 full_text에 append
            full_text += '\n' + '-' * 50 + '\n'  # 페이지를 구분하기 위한 용도
            
    # clips 안에서 추출한 모든 텍스트를 txt 파일에 씀.
    with open(txt_file, mode='w', encoding='utf-8') as f:
        f.write(full_text)
    
    return txt_file

if __name__ == "__main__":
    main()

