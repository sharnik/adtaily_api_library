require 'json'

class AdTailyAPI
  class Error < StandardError; end
  # Unknown server response
  class AdTailyAPIUnknownResponse < Error; end
  # Invalid request server response
  class AdTailyAPIInvalidRequest< Error; end


  class Response
    attr_accessor :data, :http_status, :http_message
    
    def initialize(response_str, code, message)
      raise AdTailyAPIUnknownResponse if response_str.nil?
      @http_status = code
      @http_message = message
      @data = JSON.parse(response_str) if self.success?
    end
        
    def success?
      ['200', '201'].include? http_status and ['OK','Created'].include? http_message
    end
    
    def failure?
      !success?
    end

    def get_widget_list
      @data['widgets'] if self.success?
    end
    
    def get_widget
      @data['widget'] if self.success?
    end

    def get_campaign
      @data['campaign'] if self.success?
    end
  end

end
