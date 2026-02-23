module RbMailgateway
  module Helpers
    def get_monitor_configuration
      mailgateway_config = []
      device_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*device*').sort
      snmp_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*snmp*').sort
      redfish_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*redfish*').sort
      ipmi_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*ipmi*').sort
      monitor_sensors = device_sensors + snmp_sensors + redfish_sensors + ipmi_sensors
      monitor_sensors.each do |node|
        monitors = node.normal['redborder']['monitors']
        monitors.each do |monitor|
          if monitor['name'] == 'bulkstats_schema' || monitor['name'] == 'thermal'
            mailgateway_config << monitor['name']
          end
        end
      end
      mailgateway_config
    end
  end
end
