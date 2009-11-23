$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'adtaily_api/response'
require 'net/http'

class AdtailyAPI
  VERSION = '0.0.1'
  ADTAILY_API_URL = 'http://dev.adkubo.com/xapi/'
  ADTAILY_API_TOKEN = '123'
  
  def self.get_websites
    res = make_api_authorized_request(ADTAILY_API_URL + "widgets")
    response = AdTailyAPI::Response.new(res.body)
    if response.success?
      response.get_widget_list
    else
      nil
    end
  end
  
  def self.get_website(key)
    res = make_api_authorized_request(ADTAILY_API_URL + "widgets/#{key}")
    response = AdTailyAPI::Response.new(res.body)
    if response.success?
      response.get_widget
    else
      nil
    end
  end
  
  protected
    def self.make_api_authorized_request(url)
      url = URI.parse(url)

      req = Net::HTTP::Get.new(url.path)
      req.add_field("X_API_TOKEN", ADTAILY_API_TOKEN)

      res = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req)
      end      
    end
  
end