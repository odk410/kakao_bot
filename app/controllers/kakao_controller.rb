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
    return_text = "임시 텍스트"
    image = false
    # 로또
    # 메뉴
    # 로또와 메뉴 외 다른 명령어가 들어 왔을 때
    # => ㅠㅠ 알 수 없는 명령어 입니다.

    if user_message == "로또"
      return_text = (1..45).sample(6).sort.to_s
    elsif user_message == "메뉴"
      return_text = ["한식", "중식", "일식", "패스트 푸드"].sample(1)
    elsif user_message == "고양이"
      #고양이 사진 보여주기
      image = true
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text


    else
        return_text = "ㅠㅠ 알 수 없는 명령어 입니다. [로또], [메뉴], [고양이] 중 하나를 입력해 주세요~!"
    end

    # return_message = {
    #   :message => {
    #     :text => user_message
    #   }
    # }

    home_keyboard = {
      :type => "text"
    }

    return_message_with_img = {
      :message => {
        :text => return_text,
        :photo => {
          :url => cat_url,
          :width => 640,
          :height => 480
        }
      },
      :keyboard => home_keyboard
    }

    return_message = {
      :message => {
        :text => return_text
      },
      :keyboard => home_keyboard
    }

    # 이미지가 있으면 이미지가 있는 return_message를
    # 없으면 이미지가 없는 return_message를 보낸다.
    if image
      render json: return_message_with_img
    else
      render json: return_message
end
