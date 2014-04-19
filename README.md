cubbyhole
=========

[![Build
Status](https://travis-ci.org/lilfaf/cubbyhole.svg?branch=master)](https://travis-ci.org/lilfaf/cubbyhole)
[![Coverage
Status](https://coveralls.io/repos/lilfaf/cubbyhole/badge.png)](https://coveralls.io/r/lilfaf/cubbyhole)
[![Code
Climate](https://codeclimate.com/github/lilfaf/cubbyhole.png)](https://codeclimate.com/github/lilfaf/cubbyhole)

### Prerequisite

- MySQL
- Ruby > 1.9.3
- Bundler

### Usage

```bash
rspec     # run tests
rails s   # start web server
```

### Use with vagrant

First you'll need to have [Virtualbox](https://www.virtualbox.org) and [Vagrant](http://www.vagrantup.com) installed.

```bash
vagrant up
# coffee time...
vagrant ssh
cd /vagrant
rspec # run all test!
```

Then start the web server

```bash
rails s # thin
unicorn_rails # nginx + unicorn
```

Happy coding!!
