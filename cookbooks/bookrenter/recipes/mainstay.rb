#
# Cookbook Name:: bookrenter
# Recipe:: mainstay
#
# require 'etc'


directory "#{ENV['HOME']}/.mainstay" do
  action :create
end

template "#{ENV['HOME']}/.mainstay/profile" do
  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.profile.erb"
  variables({ :home => ENV['HOME'] })
end

%w(bash_profile bashrc zshrc).each do |config_file|
  execute "include mainstay environment into defaults for ~/.#{config_file}" do
    command "if [ -f ~/.#{config_file} ]; then echo 'source ~/.mainstay/profile' >> ~/.#{config_file}; fi"
    not_if  "grep -q 'mainstay/profile' ~/.#{config_file}"
  end
end

execute "setup mainstay profile sourcing in ~/.profile" do
  command "echo 'source ~/.mainstay/profile' >> ~/.profile"
  not_if  "grep -q 'mainstay/profile' ~/.profile"
end

