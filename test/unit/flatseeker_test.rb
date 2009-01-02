require File.dirname(__FILE__) + '/../test_helper'

class FlatseekerTest < Test::Unit::TestCase
  fixtures :users, :messages, :favorites, :adverts
  
  def setup
    @me = users(:oliver)
    @kt = users(:kaite)
    @my_advert = adverts(:olivers_advert)
    @kt_advert = adverts(:katies_advert)
    @my_unread_message = messages(:unread)
    @my_read_message = messages(:read)
    @my_favourite = favorites(:favourite)
  end
  
  def test_search
    search_params = Hash.new
    
    search_params[:area] = "Battersea"
    assert_equal Flatseeker.search(search_params,1).size, 4
    
    search_params[:area] = "Not Battersea"
    assert_equal Flatseeker.search(search_params,1).size, 0
    
    search_params[:area] = "Battersea"
    search_params[:rent] = 1000
    assert_equal Flatseeker.search(search_params,1).size, 3
    
    @my_advert.quarantine = true
    @my_advert.save
    assert_equal Flatseeker.search(search_params,1).size, 2
  end
  
  def test_matching_adverts
    assert_equal @my_advert.matching_adverts.size, 2
    @my_advert.couples = true
    @my_advert.save
    assert_equal @my_advert.matching_adverts.size, 1
  end
end
