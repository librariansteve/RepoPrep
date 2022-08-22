# = ui.rb
#
# module UI
#
# The UI module provides the user interface for the program.
module UI

  # Options: none
  #
  # Tries to determine which user interface to provide:
  # +UI::TextUI+ (in the system command console)
  # or +UI::TkUI+ (a graphical interface using Tk).
  def UI.new_ui
    TextUI.new
  end

  # == class TextUI
  #
  # A command-line interface in the console
  # This should be kept platform-independant
  class TextUI
    def initialize
      @prompt = 'RP> '

      welcome = "\n***************************************************\n"
      welcome = welcome + "Welcome to the Repository Preprocessing toolkit"
      welcome = welcome + "\n***************************************************\n"
      splash(welcome)
    end
    
    def splash(text, duration=3)
      puts text
      sleep(duration)
    end
    
    def message(text)
      puts text      
    end

    def entry(text, prompt=@prompt)
      if text.length > 0
        puts text
      end
      print prompt
      STDIN.gets.chomp.strip
    end
    
    def combobox(text, choices)
      puts
      puts text
      puts
      choices.each {|i| puts "  *  " + i.to_s}
      puts
      choice = entry("Please enter at least the first few letters of your choice:")
      while true
        i = 0
        while i < choices.length
          if choice.length > 0 and choices[i].to_s.downcase.start_with?(choice.downcase)
            return i
          end
          i = i + 1
        end
        choice = entry('', "Try again> ")
      end
    end

    # Select a file
    def choose_file(text = "Enter a file path:", ext = nil)
      puts
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

    # Send a closing message
    def close
      splash("\n\nGoodbye")
    end
  end

  class TkUI
  end
end