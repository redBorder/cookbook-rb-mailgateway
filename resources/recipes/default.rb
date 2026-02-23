# Cookbook:: mailgateway
# Recipe:: default
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

include_recipe 'rb-mailgateway::prepare_system'
include_recipe 'rb-mailgateway::configure'
include_recipe 'rb-mailgateway::configure_journald'
