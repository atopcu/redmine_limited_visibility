require_dependency 'organizations_controller'
require_dependency 'organizations/memberships_controller'

class Organizations::MembershipsController < ApplicationController
  def give_new_organization_functions_to_all_members(project:, organization:)
    organization_functions = @organization.organization_functions.where(project_id: @project.id).map(&:function).reject(&:blank?)
    previous_organization_functions = @organization.default_functions_by_project(@project)
    members = Member.joins(:user).where("project_id = ? AND users.organization_id = ?", project.id, organization.id)
    members.each do |member|
      personal_functions = member.functions - previous_organization_functions
      member.functions = organization_functions | personal_functions
      member.save!
    end
  end
end
