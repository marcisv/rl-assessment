class SerializedDataParser
  def self.perform(data:, separator:)
    new(data:, separator:).perform
  end

  def initialize(data:, separator:)
    @data = data
    @separator = separator
  end

  def perform
    entry_rows.map do |entry_row|
      entry_values = parse_data_row(entry_row)

      attribute_names.each_with_object({}).with_index do |(attribute_name, entry_attributes), index|
        entry_attributes[attribute_name] = entry_values[index]
      end
    end
  end

  private

  attr_reader :data, :separator

  def entry_rows
    @entry_rows ||= data_rows[1..-1]
  end

  def attribute_names
    @attribute_names ||= begin
      attribute_names_row = data_rows.first
      parse_data_row(attribute_names_row).map(&:to_sym)
    end
  end

  def data_rows
    @data_rows ||= data.split("\n")
  end

  def parse_data_row(data_row)
    data_row.split(separator).map(&:strip)
  end
end
