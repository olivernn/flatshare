class Station < ActiveRecord::Base
  acts_as_mappable :auto_geocode => {:field => :postcode, :error_message => 'Unable to geocode postcode'}
end
