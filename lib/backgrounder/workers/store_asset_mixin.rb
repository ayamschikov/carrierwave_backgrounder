# frozen_string_literal: true

module CarrierWave
  module Workers
    module StoreAssetMixin
      include CarrierWave::Workers::Base

      def self.included(base)
        base.extend CarrierWave::Workers::ClassMethods
      end

      attr_reader :cache_path, :tmp_directory

      def perform(*args)
        record = super(*args)

        if record&.send(:"#{column}_tmp")
          store_directories(record)
          record.send :"process_#{column}_upload=", true
          record.send :"#{column}_tmp=", nil
          if record.respond_to?(:"#{column}_processing")
            record.send :"#{column}_processing=", false
          end
          File.open(cache_path) { |f| record.send :"#{column}=", f }
          FileUtils.rm_r(tmp_directory, force: true) if record.save!
        else
          when_not_ready
        end
      end

      private

      def store_directories(record)
        asset = record.send(:"#{column}")
        asset_tmp = record.send(:"#{column}_tmp")
        cache_directory = File.expand_path(asset.cache_dir, asset.root)
        @cache_path = File.join(cache_directory, asset_tmp)
        @tmp_directory = File.join(cache_directory, asset_tmp.split('/').first)
      end
    end # StoreAssetMixin
  end # Workers
end # Backgrounder
