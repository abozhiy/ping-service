# frozen_string_literal: true

module Endpoints
  class Ips < Application
    post '/', provides: :json do
      uuid = create_ip(create_params)
      if uuid
        json uuid: uuid, status: :ok
      else
        json status: 422
      end
    end

    post '/:uuid/enable' do
      uuid = enable_stat
      if uuid
        json uuid: uuid, status: :ok
      else
        json status: 422
      end
    end

    post '/:uuid/disable' do
      uuid = disable_stat
      if uuid
        json uuid: uuid, status: :ok
      else
        json status: 422
      end
    end

    get '/:uuid/stats' do
      # получить статистику для адреса (time_from: datetime, time_to: datetime)
    end

    delete '/:uuid' do
      if delete_ip
        json status: :ok
      else
        json status: 422
      end
    end

    private

    def create_params
      validate_with! Contracts::IpParamsContract
    end

    def create_ip(ip_params)
      ::Services::CreateIp.call(
        ip_address: ip_params[:ip][:ip_address],
        enabled: ip_params[:ip][:enabled]
      )
    end

    def enable_stat
      ::Services::EnableStat.call(uuid: params[:uuid])
    end

    def disable_stat
      ::Services::DisableStat.call(uuid: params[:uuid])
    end

    def delete_ip
      ::Services::DeleteIp.call(uuid: params[:uuid])
    end
  end
end
