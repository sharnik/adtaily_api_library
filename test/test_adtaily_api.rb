require File.dirname(__FILE__) + '/test_helper.rb'

class TestAdtailyApi < Test::Unit::TestCase

  context "AdTailyAPI class" do
    setup do
      AdtailyAPI::ADTAILY_API_TOKEN = 'bazinga'
    end

#    should "buy campaign" do
#      params = {"target_url" => "http://cos.pl","description" => "desc",
#      "widgets" => ["fb22p62yti"], "payment_method" => "paypal",
#      "start_date" => Date.today, "stop_date" => 2.days.from_now,
#      "image" => File.open("/tmp/creation_645.jpg")
#      }
#      campaign = AdtailyAPI.buy_campaign(params)
#      raise campaign
#    end

    should "get widget info for existing key" do
      wi = AdtailyAPI.get_website('wu8edcee6h')
      assert wi
      assert_equal 'wu8edcee6h', wi['key']
      assert_equal 'Radarek bloguje', wi['title']
    end
    
    should 'return nil for non-existing key' do
      wi = AdtailyAPI.get_website('Bazinga-sringa')
      assert_nil wi
    end
    
    should 'get all widgets list' do
      list = AdtailyAPI.get_websites
      assert list.length > 1
    end
    
    should 'get campaign info for existing key' do
      c = AdtailyAPI.get_campaign('7xwOqvhz36QMxt1')
      assert c
      assert_equal '7xwOqvhz36QMxt1', c['key']
      assert c['ads'].size > 0
    end
  
    should 'return nil for unauthorised request' do
      AdtailyAPI::ADTAILY_API_TOKEN = 'bazinga-sringa'
      c = AdtailyAPI.get_campaign('7xwOqvhz36QMxt1')
      assert_nil c
    end    

  end

end
