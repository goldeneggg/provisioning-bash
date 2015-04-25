provisioning-bash
==========
__provisioning-bash__ is collection of scripts for OS provisioning.

All scripts are written by `bash` so they are easy and useful for your server provisioning.


## Usage (ex. Ubuntu 14)

### Manualy

* If you'd like to provision on existing server, manual operation flow is as follows.

```
# apt-get -y install git
# git clone https://github.com/goldeneggg/provisioning-bash.git

# cd provisioning-bash/ubuntu14
# bash <YOUR_TARGET_SCRIPT>.sh [ARGS]
```

### Vagrant

* If you'd like to run virtual machine using vagrant and provision by scripts, example(for MySQL slave machine) of your `Vagrantfile` is as follows.

```ruby
VAGRANTFILE_API_VERSION = "2"

# config
master_host = "192.168.56.150"
repl_pw = "p4ssword"

# machines
vmconfs = [
  {
    name: "vmubu14sla1",
    ip: "192.168.56.151",
    memory: 1024,
    cpus: 1,
    forwarded_ports: {
      13307 => 3306
    }
  }
  {
    name: "vmubu14sla2",
    ip: "192.168.56.152",
    memory: 1024,
    cpus: 1,
    forwarded_ports: {
      13308 => 3306
    }
  }
]

# inisialize slave_server_id
slave_server_id = 1

pf = "ubuntu14"
mysql_slave_provisioner = "mysql56-src-sla.sh"

provisioners = [
  {name: "init_ja.sh", root: true, args: []},
  {name: mysql_slave_provisioner, root: true, args: [slave_server_id, master_host, repl_pw]}
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu14_x86"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # vm define
  server_id = 2
  vmconfs.each do |vmconf|
    config.vm.define vmconf[:name] do |d|
      d.vm.hostname = vmconf[:name]
      d.vm.network :private_network, ip: vmconf[:ip]
      d.vm.provider :virtualbox do |vb|
        vb.memory = vmconf[:memory]
        vb.cpus = vmconf[:cpus]
      end

      vmconf[:forwarded_ports].each do |host_port, guest_port|
        d.vm.network :forwarded_port, host: host_port, guest: guest_port
      end

      # provisioning shells
      provisioners.each do |prv|
        if prv[:name] == mysql_slave_provisioner
          slave_server_id++
          prv[:args][0] = slave_server_id
        end

        d.vm.provision :shell do |s|
          s.path = "https://raw.githubusercontent.com/goldeneggg/provisioning-bash/master/facade.sh"
          s.args = [pf, prv[:name]] + prv[:args]
          s.privileged = prv[:root]
        end
      end
    end
  end
end
```

* This repository will be cloned on `/root/work` directory.
* Show more information -> [Shell Scripts - Provisioning - Vagrant Documentation](https://docs.vagrantup.com/v2/provisioning/shell.html)

### Docker

* If you'd like to run container using docker and setup by scripts, example of your `Dockerfile` is as follows.

```shell
FROM ubuntu:14.04

MAINTAINER goldeneggg

RUN mkdir /tmp/init
WORKDIR /tmp/init

# facade.sh on remote github.com is copied to local container path
ADD https://raw.githubusercontent.com/goldeneggg/provisioning-bash/master/facade.sh /tmp/init/facade.sh

# kick facade.sh by RUN task
#   1st arg: platform
#   2nd arg: script name
RUN bash facade.sh ubuntu14 init_ja.sh
```

* Show more information -> [Dockerfile - Docker Documentation](https://docs.docker.com/reference/builder/)


## Structure

* `./facade.sh` is facade script of provisioning
* `./PLATFORM` is directory of each `PLATFORM` (ubuntu14, centos7, etc...)
* `./PLATFORM/SCRIPT` is script for provisioning (ex. docker.sh, apache.sh, etc...)
* `./PLATFORM/files/SCRIPT` is directory of configuration files
    * ex. `./PLATFORM/files/SCRIPT/etc/apache2/conf/httpd.conf` is original file of `/etc/apache2/conf/httpd.conf`.
        * `./PLATFORM/files/SCRIPT` is path prefix. This file supposes that will be copied to same path of target server/container.


## License

[LICENSE](LICENSE) file for details.
