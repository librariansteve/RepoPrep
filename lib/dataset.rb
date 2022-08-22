# = dataset.rb
#
# This program is free software.
# You can distribute/modify this program under the same terms as
# ruby.
#
# == class Dataset
#
# Objects of class +Dataset+ represent sets of data to be
# ingested into a repository. A +Dataset+ includes both the
# items to be ingested (e.g. images, PDFs, etc.) and the
# metadata describing the items (XML, MARC, JSON, Excel, etc.).
#
# Currently, a +Dataset+ can be in the form of a directory of
# files (+Dataset::Dir+) or a zip archive (+Dataset::Zip+).
# Other extensions may added in the future.
#
# Methods enable globbing, opening entries
# as IO streams, copying entries from one +Dataset+ to another
# +Dataset+, and renaming entries. The scope of +Dataset+
# methods is limited to files within the +Dataset+.
#
# A +Dataset+ object can be created for reading or writing.  The
# usual process is to create a read-only +Dataset+ representing
# the data as delivered, and a second read-write +Dataset+ for
# the processed data, organized and transformed as necessary
# for ingest into the local repository.
module Dataset
  def Dataset.dataset(path=nil, mode="r")
    if mode != "w"
      mode = "r"
    end
    
    if path == nil
      path = Dataset.choose_dir("Enter the path to the archive containing the dataset")
    end
    
    if path == ""
      return
    end
    
    if mode == "w" # Read-write mode
    else # Read-only mode
      if !File.exist?(path)
        raise concat("Cannot find archive at ", path)
        return
      end
    end

    ext = File.extname(path)
    if ext == ""
      Dataset::Directory.new(path, mode)
    elsif ext == '.zip'
      Dataset::Zip.new(path, mode)
    else
      raise concat("Cannot create Dataset with extension ", ext)
    end
  end
  
  # Select a directory
  def choose_dir(text = "Enter a directory path:")
    directory = entry(text)
    loop do
      if Dir.exist?(directory)
        break
      end
      directory = entry('Please enter a valid directory')
    end
    directory
  end

  # Select a file
  def choose_file(text = "Enter a file path:", ext = nil)
    file = entry(text)
    loop do
      if ext != nil and File.extname(file) == ext
        file = entry('Please enter a valid file path with extension #{ext}')
      else
        break
      end
    end
    file
  end

  class Directory
    def initialize(path, mode="r")
      @path = File.expand_path(path)

      if mode == "w"
        Dir.mkdir(@path)
      else
        mode = "r"
      end
      @mode = mode
    end

    def path
      @path
    end

    def mode
      @mode
    end

    def to_s
      "#@path"
    end

    def dirname
      File.dirname(@path)
    end

    def valid_entry?(relative_path)
      pattern = File.join(@path, "*")
      test_path = File.expand_path(relative_path, @path)
      File.fnmatch(pattern, test_path)
    end

    def glob(pattern)
      Dir.glob(pattern, base: @path)
    end

    def open_entry(entry)
      if valid_entry?(entry) == false
        return
      end
      fullpath = File.join(@path, entry)
      if Dir.exist?(fullpath)
        out = Dir.open(fullpath)
      else
        out = File.open(fullpath, @mode)
      end
      out
    end

    def copy_entry(src, dest_ds, dest)
      fullpath = File.join(@path, src)
      if Dir.exist?(fullpath)
        dest_ds.mkdir(src)
      else
        src_io = open_entry(src)
        dest_io = dest_ds.open_entry(dest)
        IO.copy_stream(src_io, dest_io)
        src_io.close
        dest_io.close
      end
    end

    def mkdir(dirname)
      fullpath = File.join(@path, dirname)
      Dir.mkdir(fullpath)
    end
  end

  class Zip
  end
end
