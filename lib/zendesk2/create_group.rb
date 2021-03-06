# frozen_string_literal: true
class Zendesk2::CreateGroup
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/groups.json' }
  request_body { |r| { 'group' => r.group_params } }

  def self.accepted_attributes
    %w(name)
  end

  def group_params
    @_group_params ||= Cistern::Hash.slice(params.fetch('group'), *self.class.accepted_attributes)
  end

  def mock(_params = {})
    identity = cistern.serial_id

    record = {
      'id'         => identity,
      'url'        => url_for("/groups/#{identity}.json"),
      'created_at' => timestamp,
      'updated_at' => timestamp,
      'deleted'    => false,
    }.merge(group_params)

    data[:groups][identity] = record

    mock_response({ 'group' => record }, { status: 201 })
  end
end
