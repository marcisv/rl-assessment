require 'spec_helper'

RSpec.describe PeopleController do
  describe '#normalize' do
    subject { controller.normalize }

    let(:controller) { described_class.new(params) }
    let(:params) do
      {
        dollar_format: dollar_separated_data,
        percent_format: percent_separated_data,
        order: :first_name,
      }
    end
    let(:dollar_separated_data) do
      <<~DATA
        first_name $ city $ birthdate
        Linda $ Florida $ 14-11-1954
        Alex $ Washington $ 02-12-1994
      DATA
    end
    let(:percent_separated_data) do
      <<~DATA
        birthdate % city % first_name
        15-01-1986 % New York % John
        22-05-1972 % Los Angeles % Amanda
      DATA
    end

    before do
      allow(SerializedDataParser).to receive(:perform).and_call_original
      allow(PeopleSerializer).to receive(:perform).and_call_original
    end

    let(:expected_result) do
      [
        'Alex, Washington, 12/2/1994',
        'Amanda, Los Angeles, 5/22/1972',
        'John, New York, 1/15/1986',
        'Linda, Florida, 11/14/1954',
      ]
    end

    it 'calls the services and builds the sorted list of attributes' do
      is_expected.to eq(expected_result)

      expect(SerializedDataParser).to have_received(:perform).with(
        data: dollar_separated_data,
        separator: '$',
      )
      expect(SerializedDataParser).to have_received(:perform).with(
        data: percent_separated_data,
        separator: '%',
      )
      expect(PeopleSerializer).to have_received(:perform).with(
        people_attributes: [
          { first_name: 'Linda', city: 'Florida', birthdate: '14-11-1954' },
          { first_name: 'Alex', city: 'Washington', birthdate: '02-12-1994' },
          { first_name: 'John', city: 'New York', birthdate: '15-01-1986' },
          { first_name: 'Amanda', city: 'Los Angeles', birthdate: '22-05-1972' },
        ],
        sort_by: :first_name,
      )
    end
  end
end
