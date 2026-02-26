# Cookbook:: mailgateway
# Recipe:: configure
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

# Services configuration
require 'yaml'

mailgateway_services = mailgateway_services()

rb_common_config 'Configure common' do
  sensor_role 'gateway-sensor'
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
# rbcgroup_config 'Configure cgroups' do
#   action :add
# end

# rb_chrony_config 'Configure Chrony' do
#   if mailgateway_services['chrony']
#     action :add
#   else
#     action :remove
#   end
# end

# MOTD
rb_config = YAML.load_file('/etc/redborder/rb_init_conf.yml')

manager = rb_config['cloud_address'] || rb_config['webui_host'] || 'unknown'
registration_mode = rb_config['registration_mode'] || 'unknown'

template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  retries 2
  variables(
    manager_info: rb_config['cdomain'],
    manager: manager,
    registration_mode: registration_mode
  )
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
