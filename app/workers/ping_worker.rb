# frozen_string_literal = true

module Workers
  class PingWorker
    include Sidekiq::Worker
    BATCHES_SIZE = 10

    sidekiq_options queue: :ping, retry: 0

    def perform
      repo.enabled_ips.in_batches(of: BATCHES_SIZE) do |batch|
        ::Ips::Operations::StatsCollectionOperation.call(batch: batch.all, logger: logger)
      end
    end

    private

    def repo
      @repo ||= ::Ips::Repositories::Ip
    end

    def logger
      @logger ||= Logger.new("logs/#{ENV['RACK_ENV']}.log")
    end
  end
end
