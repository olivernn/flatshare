class Promotion < ActiveRecord::Base
  def before_create
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
    self.code = '' 
    10.times { self.code << chars[rand(chars.size)] }
    self.number_of_uses = 0
  end
  
  def self.vaildate_code(code)
    promotion = find(:first, :conditions => ['code =? AND start_date <= CURRENT_DATE AND end_date > CURRENT_DATE', code])
    if promotion
      promotion.update_attribute(:number_of_uses, promotion.number_of_uses + 1)
      true
    else
      false
    end
  end
end
