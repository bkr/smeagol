#
# Cookbook Name:: bookrenter
# Recipe:: default
#
# root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))
# require root + '/resources/homebrew'
# require root + '/providers/homebrew'
# require 'etc'

# TODO
# rvm gemset rails3 as --default for ree
# install bundler v1.0.10
# bundle install
# Check out the correct branch (dev) for your main checkout
# Set more of the .git config variables for nicer output
# Set local mysql root password?
# Set up local users for mysql -grant all privileges on *.* to br_db_user@localhost identified by 'br_db_pass' with grant option;
# rake db:create:all
# 

directory "#{ENV['HOME']}/Code" do
  action :create
end

execute "checkout the core bookrenter code" do
  command "git clone git@github.com:bkr/main.git"
  cwd     "#{ENV['HOME']}/Code"
  not_if  "test -e #{ENV['HOME']}/Code/main/changelog.txt"
end


