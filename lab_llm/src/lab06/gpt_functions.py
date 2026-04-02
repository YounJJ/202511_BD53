from datetime import datetime

import pytz
import yfinance as yf


def get_current_time(timezone):
    """해당 timezone의 현재 시간을 '%Y-%m-%d %H:%M:%S' 형식의 문자열로 리턴."""
    tz = pytz.timezone(timezone)  # 타임존 문자열(예: Asia/Seoul)을 전달받아서 timezone 객체를 생성.
    now = datetime.now(tz).strftime('%Y-%m-%d %H:%M:%S')
    return now


def get_yf_info(ticker):
    """ticker 문자열을 아규먼트로 전달받아서, 그 기업의 정보를 문자열 형태로 리턴."""
    stock = yf.Ticker(ticker)  # Ticker 객체 생성
    return str(stock.info)  # dict 객체를 문자열로 변환해서 리턴.


def get_yf_history(ticker, period):
    """ticker 종목의 지난 period 동안의 주가 변화 정보를 마크다운(markdown) 문자열로 리턴."""
    stock = yf.Ticker(ticker)  # Ticker 객체 생성
    history = stock.history(period)  # 특정 기간 동안의 주가 변화 데이터프레임(DataFrame)
    return history.to_markdown()  # DataFrame을 markdown 형식의 문자열로 변환해서 리턴.
    # to_markdown() 메서드가 정상 동작하려면 tabulate 패키지가 설치되어 있어야 함(pip install tabulate).


def get_yf_recommendations(ticker):
    """애널리스트들의 ticker 종목에 대한 매수/매도/유지 의견을 마크다운 형식의 문자열로 리턴."""
    stock = yf.Ticker(ticker)  # Ticker 객체 생성
    return stock.recommendations.to_markdown()  # DataFrame을 markdown 문자열로 변환해서 리턴.


# 도구(함수) 정의 목록
tools = [
    {
        'type': 'function',
        'function': {
            'name': 'get_current_time',
            'description': '특정 타임존의 현재 날짜/시간을 "%Y-%m-%d %H:%M:%S" 형식의 문자열로 반환.',
            'parameters': {
                'type': 'object',
                'properties': {
                    'timezone': {
                        'type': 'string',
                        'description': '현재 날짜/시간 정보를 알고 싶은 타임존 문자열(예: "Asia/Seoul"). pytz.all_timezones에서 정의된 문자열들을 사용함.',
                    },
                },
                'required': ['timezone'],
            },
        },
    },
    {
        'type': 'function',
        'function': {
            'name': 'get_yf_info',
            'description': 'Yahoo Finance에서 기업 정보를 검색해서 리턴. ticker 문자열을 아규먼트로 전달받아서, 그 기업의 정보를 문자열로 리턴.',
            'parameters': {
                'type': 'object',
                'properties': {
                    'ticker': {
                        'type': 'string',
                        'description': 'Yahoo Finance 기업 정보를 반환하기 위해서 필요한 종목 ticker 문자열(예: "AAPL", "MSFT", "005930.KS")'
                    },
                },
                'required': ['ticker'],
            },
        },
    },
    {
        'type': 'function',
        'function': {
            'name': 'get_yf_history',
            'description': 'Yahoo Finance에서 ticker 종목 기업의 지난 period 기간 동안의 주가 정보(시가, 고가, 저가, 종가, 거래량, 배당금, 주식 분할)를 마크다운 문자열로 리턴.',
            'parameters': {
                'type': 'object',
                'properties': {
                    'ticker': {
                        'type': 'string',
                        'description': 'Yahoo Finance 주가 정보를 반환하기 위해서 필요한 종목 ticker 문자열(예: "AAPL", "MSFT", "005930.KS")'
                    },
                    'period': {
                        'type': 'string',
                        'description': 'Yahoo Finance 주가 정보를 조회할 기간(예: "1d", "5d", "1mo", "1y").'
                    },
                },
                'required': ['ticker', 'period'],
            },
        },
    },
    {
        'type': 'function',
        'function': {
            'name': 'get_yf_recommendations',
            'description': 'Yahoo Finance에서 ticker 종목에 대한 애널리스트들의 추천 정보(매수, 매도, 유지, ...)를 마크다운 형식의 문자열로 반환.',
            'parameters': {
                'type': 'object',
                'properties': {
                    'ticker': {
                        'type': 'string',
                        'description': 'Yahoo Finance 추천 정보를 반환하기 위해서 필요한 종목 ticker 문자열(예: "AAPL", "MSFT", "005930.KS")'
                    },
                },
                'required': ['ticker'],
            },
        },
    },
]

# 함수 이름을 key로 하고, 함수 객체를 value로 갖는 dict 선언.
funnction_list = {
    'get_current_time': get_current_time,
    'get_yf_info': get_yf_info,
    'get_yf_history': get_yf_history,
    'get_yf_recommendations': get_yf_recommendations,
}


def exec_function(fn_name, args):
    """fn_name 이름의 함수를 찾아서 args를 아규먼트로 전달하고 실행한 결과값을 리턴.
    fn_name은 문자열 타입. args는 dict 타입."""
    return funnction_list[fn_name](**args)


def main():
    # print(get_current_time('Asia/Seoul'))
    # print(get_yf_info('MSFT'))
    # print(get_yf_history(ticker='MSFT', period='3d'))
    # print(get_yf_recommendations('MSFT'))
    result = exec_function('get_current_time', {'timezone': 'Asia/Seoul'})
    print(result)

    result = exec_function('get_yf_history', {'ticker': 'AAPL', 'period': '5d'})
    print(result)

    


if __name__ == '__main__':
    main()