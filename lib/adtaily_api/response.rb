require 'json'

class AdTailyAPI
  class Error < StandardError; end
  # Unknown server response
  class AdTailyAPIUnknownResponse < Error; end
  # Invalid request server response
  class AdTailyAPIInvalidRequest< Error; end


  class Response
    attr_accessor :data
    
    def initialize(response_str)
      raise AdTailyAPIUnknownResponse if response_str.nil?
      @data = JSON.parse(response_str)
    end
    
    def http_status
      @data['http_status']['code']
    end
    
    def http_message
      @data['http_status']['message']
    end
    
    def success?
      [200, 201].include? http_status and http_message == 'OK'
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
  end

end
