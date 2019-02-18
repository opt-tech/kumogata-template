require 'abstract_unit'

class OutputRoleTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_role "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRoleArn": {
    "Description": "description of TestRoleArn",
    "Value": {
      "Fn::GetAtt": [
        "TestRole",
        "Arn"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
