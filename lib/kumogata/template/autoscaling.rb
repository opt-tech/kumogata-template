#
# Helper - AutoScaling
#
require 'kumogata/template/helper'

def _autoscaling_metrics
  _{
    Granularity "1Minute"
    Metrics %w( GroupMinSize
                GroupMaxSize
                GroupDesiredCapacity
                GroupInServiceInstances
                GroupPendingInstances
                GroupStandbyInstances
                GroupTerminatingInstances
                GroupTotalInstances )
  }
end

def _autoscaling_notification(args)
  types = args[:types] || []
  %w(
    EC2_INSTANCE_LAUNCH
    EC2_INSTANCE_LAUNCH_ERROR
    EC2_INSTANCE_TERMINATE
    EC2_INSTANCE_TERMINATE_ERROR
    TEST_NOTIFICATION
  ).collect{|v| types << "autoscaling:#{v}" } if types.empty?

  topic = _ref_attr_string("topic", "Arn", args, "topic")
  topic = _ref_string("topic_arn", args) if topic.empty?

  _{
    NotificationTypes types
    TopicARN topic
  }
end

def _autoscaling_step(args)
  lower = args[:lower] || ""
  upper = args[:upper] || ""
  scaling = args[:scaling] || 1

  _{
    MetricIntervalLowerBound lower unless lower.empty?
    MetricIntervalUpperBound upper unless upper.empty?
    ScalingAdjustment scaling
  }
end

def _autoscaling_tags(args)
  tags = [
          _{
            Key "Name"
            Value _tag_name(args[:tag_name] || args[:name])
            PropagateAtLaunch _bool("tag_name_launch", args, true)
          },
          _{
            Key "Service"
            Value { Ref _resource_name("service") }
            PropagateAtLaunch _bool("tag_service_launch", args, true)
          },
          _{
            Key "Version"
            Value { Ref _resource_name("version") }
            PropagateAtLaunch _bool("tag_version_launch", args, true)
          },
         ]
  if args.key? :tags_append
    args[:tags_append].each do|key, value|
      tag = _tag({ key: key, value: value })
      tag["PropagateAtLaunch"] = _bool("tag_#{key}_launch", args, true)
      tags << tag
    end
  end
  tags
end