require 'abstract_unit'

class OutputElasticacheTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_elasticache "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheCluster": {
    "Description": "description of TestCacheCluster",
    "Value": {
      "Ref": "TestCacheCluster"
    }
  },
  "TestCacheClusterRedisAddress": {
    "Description": "description of TestCacheClusterRedisAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "RedisEndpoint.Address"
      ]
    }
  },
  "TestCacheClusterRedisPort": {
    "Description": "description of TestCacheClusterRedisPort",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "RedisEndpoint.Port"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output_elasticache "test", replication: true, engine: "redis"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheReplicationGroupPhysicalId": {
    "Description": "description of TestCacheReplicationGroupPhysicalId",
    "Value": {
      "Ref": "TestCacheReplicationGroup"
    }
  },
  "TestCacheReplicationGroupPrimaryAddress": {
    "Description": "description of TestCacheReplicationGroupPrimaryAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "PrimaryEndPoint.Address"
      ]
    }
  },
  "TestCacheReplicationGroupPrimaryPort": {
    "Description": "description of TestCacheReplicationGroupPrimaryPort",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "PrimaryEndPoint.Port"
      ]
    }
  },
  "TestCacheReplicationGroupReadAddresses": {
    "Description": "description of TestCacheReplicationGroupReadAddresses",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "ReadEndPoint.Addresses"
      ]
    }
  },
  "TestCacheReplicationGroupReadPorts": {
    "Description": "description of TestCacheReplicationGroupReadPorts",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "ReadEndPoint.Ports"
      ]
    }
  }
}
    EOS

    assert_equal exp_template.chomp, act_template
    template = <<-EOS
_output_elasticache "test", engine: "memcached"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheCluster": {
    "Description": "description of TestCacheCluster",
    "Value": {
      "Ref": "TestCacheCluster"
    }
  },
  "TestCacheClusterConfigurationAddress": {
    "Description": "description of TestCacheClusterConfigurationAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "ConfigurationEndpoint.Address"
      ]
    }
  },
  "TestCacheClusterConfigurationPort": {
    "Description": "description of TestCacheClusterConfigurationPort",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "ConfigurationEndpoint.Port"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
