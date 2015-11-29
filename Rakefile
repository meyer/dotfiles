require "rake"
require "shellwords"

DOTFILES_DIR = Dir.pwd
SYMLINK_DIR = File.expand_path "symlinks"
SETUP_DIR = File.expand_path "setup"
CONFIG_DIR = File.expand_path "config"
CONFIG_DEST = File.join ENV["HOME"], ".config"

# nice exit message
def byeee; puts "\n---\ntake care out there \u{1f44b}"; abort; end
%w(INT TERM).each {|s| trap(s){byeee}}

class String
	def console_red; colorize(self, "\e[31m"); end
	def console_green; colorize(self, "\e[32m"); end

	def console_bold; colorize(self, "\e[1m"); end
	def console_underline; colorize(self, "\e[4m"); end

	def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end

def mksymlink(symlink_src)
	overwrite = false
	backup = false

	basename = File.basename(symlink_src, ".symlink")
	symlink_dest = File.expand_path("~/.#{basename}")

	if File.exists?(symlink_dest) || File.symlink?(symlink_dest)
		if File.symlink?(symlink_dest)
			if File.identical?(File.readlink(symlink_dest), File.expand_path(symlink_src))
				puts "Symlink for #{symlink_dest} is already in place"
			else
				puts "Existing symlink found for #{"#{symlink_src}".console_bold}"
				puts " - Existing symlink dest: #{File.readlink(symlink_dest)}"
				puts " - Correct symlink dest:  #{File.expand_path(symlink_src)}"
			end
			return
		end

		puts "File already exists: #{symlink_dest}, what do you want to do? [s]kip, [o]verwrite, [b]ackup"
		case STDIN.gets.chomp
		when 'o' then overwrite = true
		when 'b' then backup = true
		when 's', '' then return
		end

		FileUtils.rm_rf(symlink_dest) if overwrite
		`mv "$HOME/.#{basename}" "$HOME/.#{basename}.backup"` if backup
	end
	puts "Linking `./symlinks/#{basename}.symlink` to `#{symlink_dest}`"
	`ln -s "#{File.expand_path(symlink_src)}" "#{symlink_dest}"`
end

task :default => [:create_symlinks, :symlink_config_dir]

desc "Symlink config dir to ~/.config"
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
		`ln -s "#{CONFIG_DIR}" "$HOME/.config"`
	end
end

desc "Symlink files from ./symlinks to your home folder"
task :create_symlinks do
	Dir.chdir SYMLINK_DIR
	Dir.glob("*.symlink").each {|linkable| mksymlink(linkable)}
end

desc "Uninstall dotfiles"
task :uninstall do
	Dir.chdir SYMLINK_DIR
	Dir.glob("*.symlink").each do |linkable|
		file = File.basename(linkable, '.symlink')
		target = File.expand_path("~/.#{file}")
		backup = "#{target}.backup"

		# Remove all symlinks created during installation
		FileUtils.rm(target) if File.symlink?(target)

		# Replace any backups made during installation
		FileUtils.mv(backup, target) if File.exists?(backup)
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

desc "Make a new symlink file and symlink it"
task :mksymlink do
	Dir.chdir SYMLINK_DIR

	print "What should your symlinked file be called? ~/."
	symlink_basename = STDIN.gets.chomp

	raise 'nevermind' if symlink_basename == ''

	symlink_src = File.join(SYMLINK_DIR, "#{symlink_basename}.symlink")

	puts "Creating file at #{symlink_src}"
	FileUtils.touch symlink_src

	mksymlink(symlink_src)
end

desc "Delete a symlink in yr home folder" # hmmmmmm
task :rmsymlink do
	Dir.chdir SYMLINK_DIR

	print "What symlinked is being removed? ~/."
	symlink_basename = STDIN.gets.chomp

	raise 'nevermind' if symlink_basename == ''

	symlink_file = File.expand_path("~/.#{symlink_basename}")
	raise "um, #{symlink_file} isn't even a real file" unless File.exists?(symlink_file)
	raise "#{symlink_file} is not a symlink" unless File.symlink?(symlink_file)

	puts "#{symlink_file} resolves to #{File.readlink(symlink_file)}"
	print "Delete #{File.basename(symlink_file)}? (y/N): "
	raise "ok byeee" if STDIN.gets.chomp.downcase != 'y'
	FileUtils.rm_rf(symlink_file)
	puts "#{symlink_file} deleted!"
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
