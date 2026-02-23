module RbMailgateway
  module Helpers
    # Get nodes of a specific type for this mailgateway
    def get_nodes(sensor_type)
      mailgateway_id = node['redborder']['sensor_id']
      search(:node, "role:#{sensor_type} AND redborder_parent_id:#{mailgateway_id}").sort
    end
  end
end
