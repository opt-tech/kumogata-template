#
# Output security group
#
require 'kumogata/template/helper'

_output "#{args[:name]} security group",
        ref_value: "#{args[:name]} security group",
        export: _export_string(args, "security group")
_output "#{args[:name]} security group physical id",
        ref_value: "#{args[:name]} security group",
        export: _export_string(args, "security group")
