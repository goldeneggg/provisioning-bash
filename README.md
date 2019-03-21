provisioning-bash
==========
__provisioning-bash__ is collection of scripts for OS provisioning.

All scripts are written by `bash` so they are easy and useful for your server provisioning.


## Usage

### Manualy

```sh
# <PLATFORM> is linux platform environment (ex. "debian", "ubuntu18" and more)
# <SCRIPT> is provisioning script file name

curl -fLsS https://git.io/prv-bash | bash -s <PLATFORM> <SCRIPT> [SOME ARGS...]
```

### Docker

```dockerfile
FROM ubuntu:18.04

MAINTAINER goldeneggg

RUN mkdir /tmp/prv-bash
WORKDIR /tmp/prv-bash

# entry.sh on remote github.com is copied to local container path
ADD https://git.io/prv-bash /tmp/prv-bash/entry.sh

# kick entry.sh
#   1st arg: platform
#   2nd arg: script name
RUN bash entry.sh ubuntu18 init.sh
```

* Show more information -> [Dockerfile - Docker Documentation](https://docs.docker.com/reference/builder/)

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

### EC2 user-data

EC2 [user-data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) for Amazon Linux 2 as follows:

(original file is [here](https://github.com/goldeneggg/provisioning-bash/blob/master/amazon2/user-data.sh))

```sh
#!/bin/bash

WORKDIR=/tmp/work
ROOT_WORKDIR=/tmp/root_work
ENTRY=entry.sh

# "amazon1" or "amazon2"
PLATFORM=amazon2

# assign your provisioning scripts for root user into ROOT_TARGETS variable
ROOT_TARGETS=("init.sh")

if [ ${#ROOT_TARGETS[@]} -ne 0 ]
then
  echo "ROOT_TARGETS=${ROOT_TARGETS}"
  sudo mkdir -p ${ROOT_WORKDIR}
  sudo curl -fLsS https://git.io/prv-bash -o ${ROOT_WORKDIR}/${ENTRY}
  sudo chmod +x ${ROOT_WORKDIR}/${ENTRY}

  for t in ${ROOT_TARGETS[@]}
  do
    echo "Run ${t} by root"
    sudo bash ${ROOT_WORKDIR}/${ENTRY} ${PLATFORM} ${t}
  done
fi

# assign your provisioning scripts for general user into TARGETS variable
TARGETS=()

if [ ${#TARGETS[@]} -ne 0 ]
then
  echo "TARGETS=${TARGETS}"
  mkdir -p ${WORKDIR}
  curl -fLsS https://git.io/prv-bash -o ${WORKDIR}/${ENTRY}
  chmod +x ${WORKDIR}/${ENTRY}

  for t in ${TARGETS[@]}
  do
    echo "Run {t} by user"
    bash ${WORKDIR}/${ENTRY} ${PLATFORM} ${t}
  done
fi
```

## Structure

* `./facade.sh` is facade script of provisioning
* `./PLATFORM` is directory of each `PLATFORM` (ubuntu14, centos7, etc...)
* `./PLATFORM/SCRIPT` is script for provisioning (ex. docker.sh, apache.sh, etc...)
* `./PLATFORM/files/SCRIPT` is directory of configuration files
    * ex. `./PLATFORM/files/SCRIPT/etc/apache2/conf/httpd.conf` is original file of `/etc/apache2/conf/httpd.conf`.
        * `./PLATFORM/files/SCRIPT` is path prefix. This file supposes that will be copied to same path of target server/container.


## License

[LICENSE](LICENSE) file for details.
