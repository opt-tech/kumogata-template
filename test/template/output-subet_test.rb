require 'abstract_unit'

class OutputSubnetTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_subnet "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnetPhysicalId": {
    "Description": "description of TestSubnetPhysicalId",
    "Value": {
      "Ref": "TestSubnet"
    }
  },
  "TestSubnetAz": {
    "Description": "description of TestSubnetAz",
    "Value": {
      "Fn::GetAtt": [
        "TestSubnet",
        "AvailabilityZone"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
