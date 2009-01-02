require File.dirname(__FILE__) + '/../test_helper'

class AdvertTest < Test::Unit::TestCase
  fixtures :users, :messages, :favorites, :adverts, :images
  
  def setup
    @me = users(:oliver)
    @kt = users(:kaite)
    @my_advert = adverts(:olivers_advert)
    @kt_advert = adverts(:katies_advert)
    @my_unread_message = messages(:unread)
    @my_read_message = messages(:read)
    @my_favourite = favorites(:favourite)
  end
  
  def test_rent_numericality
    invalid_ad = Advert.new(:rent => "not valid")
    assert !invalid_ad.valid?, "rent has to be numeric"
    assert invalid_ad.errors.invalid?(:rent), "there should be an error message"
  end
  
  def test_presence_of_validations
    invalid_ad = Advert.new(:headline => "")
    assert !invalid_ad.valid?, "headline must be present"
    assert invalid_ad.errors.invalid?(:headline), "there should be an error message"
    
    another_invalid_ad = Advert.new(:date_available => "")
    assert !invalid_ad.valid?, "date available must be present"
    assert invalid_ad.errors.invalid?(:date_available), "there should be an error message"
  end
  
  def test_description_validation
    invalid_ad = Advert.new(:description => "this is less than 100 characters")
    assert !invalid_ad.valid?, "description must be at least 100 chars"
    assert invalid_ad.errors.invalid?(:description), "there should be an error message"
  end
  
  def test_contact_details_validation
    email_in_text = "blah blah oliver@mail.com blah blah blah" #email cannot be in free text
    tel_number_in_text = "blah blah blah 01978820343 blah blah" #telephone number cannot be in free text
    another_number_in_text = "blah blah blah 020 4587 1234 blah blah" #any telephone number cannot be in free text
    
    [email_in_text,tel_number_in_text,another_number_in_text].each do |invalid|
      [:description, :headline, :interests].each do |field|
        invalid_advert = Advert.new(field => invalid)
        assert !invalid_advert.valid?, "#{field} should not be able to contact #{invalid}"
        #this will raise an error message but it is not associated to the field that the problem is in
        #assert invalid_advert.errors.invalid?(field), "#{field} should not be able to contact #{invalid} and should raise an error"
      end
    end
  end
  
  def test_advert_owner
    assert_equal @my_advert.owner.id, @me.id
    assert_not_equal @kt_advert.owner.id, @me.id
  end
  
  def test_featurable
    assert_equal Advert.featurable.first.id, @my_advert.id
    assert_equal Advert.featurable.size, 1
  end
  
  def test_selected_rich_attributes
    @kt_advert.rich_attributes << RichAttribute.new(:name => "Terrarce")
    @kt_advert.rich_attributes << RichAttribute.new(:name => "XBOX")
    assert_equal @kt_advert.selected_rich_attributes, 'Terrarce,XBOX'
    assert_not_equal @kt_advert.selected_rich_attributes, 'Something else'
    assert_equal @my_advert.selected_rich_attributes, ''
  end
  
  def test_add_rich_attributes
    existing_attr = RichAttribute.create(:name => 'Old')
    @my_advert.add_rich_attributes('Old,New, Another New')
    assert_equal @my_advert.rich_attributes.size, 3
    assert_equal RichAttribute.find(:all).size, 3
    assert RichAttribute.exists?(:name => 'New')
    assert RichAttribute.exists?(:name => 'Another New')
  end
  
  def test_is_new
    assert !@my_advert.is_new
    @my_advert.update_attribute(:created_at, Time.now())
    assert @my_advert.is_new
  end
  
  def test_place_in_quarantine
    assert_equal Quarantine.find(:all).size, 0
    @my_advert.place_in_quarantine
    quarantined = Quarantine.find(:all)
    assert_equal quarantined.size, 1
    assert_equal quarantined.first.advert.description, @my_advert.description
    assert_equal quarantined.first.advert.headline, @my_advert.headline
    assert_equal quarantined.first.advert.interests, @my_advert.interests
    assert_equal quarantined.first.advert_id, @my_advert.id
    assert @my_advert.quarantine
  end
  
  def test_remove_from_quarantine
    @my_advert.place_in_quarantine
    assert Quarantine.exists?(:advert_id => @my_advert.id)
    assert @my_advert.quarantine
    @my_advert.remove_from_quarantine
    
    #advert should still be there because we havn't changed anything yet!
    assert @my_advert.quarantine
    assert Quarantine.exists?(:advert_id => @my_advert.id)
    
    #change the description and it should be removable
    @my_advert.update_attribute(:description, 'changed')    
    assert_not_equal @my_advert.description, Quarantine.find_by_advert_id(@my_advert.id).advert.description
    
    @my_advert.remove_from_quarantine
    assert !@my_advert.quarantine
    assert !Quarantine.exists?(:advert_id => @my_advert.id)
  end
  
  def test_refresh
    assert @my_advert.created_at < Time.now()
    @my_advert.refresh
    assert @my_advert.created_at > Time.now - 5 #check the advert created_at is later than 5 seconds ago
  end
  
  def test_refresh_applicable
    #the base advert will be refreshable because it is quite old, lets test that
    assert @my_advert.refresh_applicable
    #update the created at timestamp so that it wont be refreshable
    @my_advert.update_attribute(:created_at, Time.now())
    assert !@my_advert.refresh_applicable
  end
  
  def test_before_save
    @my_advert.rent = 100
    @my_advert.bills = 100
    weekly_rent = (@my_advert.rent*52)/12
    weekly_bills = (@my_advert.bills*52)/12
    
    @my_advert.rent_frequency = "Weekly"
    @my_advert.bills_frequency = "Weekly"
    @my_advert.save
    
    assert_equal @my_advert.rent.to_f, weekly_rent.to_f
    assert_equal @my_advert.bills.to_f, weekly_bills.to_f
    
    @my_advert.rent = 100
    @my_advert.bills = 100
    monthly_rent = @my_advert.rent
    monthly_bills = @my_advert.bills
    
    @my_advert.rent_frequency = "Monthly"
    @my_advert.bills_frequency = "Monthly"
    @my_advert.save
    
    assert_equal @my_advert.rent.to_f, monthly_rent.to_f
    assert_equal @my_advert.bills.to_f, monthly_bills.to_f
  end
end
