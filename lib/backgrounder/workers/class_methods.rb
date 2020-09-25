# frozen_string_literal: true

module CarrierWave
  module Workers
    module ClassMethods
      def perform(*args)
        new(*args).perform
      end
    end # ClassMethods
  end # Workers
end # Backgrounder
