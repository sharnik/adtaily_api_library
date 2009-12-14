require File.dirname(__FILE__) + '/test_helper.rb'
require 'webmock/test_unit'
include WebMock

class TestAdtailyApi < Test::Unit::TestCase

  context "AdTailyAPI class" do
    setup do
      AdtailyAPI.api_token = 'bazinga'
    end

    context 'getting widget info' do
      setup do
        stub_request(:get, "#{AdtailyAPI.api_url}widgets/foobarbaz").with(
          :headers => { 'X_API_TOKEN' => 'bazinga' }
        ).to_return(
          :body => '{
            "widget": {
              "key": "foobarbaz",
              "title": "Radarek bloguje",
              "url": "http://radarek.pl",
              "monthly_pageviews": "767868",
              "tags": "zwierzęta, jeż, sport, programowanie w swetrach",
              "daily_price": "9,99 PLN"
            }
          }',
          :status => '200'
        )
        stub_request(:get, "#{AdtailyAPI.api_url}widgets/pinga-pinga").with(
          :headers => { 'X_API_TOKEN' => 'bazinga' }
        ).to_return(
          :body => '',
          :status => '404'
        )
      end
    
      should "get widget info for existing key" do
        wi = AdtailyAPI.get_website('foobarbaz')
        assert wi
        assert_equal 'foobarbaz', wi['key']
        assert_equal 'Radarek bloguje', wi['title']
      end      
    
      should 'return nil for non-existing key' do
        wi = AdtailyAPI.get_website('pinga-pinga')
        assert_nil wi
      end
    end
    
    context 'getting a widget list' do      
      setup do
        stub_request(:get, "#{AdtailyAPI.api_url}widgets").with(
          :headers => { 'X_API_TOKEN' => 'bazinga' }
        ).to_return(
          :body => '{
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
                "title": "Twój jeż",
                "url": "http://twojjez.blox.pl",
                "monthly_pageviews": "256325",
                "tags": "zwierzęta, jeż",
                "daily_price": "5,99 PLN"
              }
            ]
          }',
          :status => '200'
        )
      end
    
      should 'get more than one' do
        list = AdtailyAPI.get_websites
        assert list
        assert list.length > 1
      end
    end
        
        
    context "buying a campaign" do
      setup do
        stub_request(:post, "#{AdtailyAPI.api_url}campaigns/").with(
          :headers => { 'X_API_TOKEN' => 'bazinga'}
        ).to_return(
          :body => '{
            "campaign": {
              "payment_form":"<form action=\'https://www.paypal.com/cgi-bin/webscr\' id=\'paypal_form\' method=\'post\' target=\'_parent\'><input id=\'tax\' name=\'tax\' type=\'hidden\' value=\'0.00\' /><input id=\'business\' name=\'business\' type=\'hidden\' value=\'adtaily@adtaily.com\' /><input id=\'bn\' name=\'bn\' type=\'hidden\' value=\'ActiveMerchant\' /><input id=\'redirect_cmd\' name=\'redirect_cmd\' type=\'hidden\' value=\'_xclick\' /><input id=\'invoice\' name=\'invoice\' type=\'hidden\' value=\'NbaINk2mDj9XUbJ\'/><input id=\'quantity\' name=\'quantity\' type=\'hidden\' value=\'1\' /><input id=\'cmd\' name=\'cmd\' type=\'hidden\' value=\'_ext-enter\' /><input id=\'address_override\' name=\'address_override\' type=\'hidden\' value=\'0\' /><input id=\'charset\' name=\'charset\' type=\'hidden\' value=\'utf-8\' /><input id=\'no_note\' name=\'no_note\' type=\'hidden\' value=\'1\' /><input id=\'no_shipping\' name=\'no_shipping\' type=\'hidden\' value=\'1\' /><input id=\'item_name\' name=\'item_name\' type=\'hidden\' value=\'Op\u0142ata za reklam\u0119\' /><input id=\'amount\' name=\'amount\' type=\'hidden\' value=\'0.05\' /><input id=\'currency_code\' name=\'currency_code\' type=\'hidden\' value=\'PLN\' /><input id=\'notify_url\' name=\'notify_url\' type=\'hidden\' value=\'http://testing.adkubo.com/notifications/notify_paypal\' /><input id=\'return\' name=\'return\' type=\'hidden\' value=\'http://testing.adkubo.com/notifications/NbaINk2mDj9XUbJ/payment_confirmation\' /><input id=\'cancel_return\' name=\'cancel_return\' type=\'hidden\' value=\'targetblank\' /><input id=\'custom\' name=\'custom\' type=\'hidden\' value=\'NbaINk2mDj9XUbJ\' /><input id=\'item_number\' name=\'item_number\' type=\'hidden\' value=\'NbaINk2mDj9XUbJ\' /> <input id=\'lc\' name=\'lc\' type=\'hidden\' value=\'pl\' /></form>",
              "status":"ready",
              "cost":"0.05",
              "key":"NbaINk2mDj9XUbJ",
              "currency":"PLN"
            }
          }',
          :status => '201'
        )
        stub_request(:get, "#{AdtailyAPI.api_url}campaigns/NbaINk2mDj9XUbJ").with(
          :headers => { 'X_API_TOKEN' => 'bazinga'}
        ).to_return(
          :body => '{
            "campaign": {
              "status": "active",
              "key": "jh43k4hk3",
              "pageviews": "81232",
              "clicks": "23723",
              "ads": [ 
                {
                  "key": "2kj32kj34hj2",
                  "target_url": "http://mojjez.blox.pl",
                  "description": "Lorem ipsum dolor sit amet",
                  "image_url": "http://adtaily.production.com/images/ad.gif"
                }
              ],
              "emissions": [
                {
                  "key": "kj43h4kj3hk",
                  "status": "active",
                  "ad": "2kj32kj34hj2",
                  "widget": "fb22p62yti",
                  "pageviews": "8327",
                  "clicks": "2323",
                  "start_at": "2009-09-12 00:00:00 CES",
                  "stop_at": "2009-09-17 00:00:00 CES"
                }
              ]
            }
          }',
          :status => '201'
        )
        stub_request(:get, "#{AdtailyAPI.api_url}campaigns/7xwOqvhz36QMxt1").with(
          :headers => { 'X_API_TOKEN' => 'bazinga-sringa'}
        ).to_return(
          :body => '',
          :status => '404'
        )
        stub_request(:get, "#{AdtailyAPI.api_url}campaigns/7xwOqvhz36QMxt1").with(
          :headers => { 'X_API_TOKEN' => 'bazinga'}
        ).to_return(
          :body => '{
            "campaign": {
              "status": "active",
              "key": "7xwOqvhz36QMxt1",
              "pageviews": "81232",
              "clicks": "23723",
              "ads": [ 
                {
                  "key": "2kj32kj34hj2",
                  "target_url": "http://mojjez.blox.pl",
                  "description": "Lorem ipsum dolor sit amet",
                  "image_url": "http://adtaily.production.com/images/ad.gif"
                }
              ],
              "emissions": [
                {
                  "key": "kj43h4kj3hk",
                  "status": "active",
                  "ad": "2kj32kj34hj2",
                  "widget": "fb22p62yti",
                  "pageviews": "8327",
                  "clicks": "2323",
                  "start_at": "2009-09-12 00:00:00 CES",
                  "stop_at": "2009-09-17 00:00:00 CES"
                }
              ]
            }
          }',
          :status => '201'
        )
      end
    
      should "buy campaign" do
        params = {"target_url" => "http://cos.pl","description" => "desc",
          "widgets" => ["fb22p62yti"], "payment_method" => "paypal", 'profit' => '0%',
          "start_date" => Date.today, "stop_date" => (Date.today + 2),
          "image" => File.open(File.dirname(__FILE__)+"/fixtures/images/moj_jez.jpg")
        }
        bought_campaign = AdtailyAPI.buy_campaign(params)
        assert bought_campaign['payment_form']
        assert_equal 'ready', bought_campaign['status']
        campaign = AdtailyAPI.get_campaign(bought_campaign['key'])
        assert campaign
        assert_equal 1, campaign['ads'].size
        assert_equal 'fb22p62yti', campaign['emissions'].first['widget']
      end
          
      should 'get campaign info for existing key' do
        c = AdtailyAPI.get_campaign('7xwOqvhz36QMxt1')
        assert c
        assert_equal '7xwOqvhz36QMxt1', c['key']
        assert c['ads'].size > 0
      end
      
      should 'return nil for unauthorised request' do
        AdtailyAPI.api_token = 'bazinga-sringa'
        c = AdtailyAPI.get_campaign('7xwOqvhz36QMxt1')
        assert_nil c
      end
    end
    
    context "when trying to buy an inappropriate campaign" do
      setup do
        stub_request(:post, "#{AdtailyAPI.api_url}campaigns/").with(
          :headers => { 'X_API_TOKEN' => 'bazinga'}
        ).to_return(
          :body => '{
            "errors": [
              {
                "name":"missing_params",
                "params": ["target_url"]
              }
            ]
          }',
          :status => '422'
        )
      end

      should "not buy campaign" do
        params = { "description" => "desc",
          "widgets" => ["fb22p62yti"], "payment_method" => "paypal",
          "start_date" => Date.today, "stop_date" => (Date.today + 2),
          "image" => File.open(File.dirname(__FILE__)+"/fixtures/images/moj_jez.jpg")
        }
        assert_raise(AdTailyAPI::CampaignNotValid){
          AdtailyAPI.buy_campaign(params)
        }
        begin
          AdtailyAPI.buy_campaign(params)
        rescue AdTailyAPI::CampaignNotValid => e
          assert_equal [{"name"=>"missing_params", "params"=>["target_url"]}], e.message
        end
        
      end
    end
    
  end
end
