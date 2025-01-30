class Receipt
  attr_reader :id, :retailer, :purchase_date, :purchase_time, :points, :total, :items
  attr_accessor :points

  RETAILER_PATTERN = /^[\w\s\-&]+$/
  CURRENCY_PATTERN = /^\d+\.\d{2}$/
  DESCRIPTION_PATTERN = /^[\w\s\-]+$/
  DATE_PATTERN = /\d{4}-\d{2}-\d{2}/
  TIME_PATTERN = /\d{2}:\d{2}/

  def initialize(retailer, purchase_date, purchase_time, total, items)
    @id = SecureRandom.uuid
    @retailer = retailer&.strip
    @purchase_date = purchase_date&.strip
    @purchase_time = purchase_time&.strip
    @total = total&.strip
    @points = nil
    init_items(items)
  end

  def init_items(items)
    @items = []
    return if items.blank?
    items.each do |item|
      @items << Item.new(item[:shortDescription], item[:price])
    end
  end

  def valid?
    return false unless @retailer.present? && @purchase_date.present? &&
      @purchase_time.present? && @total.present? && @items.present?
    return false unless @purchase_date.match(DATE_PATTERN)
    return false unless @purchase_time.match(TIME_PATTERN)
    return false unless @retailer.match(RETAILER_PATTERN)
    return false unless @total.match(CURRENCY_PATTERN)
    @items.each do |item|
      return false unless item.short_description.match(DESCRIPTION_PATTERN)
      return false unless item.price.match(CURRENCY_PATTERN)
    end

    true
  end

end

class Item
  attr_reader :short_description, :price

  def initialize(short_description, price)
    @short_description = short_description&.strip
    @price = price&.strip
  end
end
