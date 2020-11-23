# frozen_string_literal: true

module Elastic
  class BulkUpdateWorker < ::BaseWorker
    from_queue "#{ApiCore.config.db_schema}.elastic.bulk_update", env: nil

    def work(opts)
      data = JSON.parse(opts)
      model = data['klass'].constantize

      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.uncached do
          objects = model.where(id: data['ids'])

          if model.is_a?(Product)
            objects = objects.includes(:marketing_name, :product_custom_fields, :product_offers, :translations, categories: :translations)
          end
          return if objects.size.nil?

          model.bulk_update(objects)
        end
      end

      GC.start
      ack!
    end
  end
end
