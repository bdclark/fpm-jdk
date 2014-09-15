Vagrant.configure("2") do |config|

  config.vm.synced_folder 'pkg', '/vagrant'

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.subnet_id = 'subnet-f48e4b83'
    aws.security_groups = ['sg-3fa2125a']
    aws.keypair_name = ENV['AWS_SSH_KEY_ID']
    aws.associate_public_ip = true
    aws.instance_type = 't2.micro'
    aws.ami = 'ami-76817c1e'

    override.ssh.username = 'ec2-user'
    override.ssh.private_key_path = ENV['AWS_SSH_KEY_PATH']
    override.ssh.pty = true
  end

  config.vm.define 'centos' do |centos|
    centos.vm.box = 'baremettle/centos-6.5'
  end

  config.vm.define 'amazon', autostart: false do |amazon|
    amazon.vm.box = 'dummy'
  end

end
