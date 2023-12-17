# frozen_string_literal: true

module Endpoints
  class Ips < Application
    post '/', provides: :json do
      if created.success?
        status 200
        json uuid: created.uuid
      else
        status 422
        json message: created.message
      end
    end

    post '/:uuid/enable' do
      if enabled.success?
        status 200
        json uuid: enabled.uuid
      else
        status 422
        json message: enabled.message
      end
    end

    post '/:uuid/disable' do
      if disabled.success?
        status 200
        json uuid: disabled.uuid
      else
        status 422
        json message: disabled.message
      end
    end

    get '/:uuid/stats' do
      if ip_stats.success?
        status 200
        json data: ip_stats.data
      else
        status 422
        json message: ip_stats.message
      end
    end

    delete '/:uuid' do
      if deleted.success?
        status 200
      else
        status 422
        json message: deleted.message
      end
    end

    private

    def created
      @created ||= create_ip(validate_with Contracts::IpParamsContract)
    end

    def create_ip(params)
      ::Ips::Services::CreateIp.call(
        ip_address: params[:ip][:ip_address],
        enabled: params[:ip][:enabled],
        contract: params,
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
      @ip_stats ||= get_ip_stats(validate_with Contracts::IpStatParamsContract)
    end

    def get_ip_stats(stat_params)
      ::Ips::Services::GetIpStats.call(
        uuid: params[:uuid],
        time_from: stat_params[:time_from],
        time_to: stat_params[:time_to],
        contract: stat_params,
        logger: logger
      )
    end

    def logger
      @logger ||= settings.logger
    end
  end
end
