$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'errors'
require 'json'

class AdTailyAPI
  class Response
    attr_accessor :data, :http_status, :http_message
    
    def initialize(response_str, code, message)
      raise UnknownResponse if response_str.nil?
      @http_status = code
      @http_message = message
      begin
        @data = JSON.parse(response_str)
      rescue => e
        @data = nil
      end      
    end
        
    def success?
      ['200', '201'].include? http_status
    end
    
    def failure?
      !success?
    end

    def get_widget_list
      @data['widgets']
    end
    
    def get_widget
      @data['widget']
    end

    def get_campaign
      @data['campaign']
    end

    def get_errors
      @data['errors']
    end
  end

end
