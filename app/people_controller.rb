class PeopleController
  def initialize(params)
    @params = params
  end

  def normalize
    PeopleSerializer.perform(
      people_attributes: people_attributes,
      sort_by: params[:order],
    )
  end

  private

  attr_reader :params

  def people_attributes
    [
      *SerializedDataParser.perform(
        data: params[:dollar_format],
        separator: '$'
      ),
      *SerializedDataParser.perform(
        data: params[:percent_format],
        separator: '%'
      ),
    ]
  end
end
