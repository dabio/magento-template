php_config_file     = "/etc/php5/apache2/php.ini"
xdebug_config_file  = "/etc/php5/conf.d/xdebug.ini"
suhosin_config_file = "/etc/php5/conf.d/suhosin.ini"

%w{php5-cli php5-curl php5-gd php5-mcrypt php-pear php5-mysql php5-suhosin
  php5-xdebug libapache2-mod-php5}.each do |php|
  package php
end

# enable display startup errors
execute "display-startup-errors" do
  not_if "cat #{php_config_file} | grep 'display_startup_errors = On'"
  command "sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' #{php_config_file}"
end

# enable display errors
execute "display-errors" do
  not_if "cat #{php_config_file} | grep 'display_errors = On'"
  command "sed -i 's/display_errors = Off/display_errors = On/g' #{php_config_file}"
end

# enable xdebug remote
execute "xdebug-remote" do
  not_if "cat #{xdebug_config_file} | grep 'xdebug.remote_enable=On'"
  command "echo 'xdebug.remote_enable=On' >> #{xdebug_config_file}"
end

# enable xdebug remote connect back
execute "xdebug-remote-connect-back" do
  not_if "cat #{xdebug_config_file} | grep 'xdebug.remote_connect_back=On'"
  command "echo 'xdebug.remote_connect_back=On' >> #{xdebug_config_file}"
end

# whitelist phar
execute "whitelist-phar" do
  not_if "cat #{suhosin_config_file} | grep 'suhosin.executor.include.whitelist=phar'"
  command "echo 'suhosin.executor.include.whitelist=phar' >> #{suhosin_config_file}"
end


# update pear
execute "pear-upgrade" do
  command "pear upgrade"
end

# pear enable auto discover
execute "pear-autodiscover" do
  command "pear config-set auto_discover 1 system"
  not_if "pear config-get auto_discover system | grep 1"
end

# install phing
execute "pear channel-discover pear.phing.info" do
  not_if "pear list-channels | grep pear.phing.info"
end
execute "pear install phing/phing" do
  not_if "pear list -c phing | grep '^phing '"
end

# install pear git
execute "pear install VersionControl_Git-alpha" do
  not_if "pear info VersionControl_Git"
end

# install composer
execute "curl -sS https://getcomposer.org/installer | php" do
  not_if "test -d /home/vagrant/.composer"
end

# install n89
execute "curl https://raw.github.com/netz98/n98-magerun/master/n98-magerun.phar > /usr/local/bin/n98.phar && chmod +x /usr/local/bin/n98.phar" do
  not_if "test -f /usr/local/bin/n98.phar"
end

service "apache2" do
  action :reload
end
