module Blamer
  module Userstamp
    extend ActiveSupport::Concern

    included do
      class_attribute :record_userstamps, :instance_writer => false
      class_attribute :created_userstamp_column, :instance_writer => false
      class_attribute :updated_userstamp_column, :instance_writer => false

      self.record_userstamps = true
      self.created_userstamp_column = :creator_id
      self.updated_userstamp_column = :updater_id
    end

    private

    def userstamp_object
      GradingDatabase::GradingLogin.current_user
    end

    def _create_record(*args)
      if record_userstamps
        write_attribute(created_userstamp_column, userstamp_object.try(:id)) if respond_to?(created_userstamp_column)
        write_attribute(updated_userstamp_column, userstamp_object.try(:id)) if respond_to?(updated_userstamp_column)
      end

      super
    end

    def _update_record(*args)
      if record_userstamps && changed?
        write_attribute(updated_userstamp_column, userstamp_object.try(:id)) if respond_to?(updated_userstamp_column)
      end
      super
    end

  end

  module UserstampMigrationHelper
    def userstamps
      column ActiveRecord::Base.created_userstamp_column, :integer
      column ActiveRecord::Base.updated_userstamp_column, :integer
    end
  end

end
