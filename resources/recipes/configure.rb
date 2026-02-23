# Cookbook:: mailgateway
# Recipe:: configure
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

# Services configuration

mailgateway_services = mailgateway_services()

rb_common_config 'Configure common' do
  sensor_role 'mailgateway-sensor'
  action :configure
end

rb_selinux_config 'Configure Selinux' do
  if shell_out('getenforce').stdout.chomp == 'Disabled'
    action :remove
  else
    action :add
  end
end

rb_firewall_config 'Configure Firewall' do
  if mailgateway_services['firewall']
    action :add
  else
    action :remove
  end
end

rbmonitor_config 'Configure redborder-monitor' do
  name node['hostname']
  if mailgateway_services['redborder-monitor']
    action :add
  else
    action :remove
  end
end

# TODO: replace node['redborder']['services'] in action with 'mailgateway_services'..
rbcgroup_config 'Configure cgroups' do
  action :add
end

rb_chrony_config 'Configure Chrony' do
  if mailgateway_services['chrony']
    action :add
  else
    action :remove
  end
end

# MOTD
manager = `grep 'cloud_address' /etc/redborder/rb_init_conf.yml | cut -d' ' -f2`

template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  retries 2
  variables(manager_info: node['redborder']['cdomain'], manager: manager)
end

# TODO: replace node['redborder']['services'] in action with 'mailgateway_services'..
template '/etc/sudoers.d/redBorder' do
  source 'redBorder.erb'
  cookbook 'rb-mailgateway'
  owner 'root'
  group 'root'
  mode '0440'
  retries 2
end
