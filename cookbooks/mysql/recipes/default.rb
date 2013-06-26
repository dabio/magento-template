mysql_root_pwd    = "dev"
mysql_default_db  = "magento"
mysql_config_file = "/etc/mysql/my.cnf"

package "mysql-server"

service "mysql" do
  service_name "mysql"

  supports [:restart, :reload, :status]
  action :enable
end

# set the root password
execute "assign-root-password" do
  command "/usr/bin/mysqladmin -uroot password #{mysql_root_pwd}"
  not_if "/usr/bin/mysqladmin -uroot -p#{mysql_root_pwd} status"
end

# create the default database
execute "create-default-database" do
  command "/usr/bin/mysql -uroot -p#{mysql_root_pwd} -e 'CREATE DATABASE IF NOT EXISTS #{mysql_default_db}'"
end

# grant privileges to the user so that he can get access from the host machine
execute "grant-access-to-root" do
  command "/usr/bin/mysql -uroot -p#{mysql_root_pwd} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{mysql_root_pwd}' WITH GRANT OPTION;\""
end

execute "bind-mysql-address" do
  not_if "cat #{mysql_config_file} | grep 127.0.0.1"
  command "set -i 's/127.0.0.1/0.0.0.0/g' #{mysql_config_file}"
end

service "mysql" do
  action :start
end

