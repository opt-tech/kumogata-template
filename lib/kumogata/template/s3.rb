#
# Helper - S3
#
require 'kumogata/template/helper'

def _s3_to_deletion_policy(value)
  return "Retain" if value.nil?

  case "value"
  when "delete"
    "Delete"
  when "retain"
    "Retain"
  when "shapshot"
    "Snapshot"
  else
    _valid_values(value, %w( Delete Retain Snapshot ), "Retain")
  end
end

def _s3_to_access(value)
  return "Private" if value.nil?

  case value
  when "auth read"
    "AuthenticatedRead"
  when "aws exec read"
    "AwsExecRead"
  when "owner read"
    "BucketOwnerRead"
  when "owner full"
    "BucketOwnerFullControl"
  when "log delivery write"
    "LogDeliveryWrite"
  when "private"
    "Private"
  when "public read"
    "PublicRead"
  when "public read write"
    "PublicReadWrite"
  else
    value
  end
end

def _s3_cors(args)
  rules = args[:cors] || []

  array = []
  rules.each do |rule|
    array << _{
      AllowedHeaders _array(rule[:headers]) if rule.key? :headers
      AllowedMethods _array(rule[:methods])
      AllowedOrigins _array(rule[:origins])
      ExposedHeaders _array(rule[:exposed_headers]) if rule.key? :exposed_headers
      Id rule[:id] if rule.key? :id
      MaxAge rule[:max_age] if rule.key? :max_age
    }
  end
  return [] if array.empty?

  _{
    CorsRules array
  }
end

def _s3_lifecycle(args)
  rules = args[:lifecycle] || []
  status_values = %w( Enabled Disabled )

  array = []
  rules.each do |rule|
    abort_incomplete_multipart_upload = _s3_lifecycle_abort_incomplete_multipart_upload(rule)
    noncurrent_transitions = _s3_lifecycle_noncurrent_version_transition(rule)
    status = _valid_values(rule[:status], status_values, "Enabled")
    transitions = _s3_lifecycle_transition(rule)
    array << _{
      AbortIncompleteMultipartUpload abort_incomplete_multipart_upload if abort_incomplete_multipart_upload
      ExpirationDate rule[:expiration_date] if rule.key? :expiration_date
      ExpirationInDays rule[:expiration_in_days] if rule.key? :expiration_in_days
      Id rule[:id] if rule.key? :id
      NoncurrentVersionExpirationInDays rule[:noncurrent_version_expiration_in_days] if rule.key? :noncurrent_version_expiration_in_days
      NoncurrentVersionTransitions noncurrent_transitions unless noncurrent_transitions.empty?
      Prefix rule[:prefix] if rule.key? :prefix
      Status status
      Transitions transitions unless transitions.empty?
    }
  end
  return [] if array.empty?

  _{
    Rules array
  }
end

def _s3_lifecycle_abort_incomplete_multipart_upload(args)
  rule = args[:abort_incomplete_multipart_upload]

  if rule
    _{
      DaysAfterInitiation rule[:days]
    }
  end
end

def _s3_lifecycle_noncurrent_version_transition(args)
  transitions = args[:noncurrent_version_transitions] || []

  array = []
  transitions.each do |transition|
    array << _{
      StorageClass transition[:storage]
      TransitionInDays transition[:in_days]
    }
  end
  array
end

def _s3_lifecycle_transition(args)
  transitions = args[:transitions] || []

  array = []
  transitions.each do |transition|
    array << _{
      StorageClass transition[:storage]
      TransitionDate transition[:date] if transition.key? :date
      TransitionInDays transition[:in_days] if transition.key? :in_days
    }
  end
  array
end

def _s3_logging(args)
  return "" unless args.key? :logging
  logging = args[:logging]

  _{
    DestinationBucketName logging[:destination]
    LogFilePrefix logging[:prefix] || ""
  }
end

def _s3_notification(args)
  return "" unless args.key? :notification
  notification = args[:notification]
  lambda = _s3_notification_configuration(notification, :lambda)
  queue = _s3_notification_configuration(notification, :queue)
  topic = _s3_notification_configuration(notification, :topic)

  _{
    LambdaConfigurations lambda unless lambda.empty?
    QueueConfigurations queue unless queue.empty?
    TopicConfigurations topic unless topic.empty?
  }
end

def _s3_notification_configuration(args, key)
  values = args[key] || []

  array = []
  values.each do |value|
    array << _{
      Event value[:event]
      Filter _{
        S3Key _{
          Rules value[:filters].collect{|v|
            filter = []
            v.each_pair do |kk, vv|
              filter << _{
                Name kk
                Value vv
              }
            end
            filter
          }.flatten
        }
      } if value.key? :filters
      case key
      when :lambda
        Function value[:function]
      when :queue
        Queue value[:queue]
      when :topic
        Topic value[:topic]
      end
    }
  end
  array
end

def _s3_replication(args)
  return "" unless args.key? :replication
  replication = args[:replication]
  rules = _s3_replication_rules(replication)

  _{
    Role replication[:role]
    Rules rules
  }
end

def _s3_replication_rules(args)
  rules = args[:rules] || []

  array = []
  rules.each do |rule|
    destination = _s3_replication_rules_destination(rule[:destination])
    array << _{
      Destination destination
      Id rule[:id]
      Prefix rule[:prefix]
      Status rule[:status]
    }
  end
  array
end

def _s3_replication_rules_destination(args)
  _{
    Bucket args[:bucket]
    StorageClass args[:storage]
  }
end

def _s3_versioning(args)
  return "" unless args.key? :versioning
  versioning = args[:versioning]
  status_values = %w( Enabled Disabled )
  status = _valid_values(versioning[:status], status_values, "Enabled")

  _{
    Status status
  }
end

def _s3_website(args)
  return "" unless args.key? :website
  website = args[:website]
  redirect = _s3_website_redirect_all_request(website)
  routing = _s3_website_routing_rules(website)

  _{
    ErrorDocument website[:error] || "404.html"
    IndexDocument website[:index] || "index.html"
    RedirectAllRequestsTo redirect unless redirect.empty?
    RoutingRules routing unless routing.empty?
  }
end

def _s3_website_redirect_all_request(args)
  return "" unless args.key? :redirect
  redirect = args[:redirect] || {}

  _{
    HostName redirect[:hostname]
    Protocol _valid_values(redirect[:protocol], %w( http https ), "http")
  }
end

def _s3_website_routing_rules(args)
  routing = args[:routing] || []

  array = []
  routing.each do |route|
    array << _{
      RedirectRule do
        redirect = route[:redirect] || {}
        HostName redirect[:host] if redirect.key? :host
        HttpRedirectCode redirect[:http] if redirect.key? :http
        Protocol redirect[:protocol] if redirect.key? :protocol
        ReplaceKeyPrefixWith redirect[:replace_key_prefix] if redirect.key? :replace_key_prefix
        ReplaceKeyWith redirect[:replace_key_with] if redirect.key? :replace_key_with
      end
      RoutingRuleCondition do
        routing = route[:routing] || {}
        HttpErrorCodeReturnedEquals routing[:http]
        KeyPrefixEquals routing[:key_prefix]
      end
    }
  end
  array
end
