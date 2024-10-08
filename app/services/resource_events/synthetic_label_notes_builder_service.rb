# frozen_string_literal: true

# We store events about issuable label changes in a separate table (not as
# other system notes), but we still want to display notes about label changes
# as classic system notes in UI.  This service generates "synthetic" notes for
# label event changes.

module ResourceEvents
  class SyntheticLabelNotesBuilderService < BaseSyntheticNotesBuilderService
    private

    def synthetic_notes
      label_events_by_discussion_id.map do |discussion_id, events|
        LabelNote.from_events(events, resource: resource, resource_parent: resource_parent)
      end
    end

    def label_events_by_discussion_id
      return [] unless resource.respond_to?(:resource_label_events)

      events = resource.resource_label_events.includes(:label, user: :status).order(:id) # rubocop: disable CodeReuse/ActiveRecord
      events = apply_common_filters(events)

      events.group_by { |event| event.discussion_id }
    end

    def table_name
      'resource_label_events'
    end
  end
end
