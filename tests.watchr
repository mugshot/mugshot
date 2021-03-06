# -*- encoding: utf-8 -*-
def notify(kind, msg)
  title = kind == :pass ? "Yeah!" : "Fail!"
  
  if RUBY_PLATFORM =~ /darwin/ # OSX
    system "growlnotify -m #{msg.inspect} -t #{title.inspect}"
  elsif RUBY_PLATFORM =~ /linux/ # Linux
    require 'libnotify'
    Libnotify.show(:body => title, :summary => msg, :timeout => 2.5)
  end
end

def run(cmd, clear = false)
  system("clear") if clear
  pass = system(cmd)

  should_run_all = $was_failure && pass

  if pass
    $was_failure = false
    notify(:pass, "O Cirne agradece.")
  else
    $was_failure = true
    notify(:fail, "http://www.aiqueburro.com")
  end

  if should_run_all
    run_all
  end
end

def run_feature(file, clear = false)
  run "cucumber #{file}", :clear
end

def run_test_file(file, clear = false)
  run "rspec #{file}", clear
end

def run_all_features(clear = false)
  run "cucumber", clear
end

def run_all(clear = false)
  run "rake", clear
end

def related_test_files(path)
  Dir['spec/**/*.rb'].select{|file| file =~ /#{File.basename(path, ".rb")}_spec/ }
end

# features
watch('features/.*\.feature'){|m| run_feature(m[0], :clear) }
watch('features/support/.*'){ run_all_features(:clear) }
watch('features/step_definitions/.*\.rb'){ run_all_features(:clear) }

# specs
watch('spec/spec_helper\.rb'){ run_all(:clear) }
watch('spec/.*/.*_spec\.rb'){|m| run_test_file(m[0], :clear) }

# lib
watch('lib/.*\.rb'){|m| puts m; related_test_files(m[0]).each{|file| run_test_file(file, :clear) }}

# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }
