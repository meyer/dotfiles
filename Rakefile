require "rake"
require "shellwords"

DOTFILES_DIR = Dir.pwd
SYMLINK_DIR = File.expand_path "symlinks"
SETUP_DIR = File.expand_path "setup"
CONFIG_DIR = File.expand_path "config"
CONFIG_DEST = File.join ENV["HOME"], ".config"

class String
	def console_red; colorize(self, "\e[31m"); end
	def console_green; colorize(self, "\e[32m"); end

	def console_bold; colorize(self, "\e[1m"); end
	def console_underline; colorize(self, "\e[4m"); end

	def colorize(text, color_code)	"#{color_code}#{text}\e[0m" end
end

task :default => [:create_symlinks, :symlink_config_dir]

desc "Symlink config dir to #{ENV["HOME"]}/.config"
task :symlink_config_dir do
	if File.exists?(CONFIG_DEST)
		if File.symlink?(CONFIG_DEST)
			if File.identical?(CONFIG_DIR, File.readlink(CONFIG_DEST))
				puts "The symlink at #{"~/.config".console_bold} is already in place"
			else
				puts "There’s a symlink at #{"~/.config".console_bold}, but it doesn’t point to #{CONFIG_DIR}"
			end
		else
			puts "There’s something at #{"~/.config".console_bold} that isn’t a symlink. You might want to take a look."
		end
	else
		puts "Symlinked `#{CONFIG_DIR}` to `#{CONFIG_DEST}`"
		`ln -s "$PWD/config" "$HOME/.config"`
	end
end

desc "Symlink files from ./symlinks to #{ENV["HOME"]}"
task :create_symlinks do
	Dir.chdir SYMLINK_DIR

	skip_all = false
	overwrite_all = false
	backup_all = false

	Dir.glob("*.symlink").each do |linkable|
		overwrite = false
		backup = false

		filename = linkable[0...-8]
		target = File.expand_path("~/.#{filename}")

		if File.exists?(target) || File.symlink?(target)
			if File.symlink?(target)
				if File.identical?(File.readlink(target), File.expand_path(linkable))
					puts "Symlink for #{target} is already in place"
				else
					puts "Existing symlink found for #{"#{linkable}".console_bold}"
					puts " - Existing target: #{File.readlink(target)}"
					puts " - Correct target:  #{File.expand_path(linkable)}"
				end
				next
			end

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
			`mv "$HOME/.#{filename}" "$HOME/.#{filename}.backup"` if backup || backup_all
		end
		puts "Linking `./symlinks/#{linkable}` to `#{target}`"
		`ln -s "#{File.expand_path(linkable)}" "#{target}"`
	end
end

desc "Uninstall dotfiles"
task :uninstall do
	Dir.chdir SYMLINK_DIR

	Dir.glob("*.symlink").each do |linkable|

		file = linkable.split('.symlink').last
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

desc "Name yr compy"
task :name_compy do
	begin
		print "Computer name (leave empty to skip): "
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
end

desc "Run scripts that set app preferences"
task :setup do
	abort "Please install and configure Github.app" if `which github`.chomp == ""

	puts "Setting defaults…"
	mac_apps = []

	Dir.chdir SETUP_DIR
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

	puts "", "Killing affected apps…"
	mac_apps.each do |app|
		puts " - #{app}"
		system "killall '#{app}' > /dev/null 2>&1"
	end
	puts "","Done!"
end