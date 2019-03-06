require 'abstract_unit'

class OutputAutoscalingTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_autoscaling "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingGroupPhysicalId": {
    "Description": "description of TestAutoscalingGroupPhysicalId",
    "Value": {
      "Ref": "TestAutoscalingGroup"
    }
  },
  "TestAutoscalingLaunchConfigurationPhysicalId": {
    "Description": "description of TestAutoscalingLaunchConfigurationPhysicalId",
    "Value": {
      "Ref": "TestAutoscalingLaunchConfiguration"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
