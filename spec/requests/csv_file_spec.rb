# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CsvFiles', type: :request do
  describe 'POST /create' do
    before do
      Rails.cache.clear
      ActionController::Base.perform_caching = true
    end

    after do
      ActionController::Base.perform_caching = false
    end

    let(:file_params) do
      {
        csv_file: {
          attachment: fixture_file_upload('file_a.csv', 'text/csv')
        }
      }
    end

    it 'returns http success when attachment is valid' do
      post '/csv_files', params: file_params
      expect(response).to have_http_status(:success)
    end

    it 'returns 422 when attachment is valid' do
      post '/csv_files', params: { csv_file: { attachment: fixture_file_upload('students.png', 'image/png') } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
