require 'rake'
require 'fileutils'
require 'shellwords'
require 'yaml'

DOTFILES_DIR = Dir.pwd
SYMLINK_DIR = File.expand_path('symlinks')
SETUP_DIR = File.expand_path('setup')

# nice exit message
def byeee; puts "\n---\ntake care out there \u{1f44b}"; abort; end
%w(INT TERM).each {|s| trap(s){byeee}}

class String
  def console_red; colorise(self, "\e[31m"); end
  def console_green; colorise(self, "\e[32m"); end
  def console_grey; colorise(self, "\e[30m"); end
  def console_bold; colorise(self, "\e[1m"); end
  def console_underline; colorise(self, "\e[4m"); end
  def colorise(text, color_code)  "#{color_code}#{text}\e[0m" end
  def comment_out; indent(self, "# ").console_grey; end
  def indent(t,p); t.split("\n").map {|s| p+s}.join("\n"); end
  def indent_timestamp; indent(self, "[#{Time.now.strftime("%H:%M:%S.%L")}] "); end
end

# Get list of dotfiles, prune dead links
def get_dotfile_list(quiet=true)
  Dir.chdir(Dir.home)

  # .??* excludes . and ..
  Dir.glob('.??*').reject do |f|
    type = File.ftype(f)
    puts File.expand_path(f).console_underline unless quiet
    if type === 'link' && !File.exist?(File.readlink(f))
      puts "Deleting #{f} (broken link)" unless quiet
      FileUtils.rm_f(f)
      true
    else
      puts "#{f} (#{type})" unless quiet
      false
    end
  end
end

def get_symlink_list(quiet=true, interactive=false)
  Dir.chdir(SYMLINK_DIR)
  Dir.glob('**/*.symlink').map do |f|
    puts '', f.console_underline

    symlink_src = File.expand_path(f)
    dest_path = ".#{f.sub(/.symlink$/, '')}"
    symlink_dest = File.join(Dir.home, dest_path)

    subdir = File.dirname(dest_path)
    subdir = nil if subdir === '.'

    src_type = File.ftype(symlink_src)
    installed = false

    puts "Symlink src:  #{symlink_src} (#{src_type})"
    puts "Symlink dest: #{symlink_dest}"

    # Check to see if anything in subdir is a symlink
    if subdir
      subdir_bits = subdir.split('/')
      subdir_bits.map!.with_index {|k,i| subdir_bits[0..i].join('/')}

      symlink_err = catch(:symlink_in_path) do
        subdir_bits.each do |b|
          p = File.join(Dir.home, b)
          if File.symlink?(p)
            throw(:symlink_in_path, "Symlink '#{b}' exists in path '#{symlink_dest}'")
          end
        end
        nil
      end

      if symlink_err
        puts symlink_err.console_red
        next
      end
    end

    if File.exist?(symlink_dest) or File.symlink?(symlink_dest)
      dest_type = File.ftype(symlink_dest)
      case dest_type
      when 'link'
        expanded_link = File.readlink(symlink_dest)
        if expanded_link === symlink_src
          puts "A symlink for '#{f}' is already in place. Neat!".console_green
          installed = true
        # File.exist? returns false for broken symlinks
        elsif !File.exist?(symlink_dest)
          puts "A broken link was found at '#{symlink_dest}' (links to '#{expanded_link}')"
          puts "Ignoring...".console_red
          # puts "...aaaaand now it's gone".comment_out
          # FileUtils.rm_f(symlink_dest)
          next
        else
          puts "A symlink to something else is already in place (#{expanded_link})".console_red
          if interactive
            print "Your options: [i]gnore it (default), [d]elete the link: "
            case $stdin.gets.chomp.downcase
            when '', 'i'
              puts 'Ignoring...'
              next
            when 'd'
              FileUtils.rm_f(symlink_dest)
            end
          else
            puts 'Ignoring...'
            next
          end
        end
      when 'file', 'directory'
        puts "Hmm, a #{dest_type} already exists at #{symlink_dest}".console_red

        if interactive
          print "Your options: [i]gnore it (default), [m]ove the #{dest_type}: "
          case $stdin.gets.chomp.downcase
          when '', 'i'
            puts 'Ignoring...'
            next
          when 'm'
            dirname = File.join(File.dirname(symlink_dest), '/')
            print "Move it to: #{dirname}"
            new_file_name = $stdin.gets.chomp.downcase
            if new_file_name === ''
              puts 'Ok, nevermind.'
              next
            end
            puts "Moving #{dest_type} to #{File.join(dirname, new_file_name)}"
            FileUtils.mv(symlink_dest, File.join(dirname, new_file_name))
          end
        else
          puts 'Ignoring...'.console_red
          next
        end
      else
        puts "What exactly is a '#{dest_type}'...?".console_red
        next
      end
    else
      puts 'No objections here'.console_green
    end
    {
      'src' => symlink_src,
      'dest' => symlink_dest,
      'type' => src_type,
      'subdir' => subdir,
      'installed' => installed,
    }
  end.compact
end

namespace :test do
  task :get_symlink_list do; get_symlink_list(false, true); end
end

desc 'Install dat symlinks'
task :install_symlinks, [:interactive] do |t, args|
  args.with_defaults(:interactive => false)

  symlinks = get_symlink_list(true, !!args[:interactive]).reject do |link|
    unless link['installed'] === true
      if link['subdir']
        puts "Making subdirectory '#{link['subdir']}'"
        FileUtils.mkdir_p(link['subdir'])
      end
      puts "Linking '#{link['src']}' to '#{link['dest']}'"
      `ln -s #{link['src'].shellescape} #{link['dest'].shellescape}`
      false
    else
      true
    end
  end

  puts

  if symlinks.length === 0
    puts "Nothing to install, doggggg."
  else
    puts "Installed #{symlinks.length} symlink#{symlinks.length === 1 ? '' : 's'}."
  end
end

task :uninstall_symlinks do
  dotfiles = get_dotfile_list.reject do |f|
    link_src = File.realpath(f)
    link_dest = File.expand_path(f)
    if File.ftype(f) === 'link' && link_src.start_with?(DOTFILES_DIR)
      puts "Deleting #{link_dest}"
      FileUtils.rm_f(link_dest)
      false
    else
      true
    end
  end

  symlinks = get_symlink_list(true).reject do |f|
    if f['installed']
      FileUtils.rm_f(f['dest'])
      puts "Deleting #{f['dest']}"
      false
    else
      true
    end
  end

  puts

  if (dotfiles + symlinks).length === 0
    puts "Nothing to uninstall, doggggg."
  else
    puts "Uninstalled #{symlinks.length} symlink#{symlinks.length === 1 ? '' : 's'}."
  end
end

task :prune do; get_dotfile_list; end

desc "Run scripts that set app preferences"
task :setup do
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
