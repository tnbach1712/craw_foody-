require 'rubygems'
require 'mechanize'
require 'net/http'

url_get_data = 'https://www.foody.vn/hue/saigon-morin-hotel/'
url_send_data = "http://serverkits.com/v1/classes/"
params = { token: '410d1fe213756beb264c645339841ca3', appid: '56e242428f45a80414000000'}
categories = []
#Khởi tạo object
agent = Mechanize.new
# agent.user_agent_alias = 'Windows Chrome'
# agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

#Fetch page
page = agent.get(url_get_data) do |pages|
  @avatar_url = (pages.search ".main-image .pic-place").first.attributes["src"].text
  @images=[]
  @sumary =[]
  @address = []
  @info =[]
  @properties = []
  puts @avatar_url

  sumaries = pages.search ".microsite-top-points"
  sumaries.each_with_index do |sumary, index|
    @sumary << sumary.text.to_s.strip
  end

  @address <<  (pages.search '.res-common-add').text
  @address <<  (pages.search '.res-common-phone').text
  @address <<  (pages.search '.res-common-price').text

  info = (pages.search ".special-content li")
  info.each_with_index do |f, index|
    @info << f.text.strip.to_s
  end

  puts "==============================================="
  info_sec = pages.search ".new-detail-info-area"
  info_sec.each do |f|
    @info << f.text.strip.to_s
  end
  puts "==============================================="
  properties = pages.search ".micro-property li"

  properties.each_with_index do |property, index|
    @properties << property.text
  end

  link_to_album = []
  link_to_albums =pages.search '.img-album-mon-an, .img-album-thuc-don, .img-album-khong-gian, .img-album-tong-hop'
  link_to_albums.each_with_index do |f, index|
    link_to_album << (f.search 'a').first.attributes["href"].text
  end

  puts link_to_album
  puts @address
  puts @sumary
  puts @info
  puts "==============================================="
  puts @properties

  link_to_album.each_with_index do |link,index|
    page = pages.link_with(href: link).click
    images = page.search('.foody-photo')
    images.each do |f|
      @images << f.attributes["href"].text
    end
  end

  puts @images
  # div_content_categories.each_with_index do |link,index|
  #   break if (div_content_categories.size-2 == index)
  #   data_category_result = agent.post url_send_data+"categories", params.merge({name: link.text[2..-1]})
  #   title_id = link.attributes["href"].text
  #   title = (pages.search "#{title_id}")[0] #if (pages.search "#{link_href_id}")[0].present?
  #   data_category_result = JSON.parse(data_category_result.body)
  #   if data_category_result['result'] == "ok" && title
  #     h2 = title.parent

  #     current_element = h2.next_element
  #     #lay ra tat ca nhung ul nam giua 2 the h2
  #     until current_element.name == "h2" do
  #       #neu next_element ko phai ul thi tiep tuc di chuyen den next_element
  #       if current_element.name = "ul"
  #         list_method_of_category =  current_element.search "li"
  #         list_method_of_category.each_with_index do |method, index|
  #           name_method = method.text.split(':')[0]
  #           # name_method : params nam of method
  #           # neu o dau tien la the a thi redirect den do, neu ko thi lay nguyen doan text do lam content cho method
  #           first_child =  method.child
  #           content_method = ""
  #           if first_child.name == 'a'
  #             #lay ra doan href trong link a
  #             link_to_with_href = first_child.attributes["href"].text
  #             begin
  #               content_page = (agent.click(pages.link_with(:href => link_to_with_href))).search("#mw-content-text").first
  #               content_page.children.each do |child|
  #                 break if child.search("#See_also").count > 0
  #                 content_method += ("<#{child.name}>" + child + "</#{child.name}>") if child.name == 'h2' || child.name == 'h3' || child.name == 'p'
  #               end
  #             rescue StandardError => e
  #               # lifeboats
  #             end
  #           else
  #             content_method = method.text
  #           end
  #           content_method.gsub!(/\s*\[.*?\]\s*/, '')
  #           # #create method
  #           category_id = data_category_result['id']
  #           data_method = agent.post url_send_data+"methods", params.merge({category_id: category_id, name: name_method, content: content_method})
  #           puts data_method.body
  #         end
  #       end
  #       current_element = current_element.next_element
  #     end
  #   end
  # end
end