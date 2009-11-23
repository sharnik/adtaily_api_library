require File.dirname(__FILE__) + '/test_helper.rb'

class TestAdTailyAPI < Test::Unit::TestCase
  
  context "AdTaily API successful response" do
    setup do
      response_str = <<AMEN
        {
          "http_status": {
            "code": 200,
            "message": "OK"
          },
          "message": "Quick brown fox"
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str)
    end

    should "be classified as success" do
      assert @response.success?
    end
    
    should "provide data" do
      assert_contains @response.data['message'], /brown fox/
    end
  end
  
  context "AdTaily API Invalid Request response" do
    setup do
      response_str = <<AMEN
        {
          "http_status": {
            "code": "400",
            "message": "request invalid"
          }
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str)
    end

    should "be classified as failure" do
      assert @response.failure?
    end
  end

  context "AdTaily API widget list response" do
    setup do
      response_str = <<AMEN
        {
          "http_status": {
            "code": 200,
            "message": "OK"
          },
          "widgets": [
            {
              "key": "j34hkh3k",
              "title": "Mój jeż",
              "url": "http://mojjez.blox.pl",
              "monthly_pageviews": "767868",
              "tags": "zwierzęta, jeż, sport",
              "daily_price": "9,99 PLN"
            },
            {
              "key": "3h4j33kj4",
              "title": "Twój jeż",
              "url": "http://twojjez.blox.pl",
              "monthly_pageviews": "256325",
              "tags": "zwierzęta, jeż",
              "daily_price": "5,99 PLN"
            }
          ]
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str)
    end
    
    should "return a widget list" do
      assert @response.get_widget_list.length, 2
      assert_equal @response.get_widget_list.first['key'], "j34hkh3k"
      %w(key title url monthly_pageviews tags daily_price).each do |key|
        assert @response.get_widget_list.first[key]
      end
    end
  end

  context "AdTaily API single widget response" do
    setup do
      response_str = <<AMEN
      {
        "http_status": {
          "code": 200,
          "message": "OK"
        },
        "widget": {
          "key": "j34hkh3k",
          "title": "Mój jeż",
          "url": "http://mojjez.blox.pl",
          "monthly_pageviews": "767868",
          "tags": "zwierzęta, jeż, sport",
          "daily_price": "9,99 PLN"
        }
      }
AMEN
      @response = AdTailyAPI::Response.new(response_str)
    end

    should "return a single widget" do
      assert @response.get_widget
      assert_equal @response.get_widget['key'], "j34hkh3k"
      %w(key title url monthly_pageviews tags daily_price).each do |key|
        assert @response.get_widget[key]
      end
    end
  end
  
end
