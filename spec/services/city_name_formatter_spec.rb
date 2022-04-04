require 'spec_helper'

RSpec.describe CityNameFormatter do
  describe '.perform' do
    subject { described_class.perform(name) }

    let(:name) { 'Atlanta' }

    it 'returns the original name' do
      is_expected.to eq('Atlanta')
    end

    context 'when an abbreviation is provided' do
      let(:name) { 'NYC' }

      it 'returns the full name' do
        is_expected.to eq('New York City')
      end
    end
  end
end
