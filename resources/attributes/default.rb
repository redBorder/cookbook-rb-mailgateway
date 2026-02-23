# require 'set' TODO: refactor to this

# general
default['redborder']['cdomain'] = 'redborder.cluster'
default['redborder']['organization_uuid'] = nil
default['redborder']['organizations'] = []
default['redborder']['locations'] = %w(namespace namespace_uuid organization organization_uuid service_provider service_provider_uuid deployment deployment_uuid market market_uuid campus campus_uuid building building_uuid floor floor_uuid)
default['redborder']['repo'] = {}
default['redborder']['repo']['version'] = nil

# default['redborder']['mailgateway']['insecure'] = true

# chef-client
default['chef-client']['interval'] = 300
default['chef-client']['splay'] = 100
default['chef-client']['options'] = ''

# kafka
default['redborder']['kafka']['port'] = 9092
default['redborder']['kafka']['logdir'] = '/var/log/kafka'
default['redborder']['kafka']['host_index'] = 0

# zookeeper
default['redborder']['zookeeper']['zk_hosts'] = ''
default['redborder']['zookeeper']['port'] = 2181

# memory
default['redborder']['memory_services'] = {}
default['redborder']['memory_services']['chef-server'] = { 'count': 10, 'memory': 0 }


default['redborder']['services'] = {}
default['redborder']['services']['chef-client'] = true


default['redborder']['systemdservices']['chef-client'] = ['chef-client']

