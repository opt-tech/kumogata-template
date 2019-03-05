#
# Output ec2
#
require 'kumogata/template/helper'

public_ip = args[:public_ip] || false

_output "#{args[:name]} instance physical id",
        ref_value: "#{args[:name]} instance",
        export: _export_string(args, "instance")
_output "#{args[:name]} instance az",
        ref_value: [ "#{args[:name]} instance", "AvailabilityZone" ],
        export: _export_string(args, "instance az")
_output "#{args[:name]} instance public ip",
        ref_value: [ "#{args[:name]} instance", "PublicIp" ],
        export: _export_string(args, "instance public ip") if public_ip
_output "#{args[:name]} instance private ip",
        ref_value: [ "#{args[:name]} instance", "PrivateIp" ],
        export: _export_string(args, "instance private ip")
