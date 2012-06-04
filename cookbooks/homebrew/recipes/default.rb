#
# Cookbook Name:: homebrew
# Recipe:: homebrew
#

# HOMEBREW_DEFAULT_SHA1 = '05209f7c75f693edf23d992b5a00409520d36de2'

root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'
require 'etc'

# directory "#{ENV['HOME']}/Developer" do
#   action :create
# end
# 
# directory "#{ENV['HOME']}/Developer/tmp" do
#   action :create
# end


execute "install homebrew" do
  command "/usr/bin/ruby -e \"$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)\""
  cwd     "#{ENV['HOME']}"
  not_if  "test -e /usr/local/bin/brew"
end

homebrew "git"

# script "ensure the git remote is installed" do
#   interpreter "bash"
#   code <<-EOS
#     source ~/.mainstay/profile
#     cd ~/Developer
#     if [ ! -d ./.git ]; then
#       git init
#       git remote add origin git://github.com/mxcl/homebrew.git
#       git fetch -q origin
#       git reset --hard origin/master
#     fi
#   EOS
# end
# 
# script "updating homebrew from github" do
#   interpreter "bash"
#   code <<-EOS
#     source ~/.mainstay/profile
#     PATH=#{ENV['HOME']}/Developer/bin:$PATH; export PATH
#     (cd ~/Developer && git fetch -q origin && git reset --hard #{ENV['MAINSTAY_RELEASE'] || HOMEBREW_DEFAULT_SHA1}) >> ~/.mainstay/brew.log 2>&1
#   EOS
# end

# homebrew "nginx"
# homebrew "bash-completion"
# homebrew "solr"
