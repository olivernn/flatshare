class Picture < ActiveRecord::Base
  belongs_to :advert
  
  validates_format_of :content_type,
                      :with => /^image/,
                      :message => "--you can only upload pictures"
  
  def display
    send_data(self.data, :filename => self.name, :type => self.content_type, :disposition => "inline")
  end
  
  def before_save
    
  end
  
  def uploaded_picture=(picture_field)
    self.name = base_part_of(picture_field.original_filename)
    self.content_type = picture_field.content_type.chomp
    self.data = picture_field.read
  end
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/,'')
  end
end
