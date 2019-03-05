#
# Output sqs
#
require 'kumogata/template/helper'

_output "#{args[:name]} queue physical id",
        ref_value: "#{args[:name]} queue",
        export: _export_string(args, "queue")
