require "spec_helper"

describe file("/home/pi/.nodebrew") do
  it { should be_directory }
end

describe file("/home/pi/.nodebrew/current") do
  it { should be_directory }
end

