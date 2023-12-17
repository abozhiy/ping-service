# frozen_string_literal: true

module Endpoints
  class Ips < Application
    post '/', provides: :json do
      if created.success?
        json uuid: created.uuid, status: 200
      else
        json message: created.message, status: 422
      end
    end

    post '/:uuid/enable' do
      if enabled.success?
        json uuid: enabled.uuid, status: 200
      else
        json message: enabled.message, status: 422
      end
    end

    post '/:uuid/disable' do
      if disabled.success?
        json uuid: disabled.uuid, status: 200
      else
        json message: disabled.message, status: 422
      end
    end

    get '/:uuid/stats' do
      if ip_stats.success?
        json data: ip_stats.data, status: 200
      else
        json message: ip_stats.message, status: 422
      end
    end

    delete '/:uuid' do
      if deleted.success?
        json status: 200
      else
        json message: deleted.message, status: 422
      end
    end

    private

    def created
      @created ||= create_ip(validate_with! Contracts::IpParamsContract)
    end

    def create_ip(params)
      ::Ips::Services::CreateIp.call(
        ip_address: params[:ip][:ip_address],
        enabled: params[:ip][:enabled],
        logger: logger
      )
    end

    def enabled
      @enabled ||= ::Ips::Services::SwitchStat::Enable.call(uuid: params[:uuid], logger: logger)
    end

    def disabled
      @disabled ||= ::Ips::Services::SwitchStat::Disable.call(uuid: params[:uuid], logger: logger)
    end

    def deleted
      @deleted ||= ::Ips::Services::DeleteIp.call(uuid: params[:uuid], logger: logger)
    end

    def ip_stats
      @ip_stats ||= get_ip_stats(validate_with! Contracts::IpStatParamsContract)
    end

    def get_ip_stats(stat_params)
      ::Ips::Services::GetIpStats.call(
        uuid: params[:uuid],
        time_from: stat_params[:time_from],
        time_to: stat_params[:time_to],
        logger: logger
      )
    end

    def logger
      @logger ||= settings.logger
    end
  end
end
