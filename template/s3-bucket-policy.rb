#
# S3 bucket policy resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "bucket policy")
bucket = _ref_name("bucket", args)

_(name) do
  Type "AWS::S3::BucketPolicy"
  Properties do
    BucketName bucket
    PolicyDocument do
      Version "2012-10-17"
      Statement _iam_policy_document("policy_document", args)
    end
  end
end