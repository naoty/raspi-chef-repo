#
# Cookbook Name:: open_jtalk
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

# Prepare directories
%w(download build).each do |dirname|
  directory File.join(node["user"]["home"], dirname) do
    owner node["user"]["name"]
    group node["user"]["group"]
    action :create
  end
end

# Download sources
%w(
  http://downloads.sourceforge.net/hts-engine/hts_engine_API-1.07.tar.gz
  http://downloads.sourceforge.net/open-jtalk/open_jtalk-1.06.tar.gz
  http://downloads.sourceforge.net/open-jtalk/open_jtalk_dic_utf_8-1.06.tar.gz
  http://joruri.org/download/joruri-2.0.1.tar.gz
).each do |source|
  basename = File.basename(source)
  source_name = File.basename(source, ".tar.gz")
  cwd = File.join(node["user"]["home"], "download")

  bash "Install #{source_name}" do
    user node["user"]["name"]
    group node["user"]["group"]
    cwd cwd
    code <<-EOC
      wget #{source}
    EOC
    creates File.join(cwd, basename)
  end
end

# Build sources
bash "Build hts_engine API" do
  user node["user"]["name"]
  group node["user"]["group"]
  cwd File.join(node["user"]["home"], "build")
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    tar xvf ~/download/hts_engine_API-1.07.tar.gz
    cd hts_engine_API-1.07
    ./configure
    make
  EOC
end

bash "Build open jtalk" do
  user node["user"]["name"]
  group node["user"]["group"]
  cwd File.join(node["user"]["home"], "build")
  environment "HOME" => node["user"]["home"]
  code <<-EOC
    tar xvf ~/download/open_jtalk-1.06.tar.gz
    cd open_jtalk-1.06
    ./configure \
      --with-charset=utf-8 \
      --with-hts-engine-header-path=$HOME/build/hts_engine_API-1.07/include \
      --with-hts-engine-library-path=$HOME/build/hts_engine_API-1.07/lib
    make
  EOC
end

%w(open_jtalk_dic_utf_8-1.06.tar.gz joruri-2.0.1.tar.gz).each do |source|
  source_name = File.basename(source, ".tar.gz")
  bash "Untar #{source_name}" do
    user node["user"]["name"]
    group node["user"]["group"]
    cwd File.join(node["user"]["home"], "build")
    environment "HOME" => node["user"]["home"]
    code <<-EOC
      tar xvf ~/download/#{source}
    EOC
  end
end

