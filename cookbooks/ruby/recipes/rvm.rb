#
# Cookbook Name:: ruby
# Recipe:: rvm
#

DEFAULT_RUBY_VERSION = "1.9.3"
# 
# if DEFAULT_RUBY_VERSION.match('ree')
#   puts 'looks like we are using REE hopefully in Lion, which needs this'
#   GCC_OVERRIDE = 'export CC=/usr/bin/gcc-4.2' 
# else
#   puts "looks like we are NOT using REE"
#   GCC_OVERRIDE = ''
# end
# 

# template "#{ENV['HOME']}/.rvmrc" do
#   mode   0700
#   owner  ENV['USER']
#   group  Etc.getgrgid(Process.gid).name
#   source "dot.rvmrc.erb"
#   variables({ :home => ENV['HOME'] })
# end

script "installing rvm to ~/.rvm" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    curl -L get.rvm.io | bash -s stable
  EOS
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    rvm get stable >> ~/.mainstay/ruby.log 2>&1
  EOS
end

script "installing ruby" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    `rvm list | grep -q '#{DEFAULT_RUBY_VERSION}'`
    if [ $? -ne 0 ]; then
      rvm install #{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

script "ensuring a default ruby is set" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    `which ruby | grep -q rvm`
    if [ $? -ne 0 ]; then
      rvm use #{DEFAULT_RUBY_VERSION} --default
    fi
  EOS
end
# 
# directory "#{ENV['HOME']}/.rvm/gemsets" do
#   action 'create'
# end


template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end


template "#{ENV['HOME']}/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
end

script "ensuring default rubygems are installed" do
  interpreter "bash"
  code <<-EOS
    source ~/.mainstay/profile
    rvm gemset load ~/.rvm/gemsets/default.gems >> ~/.mainstay/ruby.log 2>&1
  EOS
end
# 
# execute "cleanup rvm build artifacts" do
#   command "find ~/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
# end
# 
# template "#{ENV['HOME']}/.rdebugrc" do
#     source "dot.rdebugrc.erb"
# end
