require 'abstract_unit'

class OutputTopicTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_topic "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTopicPhysicalId": {
    "Description": "description of TestTopicPhysicalId",
    "Value": {
      "Ref": "TestTopic"
    }
  },
  "TestTopicName": {
    "Description": "description of TestTopicName",
    "Value": {
      "Fn::GetAtt": [
        "TestTopic",
        "TopicName"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
