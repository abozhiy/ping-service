# frozen_string_literal: true

module Endpoints
  class Ips < Application
    post '/', provides: :json do
      uuid = create_ip(validate_with! Contracts::IpParamsContract)
      if uuid
        json uuid: uuid, status: 200
      else
        json status: 422
      end
    end

    post '/:uuid/enable' do
      uuid = enable_stat
      if uuid
        json uuid: uuid, status: 200
      else
        json status: 422
      end
    end

    post '/:uuid/disable' do
      uuid = disable_stat
      if uuid
        json uuid: uuid, status: 200
      else
        json status: 422
      end
    end

    get '/:uuid/stats' do
      data = stats_query(validate_with! Contracts::IpStatParamsContract)
      if data
        json data: data, status: 200
      else
        json status: 422
      end
    end

    delete '/:uuid' do
      if delete_ip
        json status: 200
      else
        json status: 422
      end
    end

    private

    def create_ip(params)
      ::Ips::Services::CreateIp.call(
        ip_address: params[:ip][:ip_address],
        enabled: params[:ip][:enabled],
        logger: logger
      )
    end

    def enable_stat
      ::Ips::Services::SwitchStat::Enable.call(uuid: params[:uuid], logger: logger)
    end

    def disable_stat
      ::Ips::Services::SwitchStat::Disable.call(uuid: params[:uuid], logger: logger)
    end

    def delete_ip
      ::Ips::Services::DeleteIp.call(uuid: params[:uuid], logger: logger)
    end

    def stats_query(stat_params)
      ::Ips::Queries::StatsQuery.call(
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
