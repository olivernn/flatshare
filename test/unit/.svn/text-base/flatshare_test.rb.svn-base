require File.dirname(__FILE__) + '/../test_helper'

class FlatshareTest < Test::Unit::TestCase
  fixtures :users, :messages, :favorites, :adverts, :images, :stations
  
  def setup
    @me = users(:oliver)
    @kt = users(:kaite)
    @my_advert = adverts(:olivers_advert)
    @kt_advert = adverts(:katies_advert)
    @my_unread_message = messages(:unread)
    @my_read_message = messages(:read)
    @my_favourite = favorites(:favourite)
  end
  
  def test_numericality_validations
    [Flatshare.new(:bills => ""), 
     Flatshare.new(:bills => "not numeric"),
     Flatshare.new(:housemates => ""),
     Flatshare.new(:housemates => "not_numeric"),
     Flatshare.new(:deposit => ""),
     Flatshare.new(:deposit => "not_numeric")].each do |invalid|
       validation_tester(invalid)
    end
  end
  
  def test_nearest_station
    assert_equal @kt_advert.nearest_stations.size, 2
  end
  
  def test_search
    #@kt_advert is a flatshare advert, see fixture for the details, we will try and find it with all possible combinations of the search

    #first, just use rent
    search_params = Hash.new
    search_params[:max_rent] = 10000 #this should return @kt_advert
    search_results = Flatshare.search(search_params)
    
    assert_equal search_results.size, 1
    assert_equal search_results.first.id, @kt_advert.id
    assert search_results.first.rent < search_params[:max_rent]
    
    #this shouldn't match anything
    @kt_advert.quarantine = true
    @kt_advert.save
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    @kt_advert.update_attribute(:quarantine, false)
    search_params[:max_rent] = 10
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    #this time use rent and area
    #these should find something
    @kt_advert.update_attribute(:quarantine, false)
    search_params[:area] = "Battersea"
    search_params[:max_rent] = 10000
    search_results = Flatshare.search(search_params)
    
    assert_equal search_results.size, 1
    assert_equal search_results.first.id, @kt_advert.id
    assert search_results.first.rent < search_params[:max_rent]
    assert_equal search_results.first.area, search_params[:area]
    
    #these shouldn't match
    @kt_advert.update_attribute(:quarantine, true)
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    @kt_advert.update_attribute(:quarantine, false)
    search_params[:area] = "Not Battersea"
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    search_params[:area] = "Battersea"
    search_params[:max_rent] = 10
    search_results = search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    #this time use rent, area and station
    #these should match
    @kt_advert.update_attribute(:quarantine, false)
    search_params[:area] = "Battersea"
    search_params[:max_rent] = 10000
    search_params[:station] = "Clapham Junction"
    search_params[:distance] = "1 mile"
    search_results = Flatshare.search(search_params)
    
    assert_equal search_results.size, 1
    assert_equal search_results.first.id, @kt_advert.id
    assert search_results.first.rent < search_params[:max_rent]
    assert_equal search_results.first.area, search_params[:area]
    
    #these shouldn't match
    @kt_advert.update_attribute(:quarantine, true)
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    @kt_advert.update_attribute(:quarantine, false)
    search_params[:station] = "Euston"
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    search_params[:station] = "Clapham Junction"
    search_params[:max_rent] = 10
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
    
    search_params[:max_rent] = 10000
    search_params[:area] = "Not Battersea"
    search_results = Flatshare.search(search_params)
    assert_equal search_results.size, 0
  end
  
  def test_matching_adverts
    assert_equal @kt_advert.matching_adverts.size, 1
    assert_equal @kt_advert.matching_adverts.first.id, @my_advert.id
    
    @my_advert.quarantine = true
    @my_advert.save
    assert_equal @kt_advert.matching_adverts.size, 0    
  end
end
