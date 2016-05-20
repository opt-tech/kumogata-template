#
# EC2 Instance resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "instance")
instance_type = _ref_string("instance_type", args, "instance type")
az = _availability_zone(args)
block_device = (args[:block_device] || []).collect{|v| _ec2_block_device(v) }
disable_termination = _bool("disable_termination", args, false)
iam_instance = _ref_string("iam_instance", args, "iam instance profile")
image =_ec2_image(instance_type, args)
instance_initiated = args[:instance_initiated] || "stop"
kernel = args[:kernel] || ""
key_name = _ref_string("key_name", args, "key name")
monitoring = _bool("monitoring", args, true)
network_interfaces = (args[:network_interfaces] || []).collect{|v| _ec2_network_interface(v) }
placement = _ref_string("placement", args)
private_ip = args[:private_ip] || ""
ram_disk = args[:ram_disk] || ""
security_groups = _ref_array("security_groups", args, "security group")
source_dest = _bool("source_dest", args, true)
ssm = args[:ssm] || []
subnet = _ref_string("subnet", args, "subnet")
tags = _ec2_tags(args)
tenancy = args[:tenancy] || "default"
user_data = _ref_string("user_data", args, "user data")
volumes = args[:volumes] || ""

_(name) do
  Type "AWS::EC2::Instance"
  Properties do
    AvailabilityZone az unless az.empty?
    BlockDeviceMappings block_device
    DisableApiTermination disable_termination
    #EbsOptimized
    IamInstanceProfile iam_instance
    ImageId image
    InstanceInitiatedShutdownBehavior instance_initiated
    InstanceType instance_type
    KernelId kernel unless kernel.empty?
    KeyName key_name
    Monitoring monitoring
    NetworkInterfaces network_interfaces unless network_interfaces.empty?
    PlacementGroupName placement unless placement.empty?
    PrivateIpAddress private_ip unless private_ip.empty?
    RamdiskId ram_disk unless ram_disk.empty?
    #SecurityGroupIds
    SecurityGroups security_groups unless security_groups.empty?
    SourceDestCheck source_dest
    SsmAssociations ssm unless ssm.empty?
    SubnetId subnet unless subnet.empty?
    Tags tags
    Tenancy tenancy unless tenancy.empty?
    UserData do
      Fn__Base64 (<<-EOS).undent
#!/bin/bash
#{user_data}
EOS
    end
    Volumes volumes unless volumes.empty?
  end
end