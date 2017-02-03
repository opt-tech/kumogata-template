#
# CodeCommit Repository resource type
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codecommit-repository.html
#
require 'kumogata/template/helper'
require 'kumogata/template/codecommit'

name = _resource_name(args[:name], "codecommit repository")
description = args[:description] || ""
repository = _ref_name_default("repository", args)
triggers = _codecommit_triggers(args)

_(name) do
  Type "AWS::CodeCommit::Repository"
  Properties do
    RepositoryDescription description unless description.empty?
    RepositoryName repository
    Triggers triggers unless triggers.empty?
  end
end
