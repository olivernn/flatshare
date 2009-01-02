class Lookup < ActiveRecord::Base  
  def get_areas(input_string)
    if input_string
      @areas = Lookup.find(:all, :conditions => ['name = "Area" AND value LIKE ?', '%' + input_string + '%'], :order => 'value ASC')
      render :partial => 'shared/areas'
    end
  end
  
  def get_stations(input_string)
    if input_string
      @stations = Station.find(:all, :select => 'DISTINCT name, id', :conditions => ['name LIKE ?', '%' + input_string + '%'], :order => 'name ASC')
      render :partial => 'shared/stations'
    end
  end
  
  def get_room_types
    Lookup.find(:all, :conditions => ['name = "RoomType"'])
  end
  
  def get_lookup_values(table_name)
    Lookup.find(:all, :conditions => ['name = "' + table_name + '"'])
  end
end
