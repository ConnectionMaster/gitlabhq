# frozen_string_literal: true

module AntiAbuse
  module Reports
    class Discussion < ::Discussion
      def self.base_discussion_id(_note)
        [:discussion, :abuse_report_id]
      end

      def self.note_class
        DiscussionNote
      end

      def reply_attributes
        first_note.slice(:type, :abuse_report_id, :discussion_id)
      end

      def individual_note?
        false
      end
    end
  end
end
