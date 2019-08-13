# spec/Dockerfile_spec.rb

require_relative "spec_helper"

describe "Dockerfile" do
  before(:all) do
    load_docker_image()
    set :os, family: :debian
  end

  describe "Dockerfile#running" do
    it "runs the right version of Debian" do
      expect(os_version).to include("Debian")
      expect(os_version).to include("GNU/Linux 9")
    end
    it "runs as root user" do
      expect(sys_user).to eql("root")
    end
  end

  # this test is a bit odd, since rvm is a Bash built-in function
  describe command('bash -l -c "rvm --version"') do
    its(:exit_status) { should eq 0 }
  end
  
  describe command("ruby --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain ENV['PACKAGE_VERSION'] }
  end

  describe command("gem --version") do
    its(:exit_status) { should eq 0 }
  end

  describe command("gem list") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain 'serverspec' }
    its(:stdout) { should contain 'docker-api' }
    its(:stdout) { should contain 'infrataster' }
  end
end
