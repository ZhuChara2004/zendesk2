# frozen_string_literal: true
class Zendesk2::CreateHelpCenterSection
  include Zendesk2::Request

  request_method :post
  request_path { |r| "/help_center/categories/#{r.category_id}/sections.json" }
  request_body { |r| { 'section' => r.section_params } }

  def self.accepted_attributes
    %w(category_id description locale name position sorting)
  end

  def section_params
    Cistern::Hash.slice(params.fetch('section'), *self.class.accepted_attributes)
  end

  def category_id
    params.fetch('section').fetch('category_id')
  end

  def mock
    identity = cistern.serial_id

    locale = params['locale'] ||= 'en-us'
    position = data[:help_center_sections].values.select { |a| a['category_id'] == category_id }.size

    record = {
      'id'                => identity,
      'url'               => url_for("/help_center/#{locale}/sections/#{identity}.json"),
      'html_url'          => html_url_for("/hc/#{locale}/sections/#{identity}.json"),
      'author_id'         => cistern.current_user['id'],
      'comments_disabled' => false,
      'label_names'       => [],
      'draft'             => false,
      'promoted'          => false,
      'position'          => position,
      'vote_sum'          => 0,
      'vote_count'        => 0,
      'category_id'       => category_id,
      'created_at'        => timestamp,
      'updated_at'        => timestamp,
      'name'              => '',
      'body'              => '',
      'source_locale'     => locale,
      'outdated'          => false,
    }.merge(section_params)

    cistern.data[:help_center_sections][identity] = record

    access_policy = {
      'viewable_by'                     => 'everyone',
      'managable_by'                    => 'staff',
      'restricted_to_group_ids'         => [],
      'restricted_to_organization_ids'  => [],
      'required_tags'                   => [],
      'section_id'                      => identity,
    }
    cistern.data[:help_center_access_policies][identity] = access_policy

    mock_response('section' => record)
  end
end
