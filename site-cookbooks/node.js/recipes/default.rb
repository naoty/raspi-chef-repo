#
# Cookbook Name:: node.js
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

NODEBREW = "#{node["user"]["home"]}/.nodebrew/current/bin/nodebrew"

bash "install nodebrew" do
  user node["user"]["name"]
  group node["user"]["group"]
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    curl -L git.io/nodebrew | perl - setup
  EOC
  creates NODEBREW
end

bash "setup nodebrew" do
  user node["user"]["name"]
  group node["user"]["group"]
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bash_profile
    source ~/.bash_profile
  EOC
  not_if { File.read("#{node["user"]["home"]}/.bash_profile").include?("nodebrew") }
end

bash "install node.js" do
  user node["user"]["name"]
  group node["user"]["group"]
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    #{NODEBREW} install stable
    #{NODEBREW} use stable
  EOC
  creates "#{node["user"]["home"]}/.nodebrew/current/bin/nodebrew"
end

