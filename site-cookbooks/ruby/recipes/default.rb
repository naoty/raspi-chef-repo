#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2013, Naoto Kaneko
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

RBENV_ROOT = "#{node["user"]["home"]}/.rbenv"

git RBENV_ROOT do
  repository "https://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user node["user"]["name"]
  group node["user"]["group"]
end

file "#{node["user"]["home"]}/.bash_profile" do
  owner node["user"]["name"]
  group node["user"]["group"]
  action :create_if_missing
end

bash "setup rbenv" do
  user node["user"]["name"]
  group node["user"]["group"]
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    mkdir #{RBENV_ROOT}/plugins
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
  EOC
  not_if { File.read("#{node["user"]["home"]}/.bash_profile").include?("rbenv") }
end

git "#{RBENV_ROOT}/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user node["user"]["name"]
  group node["user"]["group"]
end

%w(build-essential libreadline-dev libssl-dev).each do |pkg|
  package pkg do
    action :install
  end
end

bash "install ruby" do
  user node["user"]["name"]
  group node["user"]["group"]
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    #{RBENV_ROOT}/bin/rbenv install #{node["version"]["ruby"]}
    #{RBENV_ROOT}/bin/rbenv global #{node["version"]["ruby"]}
  EOC
  creates "#{RBENV_ROOT}/version"
  timeout 6 * 60 * 60
end

