# To change docker image name or jenkins port pass below arguments
# e.g. make install-fuego-docker NAME="fuego-buster" PORT=8091
NAME?=fuego
PORT?=8090
DEBIAN_VERSION?=stretch

# To Change Jenkins version
JENKINS_VERSION?=2.249.3
JENKINS_SHA?=534014c007edbb533a1833fe6f2dc115faf3faa2

# for nocache and privilage options to docker image pass as argument
# e.g. make install-fuego-docker EXTRA="--nocache --priv"
EXTRA?=

# Install fuego on Docker
install-fuego-docker:
	./install.sh $(NAME) $(PORT) $(DEBIAN_VERSION) $(EXTRA)

install-fuego-docker-nojenkins:
	make install-fuego-docker EXTRA="--nojenkins $(EXTRA)"

install-fuego-docker-buster:
	make install-fuego-docker DEBIAN_VERSION=buster EXTRA=$(EXTRA)

install-fuego-docker-buster-nojenkins:
	make install-fuego-docker-buster EXTRA="--nojenkins $(EXTRA)"

# Start fuego on docker
run-fuego-docker:
	./start.sh $(NAME)-container

# Install fuego on native machine
install-fuego-native:
	sudo ./install-native.sh -s $(DEBIAN_VERSION) -p $(PORT) $(EXTRA)

install-fuego-native-nojenkins:
	make install-fuego-native EXTRA="--nojenkins $(EXTRA)"

install-fuego-native-buster:
	make install-fuego-native DEBIAN_VERSION=buster EXTRA="$(EXTRA)"

install-fuego-native-buster-nojenkins:
	make install-fuego-native-buster EXTRA="--nojenkins $(EXTRA)"
