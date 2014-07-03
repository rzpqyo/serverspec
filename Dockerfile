FROM ubuntu:14.04

MAINTAINER rzpqyo

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN apt-get clean

RUN cd /usr/local/src && wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
RUN cd /usr/local/src && tar -zxvf ruby-2.1.2.tar.gz
RUN cd /usr/local/src/ruby-2.1.2 && ./configure && make && make install

RUN apt-get install -y zlib1g-dev openssl libssl-dev
RUN apt-get clean

RUN cd /usr/local/src/ruby-2.1.2 && make clean
RUN cd /usr/local/src/ruby-2.1.2/ext/zlib && ruby extconf.rb
RUN cd /usr/local/src/ruby-2.1.2/ext/openssl && ruby extconf.rb
RUN cd /usr/local/src/ruby-2.1.2 && ./configure && make && make install

RUN gem install serverspec

RUN apt-get install -y openssh-client
RUN apt-get clean

RUN useradd -m rzpqyo
RUN mkdir -p /home/rzpqyo/.ssh; chown rzpqyo:rzpqyo /home/rzpqyo/.ssh; chmod 700 /home/rzpqyo/.ssh
ADD ./authorized_keys /home/rzpqyo/.ssh/authorized_keys
RUN chown rzpqyo:rzpqyo /home/rzpqyo/.ssh/authorized_keys; chmod 600 /home/rzpqyo/.ssh/authorized_keys
ADD ./id_rsa /home/rzpqyo/.ssh/id_rsa
RUN chown rzpqyo:rzpqyo /home/rzpqyo/.ssh/id_rsa; chmod 600 /home/rzpqyo/.ssh/id_rsa
RUN usermod -G sudo rzpqyo

RUN mkdir -p /home/rzpqyo/work/serverspec
RUN chown rzpqyo:rzpqyo /home/rzpqyo/work/serverspec

# CMD ["/usr/sbin/sshd","-D"]
