require 'abstract_unit'

class IamRoleTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_role "test", user: "test", service: "s3"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRole": {
    "Type": "AWS::IAM::Role",
    "Properties": {
      "AssumeRolePolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Service": [
                "s3.amazonaws.com"
              ]
            },
            "Action": [
              "sts:AssumeRole"
            ]
          }
        ]
      },
      "Path": "/",
      "RoleName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_iam_role "test", aws: { root: true }, depends: [ "test1 user", "test2 user" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRole": {
    "Type": "AWS::IAM::Role",
    "Properties": {
      "AssumeRolePolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam:::root"
            },
            "Action": [
              "sts:AssumeRole"
            ]
          }
        ]
      },
      "Path": "/",
      "RoleName": "test"
    },
    "DependsOn": [
      "Test1User",
      "Test2User"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
