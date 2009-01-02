class <%= class_name %> < ActiveRecord::Base
  acts_as_invitation :name => "<%= class_name %>"
  
  # If you want to allow invitations and recommendations on multiple models, you'll need a polymorphic association.
  belongs_to :invited, :polymorphic => true
  
  # Otherwise, if you only want invitations to a single model, you don't need polymorphism.
  #belongs_to :photo
  
  #
  # Include belongs_to :user if you want to track the user who sent the invitation. 
  # Keep in mind that if you require a user for each invitation, only users who are logged in can send an invitation.
  #
  belongs_to :user
  validates_presence_of :user_id
end
