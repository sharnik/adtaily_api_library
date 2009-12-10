require File.dirname(__FILE__) + '/test_helper.rb'

class TestAdTailyAPI < Test::Unit::TestCase
  
  context "AdTaily API bought campaign response" do
    setup do
      response_str = <<AMEN
        {
          "campaign":
            {
              "payment_form":"<form action='https://www.paypal.com/cgi-bin/webscr' id='paypal_form' method='post' target='_parent'><input id='tax' name='tax' type='hidden' value='0.00' /><input id='business' name='business' type='hidden' value='adtaily@adtaily.com' /><input id='bn' name='bn' type='hidden' value='ActiveMerchant' /><input id='redirect_cmd' name='redirect_cmd' type='hidden' value='_xclick' /><input id='invoice' name='invoice' type='hidden' value='NbaINk2mDj9XUbJ'/><input id='quantity' name='quantity' type='hidden' value='1' /><input id='cmd' name='cmd' type='hidden' value='_ext-enter' /><input id='address_override' name='address_override' type='hidden' value='0' /><input id='charset' name='charset' type='hidden' value='utf-8' /><input id='no_note' name='no_note' type='hidden' value='1' /><input id='no_shipping' name='no_shipping' type='hidden' value='1' /><input id='item_name' name='item_name' type='hidden' value='Op\u0142ata za reklam\u0119' /><input id='amount' name='amount' type='hidden' value='0.05' /><input id='currency_code' name='currency_code' type='hidden' value='PLN' /><input id='notify_url' name='notify_url' type='hidden' value='http://testing.adkubo.com/notifications/notify_paypal' /><input id='return' name='return' type='hidden' value='http://testing.adkubo.com/notifications/NbaINk2mDj9XUbJ/payment_confirmation' /><input id='cancel_return' name='cancel_return' type='hidden' value='targetblank' /><input id='custom' name='custom' type='hidden' value='NbaINk2mDj9XUbJ' /><input id='item_number' name='item_number' type='hidden' value='NbaINk2mDj9XUbJ' /> <input id='lc' name='lc' type='hidden' value='pl' /></form>",
              "status":"ready",
              "cost":"0.05",
              "key":"NbaINk2mDj9XUbJ",
              "currency":"PLN"
            }
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str, '200', 'OK')
    end

    should "return campaign info" do     
      assert_equal @response.get_campaign["status"],"ready"
      assert @response.get_campaign["cost"].to_f > 0
      %w(payment_form status cost key currency).each do |key|
        assert @response.get_campaign[key]
      end
    end
  end

  context "AdTaily API successful response" do
    setup do
      response_str = <<AMEN
        {
          "message": "Quick brown fox"
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str, '200', 'OK')
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
        }
AMEN
      @response = AdTailyAPI::Response.new(response_str, '400', 'BadRequest')
    end

    should "be classified as failure" do
      assert @response.failure?
    end
  end

  context "AdTaily API widget list response" do
    setup do
      response_str = <<AMEN
        {
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
      @response = AdTailyAPI::Response.new(response_str, '200', 'OK')
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
      @response = AdTailyAPI::Response.new(response_str, '200', 'OK')
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
