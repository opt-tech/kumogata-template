require 'abstract_unit'
require 'kumogata/template/s3'

class S3Test < Minitest::Test
  def test_s3_cors
    template = <<-EOS
Test _s3_cors(cors: [ { headers: "test", methods: "test", origins: "test", exposed_headers: "test", id: "test", max_age: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "CorsRules": [
      {
        "AllowedHeaders": [
          "test"
        ],
        "AllowedMethods": [
          "test"
        ],
        "AllowedOrigins": [
          "test"
        ],
        "ExposedHeaders": [
          "test"
        ],
        "Id": "test",
        "MaxAge": "test"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_lifecycle
    template = <<-EOS
Test _s3_lifecycle(lifecycle: [ { abort_incomplete_multipart_upload: { days: 7 }, expiration_date: "2018-01-01", expiration_in_days: 30, id: "test", noncurrent_version_expiration_in_days: 90, noncurrent_version_transitions: [ { storage: "test", in_days: "60" } ], transitions: [ { storage: "test", date: "2018-01-01" } ] } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Rules": [
      {
        "AbortIncompleteMultipartUpload": {
          "DaysAfterInitiation": "7"
        },
        "ExpirationDate": "2018-01-01",
        "ExpirationInDays": "30",
        "Id": "test",
        "NoncurrentVersionExpirationInDays": "90",
        "NoncurrentVersionTransitions": [
          {
            "StorageClass": "test",
            "TransitionInDays": "60"
          }
        ],
        "Status": "Enabled",
        "Transitions": [
          {
            "StorageClass": "test",
            "TransitionDate": "2018-01-01"
          }
        ]
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_logging
    template = <<-EOS
Test _s3_logging({ logging: { destination: "test", prefix: "test" } })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "DestinationBucketName": "test",
    "LogFilePrefix": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_notification
    template = <<-EOS
Test _s3_notification(notification: { lambda: [ { event: "test", filter: "test", function: "test" }],
                                      queue: [ { event: "test", filter: "test", queue: "test" }],
                                      topic: [ { event: "test", filter: "test", topic: "test" }], })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "LambdaConfigurations": [
      {
        "Event": "test",
        "Filter": {
          "S3Key": "test"
        },
        "Function": "test"
      }
    ],
    "QueueConfigurations": [
      {
        "Event": "test",
        "Filter": {
          "S3Key": "test"
        },
        "Queue": "test"
      }
    ],
    "TopicConfigurations": [
      {
        "Event": "test",
        "Filter": {
          "S3Key": "test"
        },
        "Topic": "test"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_replication
    template = <<-EOS
Test _s3_replication(replication: { role: "test" , rules: [ { destination: { bucket: "test", storage: "test" }, id: "test", prefix: "test", status: "test" } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Role": "test",
    "Rules": [
      {
        "Destination": {
          "Bucket": "test",
          "StorageClass": "test"
        },
        "Id": "test",
        "Prefix": "test",
        "Status": "test"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_versioning
    template = <<-EOS
Test _s3_versioning(versioning: { status: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Status": "Enabled"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_s3_website
    template = <<-EOS
Test _s3_website(website: { error: "test", index: "test", redirect: { hostname: "test" }, routing: [ { redirect: {}, routing: { http: "test", key_prefix: "test" } } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ErrorDocument": "test",
    "IndexDocument": "test",
    "RedirectAllRequestsTo": {
      "HostName": "test",
      "Protocol": "http"
    },
    "RoutingRules": [
      {
        "RedirectRule": {
        },
        "RoutingRuleCondition": {
          "HttpErrorCodeReturnedEquals": "test",
          "KeyPrefixEquals": "test"
        }
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
