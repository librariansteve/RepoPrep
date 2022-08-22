class DataProcess
  @@descendants = []

  def self.inherited(subclass)
    @@descendants << subclass
  end

  def self.descendants
    @@descendants
  end

  def self.label
    if @processname == nil
      self.to_s
    else
      @processname
    end
  end

  def label
    if @processname == nil
      self.class.to_s
    else
      @processname
    end
  end

  def help
    puts '  ** No documentation defined for ' + self.class.to_s + ' **'
  end

  def test
    puts '  ** No test defined for ' + self.class.to_s + ' **'
  end

  def run
    puts '  ** No ingest routine defined for ' + self.class.to_s + ' **'
  end
end
