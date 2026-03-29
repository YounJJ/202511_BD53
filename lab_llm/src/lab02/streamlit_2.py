import streamlit as st
import pandas as pd
import numpy as np

# 웹 페이지에 텍스트 출력
st.write('''Streamlit supports a wide range of data visualizations,
including [Plotly, Altair, and Bokeh charts](https://docs.streamlit.io/develop/api-reference/charts).
📊 And with over 20 input widgets, you can easily make your data interactive!''')

# 문자열(이름) 3개를 가지고 있는 list
all_users = ["Alice", "Bob", "Charly"]

# container(박스) 생성
with st.container(border=True):
    # 컨테이너가 포함하는 요소를 생성
    users = st.multiselect("Users", all_users, default=all_users)  # 다중선택 입력창
    rolling_average = st.toggle("Rolling average")  # 토글(on/off)버튼

np.random.seed(42)

# 데이터프레임 생성 (20개 행, 다중선택창에서 선택된 사용자 숫자만큼의 컬럼)
data = pd.DataFrame(np.random.randn(20, len(users)), columns=users)

# 토글 버튼의 동작 설정.
if rolling_average:  # 토글버튼이 on 상태일 때
    data = data.rolling(7).mean().dropna()

# 2개의 탭을 생성
tab1, tab2 = st.tabs(["DataFrame", "Chart"])
# 첫번째 탭에 데이터프레임을 표시
tab1.dataframe(data, height=250, width='stretch')
# 두번째 탭에 선그래프를 표시
tab2.line_chart(data, height=250)