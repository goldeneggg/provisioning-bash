provisioning-bash
==========
__provisioning-bash__ is collection of scripts for OS provisioning.

All scripts are written by `bash` so they are easy and useful for your server provisioning.


## Usage

### Manualy

```sh
# execute facade.sh with execution info
# <PLATFORM> is linux platform environment (ex. "debian", "ubuntu18" and more)
# <SCRIPT> is provisioning script file name

curl -fLsS https://git.io/fhbZl | bash -s <PLATFORM> <SCRIPT> [SOME ARGS...]
```

### Vagrant

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = '30GB'
  machines = [
    {
      hostname:  "vmubuntu14",
      ip:  "192.168.56.180",
      memory:  4096,
      cpus:  2,
      forwarded_ports:  {
      }
    }
  ]

  # Set your platform
  platform = 'ubuntu14'

  # Set your provisoners
  # - 'name' is script file name
  # - 'root' is privilege setting. if you'd like to run script as root user, set true
  # - 'args' is ARGV setting for assigned script
  provisioning_scripts = [
    { name: mysql.sh, root: true, args: [] }
  ]

  machines.each do |m|
    config.vm.define m[:hostname] do |d|
      d.vm.hostname = m[:hostname]
      d.vm.network :private_network, ip: m[:ip]

      d.vm.provider :virtualbox do |vb|
        vb.memory = m[:memory]
        vb.cpus = m[:cpus]
      end

      m[:forwarded_ports].each do |guest_port, host_port|
        d.vm.network :forwarded_port, host: host_port, guest: guest_port
      end

      # provisioning scripts
      provisioning_scripts.each do |prv|
        d.vm.provision :shell do |s|
          s.path = "https://git.io/fhbZl"
          s.args = [platform, prv["name"]] + prv["args"]
          s.privileged = prv["root"]
        end
      end
    end
  end
end
```

* This repository will be cloned on `/root/work` directory.
* Show more information -> [Shell Scripts - Provisioning - Vagrant Documentation](https://docs.vagrantup.com/v2/provisioning/shell.html)

### Docker

```dockerfile
FROM ubuntu:14.04

MAINTAINER goldeneggg

RUN mkdir /tmp/init
WORKDIR /tmp/init

# facade.sh on remote github.com is copied to local container path
ADD https://git.io/fhbZl /tmp/init/facade.sh

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
