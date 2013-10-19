require "spec_helper"

describe file("/home/pi/mjpg-streamer") do
  it { should be_directory }
end

describe file("/home/pi/mjpg-streamer/mjpg-streamer-experimental/run.sh") do
  it { should be_file }
end
