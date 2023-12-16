# frozen_string_literal: true

module Services
  class ThreadService
    POOL_SIZE = 5

    EmptyListError = Class.new StandardError

    def initialize(list:, logger:)
      @list = list
      @logger = logger
      @queue = Queue.new
    end

    def call
      check_list
      enqueue
      threads = Array.new(POOL_SIZE) do
        Thread.new do
          begin
            sleep 0.1
            yield @queue.pop until @queue.empty?
          rescue ThreadError => e
            @logger.error e.message
          end
        end
      end
      threads.map(&:join)
    rescue StandardError => e
      @logger.error e.message
    end

    private

    def enqueue
      @list.each { |item| @queue.push(item) }
    end

    def check_list
      raise EmptyListError unless @list.any?
    end
  end
end
