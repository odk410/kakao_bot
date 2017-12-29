class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
      :type => "text"
    }

    render json: home_keyboard
  end

  def message
    #사용자가 보내준 텍스트를 그대로 다시 말하기
    # message parameter로 user_key, type, content가 온다.
    user_message = params[:content]

    # 로또
    lotto = (1..45).sample(6).sort
    lotto = lotto.to_s

    # 메뉴
    menu = ["한식", "중식", "일식", "패스트 푸드"]
    choice = menu.sample

    # 로또와 메뉴 외 다른 명령어가 들어 왔을 때
    # => ㅠㅠ 알 수 없는 명령어 입니다.

    if params[:text] == "로또"
      return_message = {
        :message =>{
          :text => lotto
        }
      }

    else
      return_message = {
        :message => {
          :text => "ㅠㅠ 알 수 없는 명령어 입니다."
        }
      }

    render json: return_message
  end
end
