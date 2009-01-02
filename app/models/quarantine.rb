class Quarantine < ActiveRecord::Base
  belongs_to :advert
  def advert
    self[:advert] ? Marshal.load(self[:advert]) : nil
  end
  
  def advert=(x)
    self[:advert] = Marshal.dump(x)
  end
end
