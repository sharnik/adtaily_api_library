require File.dirname(__FILE__) + '/test_helper.rb'

class TestAdtailyApi < Test::Unit::TestCase

  context "AdTailyAPI class" do
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
  end

end
