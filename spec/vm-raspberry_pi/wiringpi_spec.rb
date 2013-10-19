require "spec_helper"

describe file("/home/pi/wiringpi") do
  it { should be_directory }
end

