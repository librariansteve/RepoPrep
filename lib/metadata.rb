class Metadata
  @metadata = {}
  
  def add_value(key, value)
#    @metadata[key][:values] = @metadata[key][:values] << @metadata[key][:filter](value)
  end
  
  def clear_values(key)
#    @metadata[key][:values] = []
  end
  
  def add_key(key, tag_start, tag_end, filter = nil)
#    @metadata[key] = {:values => [], :tagstart => tag_start, :tagend => tag_end, :filter => filter}
  end
  
  def to_xml(indent = "")
#    output = ""
#    @metadata.each do |key, element|
#      allvalues = element[:values]
#      allvalues.each do |value|
#        output = output + indent + element[:tagstart] + value + element[:tagend] + '\n'
#      end
#    end
#    output
  end
end
