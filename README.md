# Magento Skeleton

This repository gives you a staring point for new magento shops. It uses
[vagrant](http://www.vagrantup.com/) for your virtual machine,
[n98-magerun](http://netz98.github.io/n98-magerun/) to install magento and
[composer](http://getcomposer.org/) as the dependency management tool.

## Installation

Vagrant and Virtual Box are both recommend to use this skeleton. Install them
and start with the following commands:

```bash
vagrant up
vagrant ssh
cd /vagrant
n98.phar install
```

Enter the credentials to the database connections. The default database name is
"magento", the username "root" and the password "dev". You can choose the base
url as long as it has the port :8080 and you modified your hosts-file according
to the choosen url.

## Example

Find in example/modules/ customized xml settings to use a basic shop without
any third party modules and dependencies.
