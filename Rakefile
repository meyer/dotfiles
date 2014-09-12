require "rake"
require "shellwords"

class String
	def console_red; colorize(self, "\e[31m"); end
	def console_green; colorize(self, "\e[32m"); end

	def console_bold; colorize(self, "\e[1m"); end
	def console_underline; colorize(self, "\e[4m"); end

	def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end


desc "Hook our dotfiles into system-standard positions."
task :install do
	linkables = Dir.glob("*/**{.symlink}")

	skip_all = false
	overwrite_all = false
	backup_all = false

	linkables.each do |linkable|
		overwrite = false
		backup = false

		file = linkable.split('/').last.split('.symlink').last
		target = "#{ENV["HOME"]}/.#{file}"

		if File.exists?(target) || File.symlink?(target)
			unless skip_all || overwrite_all || backup_all
				puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
				case STDIN.gets.chomp
				when 'o' then overwrite = true
				when 'b' then backup = true
				when 'O' then overwrite_all = true
				when 'B' then backup_all = true
				when 'S' then skip_all = true
				when 's' then next
				end
			end
			FileUtils.rm_rf(target) if overwrite || overwrite_all
			`mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
		end
		`ln -s "$PWD/#{linkable}" "#{target}"`
	end
end

desc "Uninstall dotfiles"
task :uninstall do

	Dir.glob('**/*.symlink').each do |linkable|

		file = linkable.split('/').last.split('.symlink').last
		target = "#{ENV["HOME"]}/.#{file}"

		# Remove all symlinks created during installation
		if File.symlink?(target)
			FileUtils.rm(target)
		end

		# Replace any backups made during installation
		if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
			`mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
		end

	end
end

desc "Setup OSX prefs"
task :setup do
  abort "Please install and configure Github.app" if `which github`.chomp == ""

  begin
    print "Computer name: "
    computer_name = STDIN.gets.chomp

    raise "Nevermind." if computer_name.empty?
    puts "Setting computer name to '#{computer_name}'"

    # Set computer name (as done via System Preferences → Sharing)
    `sudo scutil --set ComputerName "#{computer_name}"`
    `sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "#{computer_name}"`

    potential_hostname = computer_name.downcase.gsub(/\W/,"")
    print "Host name [#{potential_hostname}]: "

    hostname = STDIN.gets.chomp.downcase.gsub(/\W/,"")
    hostname = potential_hostname if hostname.empty?

    puts "Setting hostname to '#{hostname}'"
    `sudo scutil --set LocalHostName #{hostname}`
    `sudo scutil --set HostName "#{hostname}.local"`
  rescue RuntimeError => e
    puts "#{e}", ""
  end

  puts "Setting defaults…"
  mac_apps = []

  Dir.chdir "./osx/"
  # Sorting will run app prefs (uppercase) first. Less than ideal.
  Dir.glob("*.sh").sort.each do |script|
    if script[0] != "_" and script[0] == script[0].upcase
      app = script[0...-3]
      mac_apps.push app
      puts " - Writing settings for #{app}"
    else
      puts " - Running #{script}"
    end
    system "bash ./#{Shellwords.escape script}"
  end

  puts

  puts "Killing affected apps…"
  mac_apps.each do |app|
    puts " - #{app}"
    system "killall '#{app}' > /dev/null 2>&1"
  end
  puts "","Done!"
end

task :default => 'install'