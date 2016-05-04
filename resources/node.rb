#
# Cookbook Name:: zookeeper
# Resource:: node

# Copyright 2013, Simple Finance Technology Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default_action :create

property :node_path,   kind_of: String, name_attribute: true
property :connect_str, kind_of: String, required: true
property :data,        kind_of: String

property :auth_cert,   kind_of: String, default: nil
property :auth_scheme,                  default: 'digest'

property :acl_digest,  kind_of: Hash,   default: {}
property :acl_ip,      kind_of: Hash,   default: {}
property :acl_sasl,    kind_of: Hash,   default: {}
property :acl_world,   kind_of: Fixnum, default: Zk::PERM_ALL

include Zk::Gem

def load_current_value
  result = zookeeper.get_acl path: node_path
  current_value_does_not_exist! unless result[:stat].exists

  current_resource.data zookeeper.get(path: new_resource.node_path)[:data]

  result[:acl].each do |acl|
    case acl[:id][:scheme]
    when 'world'
      current_resource.acl_world acl[:perms]
    else
      current_resource.send("acl_#{acl[:id][:scheme]}".to_sym)[acl[:id][:id]] = acl[:perms]
    end
  end
end

action :create_if_missing do
  run_action :create unless current_resource
end

action :create do
  converge_if_changed do
    if current_resource
      if current_resource.data != new_resource.data
        converge_by "Updating #{node_path} node" do
          result = zookeeper.set(path: new_resource.node_path, data: new_resource.data)[:rc]

          raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
        end
      end

      if [
        :acl_world,
        :acl_digest,
        :acl_ip,
        :acl_sasl
      ].any? { |s| current_resource.send(s) != new_resource.send(s) }
        converge_by "Setting #{node_path} acls" do
          result = zookeeper.set_acl(path: new_resource.node_path, acl: compile_acls)[:rc]

          raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
        end
      end
    else
      converge_by "Creating #{node_path} node" do
        result = zookeeper.create(path: new_resource.node_path, data: new_resource.data, acl: compile_acls)[:rc]

        raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
      end
    end
  end
end

action :delete do
  converge_by "Removing #{node_path} node" do
    zookeeper.delete path: node_path
  end if current_resource
end
