# frozen_string_literal: true

module Elastic
  class BulkUpdateWorker < ::BaseWorker
    from_queue "#{ApiCore.config.db_schema}.elastic.bulk_update", env: nil

    def work(opts)
      data = JSON.parse(opts)

      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.uncached do
          records = data['klass'].constantize.where(id: data['record_ids'])
          return if records.size.nil?

          data['klass'].constantize.bulk_update(records)
        end
      end

      GC.start
      ack!
    end
  end
end
