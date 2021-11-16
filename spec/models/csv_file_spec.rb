# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFile do
  describe 'File Upload' do
    before do
      Rails.cache.clear
      ActionController::Base.perform_caching = true
    end

    after do
      ActionController::Base.perform_caching = false
    end

    let(:file_headers) do
      %w[ProfileName TransactionDate TransactionAmount TransactionNarrative TransactionDescription TransactionID
         TransactionType WalletReference]
    end
    let(:valid_file) { File.new(Rails.root.join('spec/fixtures/files/file_a.csv')) }
    let(:invalid_file) { File.new(Rails.root.join('spec/fixtures/files/students.png')) }

    it 'loads file when format is valid' do
      attachment = ActionDispatch::Http::UploadedFile.new(tempfile: valid_file,
                                                          filename: File.basename(valid_file),
                                                          type: 'text/csv')
      file = described_class.new(attachment).load!
      expect(file.meta[:headers]).to eq file_headers
    end

    it 'raise an error when format is invalid' do
      attachment = ActionDispatch::Http::UploadedFile.new(tempfile: invalid_file,
                                                          filename: File.basename(invalid_file),
                                                          type: 'image/png')
      expect { described_class.new(attachment).load! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
