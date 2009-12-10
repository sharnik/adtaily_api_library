$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'adtaily_api/response'
require 'adtaily_api/multipart_form_post'
require 'net/http'

class AdtailyAPI
  VERSION = '0.0.1'
  ADTAILY_API_URL = 'http://localhost:3000/xapi/'
  
  def self.get_websites
    res = make_api_authorized_request(ADTAILY_API_URL + "widgets")
    response = AdTailyAPI::Response.new(res.body, res.code, res.message)
    if response.success?
      response.get_widget_list
    else
      nil
    end
  end
  
  def self.get_website(key)
    res = make_api_authorized_request(ADTAILY_API_URL + "widgets/#{key}")
    response = AdTailyAPI::Response.new(res.body, res.code, res.message)
    if response.success?
      response.get_widget
    else
      nil
    end
  end
  
  def self.get_campaign(key)
    res = make_api_authorized_request(ADTAILY_API_URL + "campaigns/#{key}")
    response = AdTailyAPI::Response.new(res.body, res.code, res.message)
    if response.success?
      response.get_campaign
    else
      nil
    end    
  end

  def self.buy_campaign(options)
    res = make_api_authorized_post_request(ADTAILY_API_URL + "campaigns/",options)
    response = AdTailyAPI::Response.new(res.body, res.code, res.message)
    if response.success?
      response.get_campaign
    else      
      raise AdTailyAPI::AdTailyAPICampaignNotValid,"Can't buy campaign. Errors: #{response.get_errors.inspect}"
    end
  end
  
  protected
    def self.make_api_authorized_post_request(url,params)
      url = URI.parse(url)
      data, headers = Multipart::Post.prepare_query(params)
      headers["X_API_TOKEN"] = ADTAILY_API_TOKEN
      http = Net::HTTP.new(url.host, url.port)
      res = http.start {|con| con.post(url.path, data, headers) }            
    end
    
    def self.make_api_authorized_request(url)
      url = URI.parse(url)

      req = Net::HTTP::Get.new(url.path)
      req.add_field("X_API_TOKEN", ADTAILY_API_TOKEN)

      res = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req)
      end      
    end
  
end