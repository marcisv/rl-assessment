require 'spec_helper'

RSpec.describe SerializedDataParser do
  describe '.perform' do
    subject do
      described_class.perform(
        data: serialized_data,
        separator: separator,
      )
    end

    let(:serialized_data) do
      <<~DATA
        attribute_x $ attribute_y $ attribute_z
        x value A $ y value A $ z value A
        x value B $ y value B $ z value B
        x value C $ y value C $ z value C
      DATA
    end

    let(:separator) { '$' }

    let(:expected_result) do
      [
        {
          attribute_x: 'x value A',
          attribute_y: 'y value A',
          attribute_z: 'z value A',
        },
        {
          attribute_x: 'x value B',
          attribute_y: 'y value B',
          attribute_z: 'z value B',
        },
        {
          attribute_x: 'x value C',
          attribute_y: 'y value C',
          attribute_z: 'z value C',
        },
      ]
    end

    it { is_expected.to eq(expected_result) }

    context 'with a different separator' do
      let(:separator) { 'separator' }

      let(:expected_result) do
        [
          { :'attribute_x $ attribute_y $ attribute_z' => 'x value A $ y value A $ z value A' },
          { :'attribute_x $ attribute_y $ attribute_z' => 'x value B $ y value B $ z value B' },
          { :'attribute_x $ attribute_y $ attribute_z' => 'x value C $ y value C $ z value C' },
        ]
      end

      it 'tries to split by that separator' do
        is_expected.to eq(expected_result)
      end

      context 'when the separator is used in the data' do
        let(:serialized_data) do
          <<~DATA
            attr_a separator attr_b
            a value 1 separator b value 1
            a value 2 separator b value 2
          DATA
        end

        let(:expected_result) do
          [
            {
              attr_a: 'a value 1',
              attr_b: 'b value 1',
            },
            {
              attr_a: 'a value 2',
              attr_b: 'b value 2',
            },
          ]
        end

        it { is_expected.to eq(expected_result) }
      end
    end
  end
end
