# RepoPrep is a complete re-write of the RepoToolkit
# which was created by Alex May.
file = File.join("..", "lib", "*.rb")
Dir.glob(file) { |f| require_relative f }

file = File.join("..", "local", "*.rb")
Dir.glob(file) { |f| require_relative f }

# $DEBUG = TRUE

def debug(message = "")
  # To enable debug statements, execute the program with the --debug option
  if $DEBUG == TRUE
    STDERR.puts "DEBUG " + caller[0] + " -- " + message
  end
end

debug("about to start")
$ui = UI.new_ui

actions = [:quit, :run, :test, :help]
loop do
  choices = ["Quit"]
  DataProcess.descendants.each {|p| choices.append(p.label)}
  choice = $ui.combobox("Which process do you want?", choices)
  if choice == 0
    break
  else
    process = DataProcess.descendants[choice - 1].new
  end
  
  puts process.label
  
  choices = ["Quit", "Run process", "Test process", "Help for process"]
  choice = $ui.combobox("Which do you want to do?", choices)
  if choice == 0
    break
  else
    action = actions[choice]
  end

  # process is an instance of a DataProcess subclass
  #
  # action is a symbol representing a method to execute
  # on the process instance
  process.send(action)
end

$ui.close
