require 'spec_helper'

RSpec.describe PeopleSerializer do
  describe '.perform' do
    subject do
      described_class.perform(
        people_attributes: people_attributes,
        sort_by: sort_by_attribute_name,
      )
    end

    let(:people_attributes) do
      [
        {
          first_name: 'Lily',
          city: 'San Francisco',
          birthdate: '1975-04-15',
          unneeded_attribute: 'ABC',
        },
        {
          first_name: 'Mckayla',
          city: 'Atlanta',
          birthdate: '1986-05-29',
          unneeded_attribute: 'ABC',
        },
        {
          first_name: 'Elliot',
          city: 'New York City',
          birthdate: '1947-05-04',
          unneeded_attribute: '123',
        },
      ]
    end

    let(:sort_by_attribute_name) { :city }

    let(:expected_data) do
      [
        'Mckayla, Atlanta, 5/29/1986',
        'Elliot, New York City, 5/4/1947',
        'Lily, San Francisco, 4/15/1975',
      ]
    end

    it 'serializes the people in an order with a formatted date' do
      is_expected.to eq(expected_data)
    end

    context 'when sorting by other attribute' do
      let(:sort_by_attribute_name) { :first_name }

      let(:expected_data) do
        [
          'Elliot, New York City, 5/4/1947',
          'Lily, San Francisco, 4/15/1975',
          'Mckayla, Atlanta, 5/29/1986',
        ]
      end

      it { is_expected.to eq(expected_data) }
    end
  end
end
