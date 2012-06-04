#
# Cookbook Name:: oh-my-zsh
# Recipe:: default
#

directory "#{ENV['HOME']}/.mainstay" do
  action :create
end

script "oh-my-zsh install from github" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  EOS
  not_if  "test -e ~/.oh-my-zsh"
end
