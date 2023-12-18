# frozen_string_literal: true

describe 'POST /ips', type: :request do
  subject(:request) { post '/ips', body.to_json, headers }

  let(:ip_address) { '127.0.0.1' }
  let(:enabled) { true }

  let(:headers) { { 'Accept' => 'application/json' } }
  let(:body) do
    {
      ip: {
        ip_address: ip_address,
        enabled: enabled
      }
    }
  end

  context 'when valid params' do
    it { expect(request.status).to eq 200 }

    it 'returns uuid' do
      body = JSON.parse(request.body)
      expect(body['uuid']).not_to be_nil
    end
  end

  context 'when invalid ip_address not exist' do
    let(:ip_address) { nil }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end

  context 'when ip_address invalid' do
    let(:ip_address) { '127.0.0.256' }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end

  context 'when enabled not exist' do
    let(:enabled) { nil }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end

  context 'when empty body' do
    let(:body) { {} }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end
end

describe 'POST /ips/:uuid/enable', type: :request do
  subject(:request) { post "/ips/#{uuid}/enable" }

  let!(:ip) { create :ip, enabled: false }

  context 'when ip exists' do
    let(:uuid) { ip.id }

    it { expect(request.status).to eq 200 }

    it 'returns uuid' do
      body = JSON.parse(request.body)
      expect(body['uuid']).to eq uuid
    end
  end

  context 'when ip does not exist' do
    let(:uuid) { SecureRandom.uuid }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end
end

describe 'POST /ips/:uuid/disable', type: :request do
  subject(:request) { post "/ips/#{uuid}/disable" }

  let!(:ip) { create :ip }

  context 'when ip exists' do
    let(:uuid) { ip.id }

    it { expect(request.status).to eq 200 }

    it 'returns uuid' do
      body = JSON.parse(request.body)
      expect(body['uuid']).to eq uuid
    end
  end

  context 'when ip does not exist' do
    let(:uuid) { SecureRandom.uuid }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end
end

describe 'POST /ips/:uuid/stats', type: :request do
  subject(:request) { get "/ips/#{uuid}/stats", body, headers }

  let!(:ip) { create :ip }
  let!(:stat) { create :stat, ip_id: ip.id, created_at: '2023-12-17, 19:00' }

  let(:headers) { { 'Accept' => 'application/json' } }
  let(:body) do
    {
      time_from: '2023-12-17, 17:00',
      time_to: '2023-12-17, 20:00'
    }
  end

  context 'when data exists' do
    let(:uuid) { ip.id }

    it { expect(request.status).to eq 200 }

    it 'returns data' do
      body = JSON.parse(request.body)
      expect(body['data']).to be_an_instance_of(Array)
    end
  end

  context 'when data does not exist' do
    let(:uuid) { SecureRandom.uuid }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end

  context 'when empty body' do
    let(:uuid) { ip.id }
    let(:body) { {} }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end
end

describe 'DELETE /ips/:uuid', type: :request do
  subject(:request) { delete "/ips/#{uuid}" }

  let!(:ip) { create :ip }

  context 'when ip exists' do
    let(:uuid) { ip.id }

    it { expect(request.status).to eq 200 }
  end

  context 'when ip does not exist' do
    let(:uuid) { SecureRandom.uuid }

    it { expect(request.status).to eq 422 }

    it 'returns message' do
      body = JSON.parse(request.body)
      expect(body['message']).not_to be_nil
    end
  end
end
