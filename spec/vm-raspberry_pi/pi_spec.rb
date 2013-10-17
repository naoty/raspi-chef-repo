require "spec_helper"

describe user("pi") do
  it { should exist }
  it { should belong_to_group("pi") }
  it { should have_home_directory("/home/pi") }
  it { should have_login_shell("/bin/bash") }
end

describe group("pi") do
  it { should exist }
end
