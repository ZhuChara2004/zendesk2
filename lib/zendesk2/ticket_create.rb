# frozen_string_literal: true
class Zendesk2::TicketCreate < Zendesk2::AuditEvent
  # @return [integer] Automatically assigned when creating events
  identity :id, type: :integer

  # @return [string] The name of the field that was set
  attribute :field_name, type: :string
  # @return [Array] The value of the field that was set
  attribute :value, parser: ->(v, _) { [*v] }
end
