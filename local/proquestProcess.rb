class ProquestProcess < DataProcess
  @processname = "ProQuest ETD Process"

  def run
    dir = choose_dir("enter the data directory to process:")
    input = Dataset.dataset(dir)
    outpath = File.join(input.dirname, "testout")
    output = Dataset.dataset(outpath, "w")
    input.copy_entry("ingest.rb", output, "ingest.rb")
  end
end
