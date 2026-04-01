import streamlit as st

from src.utils import openai_client


def get_gpt_response(messages):
    # 스트리밍 방식으로 응답 받기
    response = openai_client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=messages,
        temperature=0.9,
        stream=True
    )

    # yield를 사용해서 generator 패턴으로 만듦.
    for chunk in response:
        yield chunk.choices[0].delta.content  # 조각난 답변들을 내보냄.


def main():
    st.title('스트리밍 출력 챗봇')

    # st.session_state에 'messages' 키가 없는 경우, 초기 메시지 프롬프트를 새로 생성해서 저장.
    if 'messages' not in st.session_state:
        st.session_state.messages = [
            { 'role': 'assistant', 'content': '무엇을 도와드릴까요?' }
        ]

    # st.session_state에 저장된 대화 목록을 화면에 아이콘과 함께 출력
    for msg in st.session_state.messages:
        st.chat_message(msg['role']).markdown(msg['content'])
        # with st.chat_message(msg['role']):
        #     st.markdown(msg['content'])

    # 사용자 입력창을 출력, 입력됐을 때 할 일을 작성
    if user_prompt := st.chat_input('질문을 입력하세요...'):
        # 사용자가 입력을 끝내고 엔터까지 입력했을 때 할 일.
        # 사용자가 입력한 내용을 채팅 메시지로 출력
        st.chat_message('user').markdown(user_prompt)

        # 화면을 갱신할 때 이전 대화 목록을 모두 출력하기 위해서
        # st.session_state에 사용자 프롬프트를 추가!
        st.session_state.messages.append(
            { 'role': 'user', 'content': user_prompt }
        )

        # GPT API를 사용해서 질문을 보내고 답변을 받아서 출력
        # 세션 스테이트에 저장된 messages 리스트를 아규먼트로 전달해야 함.
        response = get_gpt_response(st.session_state.messages)
        answer = ''  # 조각난 답변들을 하나의 문자열로 합치기 위한 변수
        with st.chat_message('assistant').empty():  # 아이콘만 있고, 답변은 없는 빈 채팅 메시지를 생성
            for chunk in response:  # 조각난 답변들을 순서대로 반복하면서
                if chunk:  # 조각난 답변이 None이 아니면
                    answer += chunk  # 조각난 답변을 이어붙임.
                    st.markdown(answer)
        # 하나로 합쳐진 GPT의 답변을 st.session_state의 messages에 추가!
        st.session_state.messages.append(
            { 'role': 'assistant', 'content': answer }
        )


if __name__ == "__main__":
    main()
