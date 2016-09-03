# -*- coding: utf-8 -*-                                                                               
require "sinatra/base"

# トークンなど
CALLBACK_TOKEN = "hashikan.retty-token"



class App < Sinatra::Base
  # GETで来るのはコールバック検証                                                                     
  get "/" do
    if params["hub.verify_token"] == CALLBACK_TOKEN
      return params["hub.challenge"]
    end
    return ""
  end

  # POSTで来るのはメッセージリクエスト                                                                
  post "/", provides: :json do
    begin
      raw_body = request.body.read

      # シグネチャ検証                                                                               \

      return "" if request.env["HTTP_X_HUB_SIGNATURE"].nil?
      hub_signature = request.env["HTTP_X_HUB_SIGNATURE"].sub(/sha1=/, "")z
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), APP_SECRET, raw_body)
      return "" if hub_signature != signature

      # メッセージループ                   
      body = JSON.parse(raw_body)
      body["entry"].each do |entry|
        entry["messaging"].each do |message|
          return if message["message"].nil?
          Bot.recieveMessage(entry, message)
        end
      end

    rescue
      p $!
    end

    return ""
  end
end

class Bot
 def self.recieveMessage(entry, message)

   str=message["message"]["text"]
 # メッセージの中身を確認する                                                                        \

 check = str.include?("病院")
 p(check)

 if check
   route2 = message["message"]["text"]
   url_escape2 = URI.escape(route2)

   robotex = Robotex.new

   url='http://www.hospita.jp/search/site/?q='+url_escape2+"/"

     # p(url)                                                                                         
     self.sendMessage(message["sender"]["id"], url)
     user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.15\
     00\                                                                                                   
     .63 Safari/537.36'
     # open('output_seminar.txt', 'w') do |file|                                                     \

     charset = nil
     html = open(url, "User-Agent" => user_agent) do |f|
       charset = f.charset
       f.read
     end

     doc = Nokogiri::HTML.parse(html, nil, charset)
    # p doc.xpath('//*[@id="NumberSection"]/dl[1]/dd/dl/dd[3]').text                                  

  else

   path = '/byouki/kw-'

   route = path+message["message"]["text"]
   url_escape = URI.escape(route)
   p(url_escape)
# return                                                                                            
scrape = 'http://medical.itp.ne.jp'
  # p(scrape)                                                                                         

  robotex = Robotex.new
  # p robotex.allowed?(scrape+url_escape)                                                             

  url = scrape+url_escape+"/"
  p(url)
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500\
  .63 Safari/537.36'
   # open('output_seminar.txt', 'w') do |file|                                                        
   charset = nil
   html = open(url, "User-Agent" => user_agent) do |f|
     charset = f.charset
     f.read
   end

   doc = Nokogiri::HTML.parse(html, nil, charset)

   p doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[2]/dt/a').text

   n1=doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[2]/dt/a').text
   n2=doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[3]/dt/a').text
   n3=doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[4]/dt/a').text
   n4=doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[5]/dt/a').text
   n5=doc.xpath('//*[@id="listsort"]/dl/dd[2]/div/div[1]/dl[6]/dt/a').text


   self.sendMessage(message["sender"]["id"], "もしかすると...")
   self.sendMessage(message["sender"]["id"], n1)
   self.sendMessage(message["sender"]["id"], n2)
   self.sendMessage(message["sender"]["id"], n3)
   self.sendMessage(message["sender"]["id"], n4)
   self.sendMessage(message["sender"]["id"], n5)
   self.sendMessage(message["sender"]["id"], "かもしれません。")

   # テキストメッセージだった場合、そのまま返す                                                      \

 end
end

def self.sendMessage(recipient_id, message)
 url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{PAGE_TOKEN}"
 body = {
   "recipient" => {
     "id" => recipient_id
     },
     "message" => {
       "text" => message
       },
     }

     client = HTTPClient.new
     client.post_content(
       url,
       body.to_json,
       'Content-Type' => 'application/json'
       )
   end


 end
 



