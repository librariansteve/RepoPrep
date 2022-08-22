require 'nokogiri'

class SpringerProcess < DataProcess
  @processname = "Springer OA Article Process"

  def run
    dir = $ui.choose_file("Enter the data directory to process:")
    input = Dataset.dataset(dir)
    outpath = File.join(input.dirname, "testout")
    output = Dataset.dataset(outpath, "w")

    parser = Nokogiri::XML::SAX::Parser.new(SpringerFilter.new)
    
    files = input.glob("**/*.xml.Meta")    
#    puts files
#    files.each {|f| input.copy_entry(f, output, f)}

    for f in files do
      parser.parse(open_entry(f))
    end
    
  end
end

class SpringerFilter < Nokogiri::XML::SAX::Document
  def start_document
  end
  
  def start_element(name, attrs = [])
    @last_seen_tag = name
  end
  
  def characters(string)
    case @last_seen_tag
      when 'ArticleTitle' then @title << string
    end
  end
  
  def end_element(name)
    @last_seen_tag = nil
  end
  
  def end_document
    puts 'title: ' + @title
    @title = nil
  end
end
