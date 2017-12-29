require 'parser' #helper에 등록한 것을 자동으로 찾는다.

class KakaoController < ApplicationController
  def keyboard
    # home_keyboard = {
    #   :type => "text"
    # }

    home_keyboard = {
      :type => "buttons",
      :buttons => ["영화", "메뉴", "고양이", "로또"]
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
      # return_text = "난 고양이 없다..."
      # image = true
      # url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      # cat_xml = RestClient.get(url)
      # doc = Nokogiri::XML(cat_xml)
      # img_url = doc.xpath("//url").text

      image = true
      animal = Parser::Animal.new
      puts animal.methods
      cat_info = animal.cat
      return_text = cat_info[0]
      img_url = cat_info[1]

    # 네이버 영화 제목, 이미지, 평점 가져오기
    elsif user_message == "영화"
      #image = true
  		# url = "http://movie.naver.com/movie/running/current.nhn?view=list&tab=normal&order=reserve"
  		# movie_html = RestClient.get(url)
  		# doc = Nokogiri::HTML(movie_html)
      #
  		# movie_title = Array.new
  		# movie_info = Hash.new
  		# doc.css("ul.lst_detail_t1 dt a").each do |title|
  		# 	movie_title << title.text
  		# end
		  # doc.css("ul.lst_detail_t1 li").each do |movie|
  		# 	movie_info[movie.css("dl dt.tit a").text] = {
  		# 		:url => movie.css("div.thumb img").attribute('src').to_s,
  		# 		:star => movie.css("dl.info_star span.num").text
  		# }
  		# end
  		# sample_movie = movie_title.sample
  		# return_text = sample_movie + " " + movie_info[sample_movie][:star]
  		# cat_url = movie_info[sample_movie][:url]

      image = true
      naver_movie = Parser::Movie.new # Parser에 있는 Movie라는 클래스를 만든다.
      naver_movie_info = naver_movie.naver
      return_text = naver_movie_info[0]
      img_url = naver_movie_info[1]

    else
      return_text = "ㅠㅠ 알 수 없는 명령어 입니다. [로또], [메뉴], [고양이] 중 하나를 입력해 주세요~!"
    end

    # return_message = {
    #   :message => {
    #     :text => user_message
    #   }
    # }

    home_keyboard = {
      :type => "buttons",
      :buttons => ["영화", "메뉴", "고양이", "로또"]
    }

    return_message_with_img = {
      :message => {
        :text => return_text,
        :photo => {
          :url => img_url,
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
  end
end
