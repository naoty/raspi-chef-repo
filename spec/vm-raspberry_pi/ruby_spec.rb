require "spec_helper"

describe file("/home/pi/.rbenv") do
  it { should be_directory }
end

describe file("/home/pi/.rbenv/plugins/ruby-build") do
  it { should be_directory }
end

describe command("cat /home/pi/.rbenv/version") do
  it { should return_stdout "2.0.0-p247" }
end

