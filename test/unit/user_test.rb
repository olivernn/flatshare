require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
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
  
  def test_presence_of_name
    invalid_user = User.new(:contact_number => "01978820343", :password => "computer", :email => 'oliver@mail.com')
    assert(!invalid_user.valid?, "first and last name must be populated")
    assert(invalid_user.errors.invalid?(:first_name), "Expect an attribute missing error")
    assert(invalid_user.errors.invalid?(:second_name), "Expect an attribute missing error")
  end
  
  def test_email_validations
    invalid_email = User.new(:email => "this isnt valid")
    missing_email = User.new(:email => "")
    
    assert(!invalid_email.valid?, "email should be in the right format")
    assert(!missing_email.valid?, "email should be populated")
  end
  
  def test_email_duplication_validation  
    duplicate_email = User.new(:email => 'oliver@mail.com')
    different_case = User.new(:email => 'Oliver@Mail.Com')
    
    assert(!duplicate_email.valid?, "email can't be the same as someone else")
    assert(!different_case.valid?, "email can't be the same as someone else")
  end
  
  def test_contact_number_validations
    #check that I am valid
    assert @me.valid?
    
    #try and break contact number
    invalid_contact_numbers = ['','123456789','555-invalid']
    invalid_contact_numbers.each do |invalid|
      @me.contact_number = invalid
      assert !@me.valid?
    end
  end
  
  def test_password_strength_and_pressence
    #check that I am valid
    assert @me.valid?
    
    #now lets try and break the password
    @me.password = 'poo'
    assert !@me.valid?
    assert @me.errors.invalid?(:password)
    
    @me.password = 'password'
    @me.password_confirmation = 'not password'
    assert !@me.valid?
    assert @me.errors.invalid?(:password)
  end
  
  def test_full_name
    assert_equal(@me.first_name + ' ' + @me.second_name, @me.full_name)
    assert_not_equal(@me.first_name + 'wibble' + @me.second_name, @me.full_name)
  end
  
  def test_count_unread_messages
    assert_equal(@me.count_unread_messages, 1)
    
    #set an unread message to read
    @my_unread_message.read = 1
    @my_unread_message.save
    assert_equal(@me.count_unread_messages, 0)
    
    #set all the messages to unread
    @my_read_message.read = 0
    @my_unread_message.read = 0
    @my_unread_message.save
    @my_read_message.save
    assert_equal(@me.count_unread_messages, 2)
  end
  
  def test_has_favourites
    #try with some favourites
    assert @me.has_favourites
    
    #try without any favourites
    @my_favourite.destroy
    assert !@me.has_favourites 
  end
  
  def test_has_advert
    #try with some favourites
    assert @me.has_advert
    
    #try without any favourites
    @my_advert.destroy
    assert !@me.has_advert
  end
  
  def test_get_advert
    assert @me.get_advert.id = @my_advert.id
  end
  
  def test_has_flatshare_advert
    #since @my_advert is a flatseeker advert this will fail
    assert !@me.has_flatshare_advert
    
    #but just to be sure lets check with katie
    assert @kt.has_flatshare_advert
  end
end
