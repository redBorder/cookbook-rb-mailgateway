# Cookbook:: mailgateway
# Recipe:: prepare_system
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

extend RbMailgateway::Helpers

# Stop rb-register
if File.exist?('/etc/redborder/sensor-installed.txt')
  service 'rb-register' do
    ignore_failure true
    action [:disable, :stop]
  end
end

# Configure and enable chef-client
dnf_package 'redborder-chef-client' do
  action :upgrade
end

template '/etc/sysconfig/chef-client' do
  source 'sysconfig_chef-client.rb.erb'
  mode '0644'
  variables(
    interval: node['chef-client']['interval'],
    splay: node['chef-client']['splay'],
    options: node['chef-client']['options']
  )
end

service 'chef-client' do
  if node['redborder']['services']['chef-client']
    action [:enable, :start]
  else
    action [:stop]
  end
end

# get cdomain
node.default['redborder']['cdomain'] = File.exist?('/etc/redborder/cdomain') ? File.read('/etc/redborder/cdomain').chomp : node['redborder']['cdomain']

node.default['redborder']['zookeeper']['zk_hosts'] = "zookeeper.service:#{node['redborder']['zookeeper']['port']}"

# memory
# getting total system memory less 10% reserved by system
sysmem_total = (node['memory']['total'].to_i * 0.90).to_i
# node attributes related with memory are changed inside the function to have simplicity using recursivity
memory_services(sysmem_total)

hosts_entries = update_hosts_file()

template '/etc/hosts' do
  source 'hosts.erb'
  cookbook 'rb-mailgateway'
  owner 'root'
  group 'root'
  mode '644'
  retries 2
  variables(hosts_entries: hosts_entries)
end

# Build service list for rbcli
unless File.exist?('/etc/redborder/services.json')
  services = node['redborder']['services'] || []
  systemd_services = node['redborder']['systemdservices'] || []
  service_enablement = {}

  systemd_services.each do |service_name, systemd_name|
    service_enablement[systemd_name.first] = services[service_name]
  end

  Chef::Log.info('Saving services enablement into /etc/redborder/services.json')
  File.write('/etc/redborder/services.json', JSON.pretty_generate(service_enablement))
end
