#
# Cookbook Name:: bookrenter
# Recipe:: nginx_and_passenger
#
# root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))
# require root + '/resources/homebrew'
# require root + '/providers/homebrew'
# require 'etc'

nginx_conf_path = "#{ENV['HOME']}/Developer/etc/nginx"
nginx_logs_path = "#{ENV['HOME']}/Developer/var/log/nginx"

script "create and set the rails3 gemset as the default" do
  interpreter "bash"
  code <<-EOS
    rvm --create ree@rails3
    rvm use ree@rails3 --default
  EOS
end

script "installing passenger" do
  interpreter "bash"
  code <<-EOS
    rvm ree@rails3 gem install passenger -v=3.0.9
  EOS
  not_if "rvm ree@rails3 gem list passenger | grep -q \"3.0.9\""
end

script "installing nginx" do
 interpreter "bash"
 code <<-EOS
   echo "I'm INSTALLING nginx"
   brew install nginx --with-passenger
 EOS
 not_if do
   current_nginx_version = `#{ENV['HOME']}/Developer/sbin/nginx -V 2>&1`
   current_nginx_version =~ /1\.0\.11/ ? true : false
 end
 
end

script "adding local.bookrenter apps to /etc/hosts" do
  interpreter "bash"
  code <<-EOS
    echo "127.0.0.1 local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
    echo "127.0.0.1 ops.local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
    echo "127.0.0.1 cart.local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
    echo "127.0.0.1 store.local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
    echo "127.0.0.1 stores.local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
    echo "127.0.0.1 bws.local.bookrenter.com" | sudo tee -a /etc/hosts > /dev/null
  EOS
  not_if "cat /etc/hosts | grep local.bookrenter.com"
end  

# system("mkdir -p #{ENV['HOME']}/Library/LaunchAgents")
# system("launchctl unload -w -F #{destination_plist} >/dev/null 2>&1")
# system("cp -f #{plist_fullpath_for(name)} #{destination_plist} >/dev/null 2>&1")
# system("launchctl load -w -F #{destination_plist} >/dev/null 2>&1")

# 
# You can start nginx automatically on login running as your user with:
#   mkdir -p ~/Library/LaunchAgents
#   cp /Users/cameron/Developer/Cellar/nginx/1.0.6/org.nginx.nginx.plist ~/Library/LaunchAgents/
#   launchctl load -w ~/Library/LaunchAgents/org.nginx.nginx.plist

directory "#{nginx_conf_path}/certs" do
  action :create
end

directory "#{nginx_conf_path}/sites-available" do
  action :create
end

directory "#{nginx_logs_path}" do
  action :create
end

template "#{nginx_conf_path}/nginx.conf" do
  mode   0644
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "nginx.conf.erb"
  variables({
    :home => ENV['HOME'],
  })
end

template "#{nginx_conf_path}/stack.conf" do
  mode   0644
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "stack.conf.erb"
  variables({
    :home => ENV['HOME'],
  })
end

template "#{nginx_conf_path}/certs/wildcard.local.bookrenter.com.crt" do
  mode   0644
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "wildcard.local.bookrenter.com.crt.erb"
  variables({
    :home => ENV['HOME'],
  })
end

template "#{nginx_conf_path}/certs/wildcard.local.bookrenter.com.key" do
  mode   0644
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "wildcard.local.bookrenter.com.key.erb"
  variables({
    :home => ENV['HOME'],
  })
end


%w{bws cart ops store_control_panel}.each do |site|
  template "#{nginx_conf_path}/sites-available/#{site}.conf" do
    mode   0644
    owner  ENV['USER']
    group  Etc.getgrgid(Process.gid).name
    source "site.conf.erb"
    variables({
      :home => ENV['HOME'],
      :site => site,
      :nginx_conf_path => nginx_conf_path,
      :nginx_logs_path => nginx_logs_path
    })
  end
end


