require File.dirname(__FILE__) + '/test_helper.rb'

class TestAdtailyApi < Test::Unit::TestCase

  context "AdTailyAPI class" do
    should "get widget info for existing key" do
      wi = AdtailyAPI.get_website('foobarbaz')
      assert wi
      assert_equal 'foobarbaz', wi['key']
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
  end

end
