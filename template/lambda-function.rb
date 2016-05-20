#
# Lambda function resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html
#
require 'kumogata/template/helper'
require 'kumogata/template/lambda'

name = _resource_name(args[:name], "lambda function")
code = _lambda_function_code(args)
description = args[:description] || ""
function_name = args[:function_name] || ""
handler = args[:handler]
memory_size = args[:memory_size] || 128
role = _ref_attr_string("role", "Arn", args, "role")
role = _ref_string("role_arn", args, "role") if role.empty?
runtime = _valid_values(args[:runtime],
                        %w( nodejs nodejs4.3 java8 python2.7 ), "python2.7")
timeout = args[:timeout] || 3
vpc_config = _lambda_vpc_config(args)

_(name) do
  Type "AWS::Lambda::Function"
  Properties do
    Code code
    Description description unless description.empty?
    FunctionName function_name unless function_name.empty?
    Handler handler
    MemorySize memory_size
    Role role
    Runtime runtime
    Timeout timeout
    VpcConfig vpc_config unless vpc_config.empty?
  end
end