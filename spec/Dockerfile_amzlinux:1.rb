# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

Docker.validate_version!

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.get(
      ENV['DOCKER_USERNAME'] + "/" + ENV['PACKAGE'] + ":" + ENV['PACKAGE_VERSION']
    )

    # https://github.com/mizzy/specinfra
    # https://docs.docker.com/engine/api/v1.24/#31-containers
    # https://github.com/swipely/docker-api
    # https://serverspec.org/resource_types.html
    set :os, family: :redhat
    set :backend, :docker
    set :docker_image, image.id
  end

  def os_version
    command("cat /etc/system-release").stdout
  end

  def sys_user
    command("whoami").stdout.strip
  end



  it "installs the right version of Centos" do
    expect(os_version).to include("Amazon Linux AMI")
    expect(os_version).to include("2018.03")
  end

  it "runs as root user" do
    expect(sys_user).to eql("root")
  end



  # this test is a bit odd, since rvm is a Bash built-in function
  describe command('bash -l -c "rvm --version"') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '1.29.7' }
  end
  
  describe command("ruby --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '2.6.1' }
  end

  describe command("gem --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '3.0.1' }
  end

  describe command("gem list") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain 'serverspec' }
    its(:stdout) { should contain 'docker-api' }
    its(:stdout) { should contain 'infrataster' }
  end
end
