require 'abstract_unit'

class OutputSecurityGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_security_group "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSecurityGroupPhysicalId\": {
    "Description": "description of TestSecurityGroupPhysicalId",
    "Value": {
      "Ref": "TestSecurityGroup"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
