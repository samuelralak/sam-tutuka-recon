# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CsvFiles', type: :request do
  describe 'GET /create' do
    it 'returns http success' do
      get '/csv_file/create'
      expect(response).to have_http_status(:success)
    end
  end
end
