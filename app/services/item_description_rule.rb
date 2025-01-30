class ItemDescriptionRule
  def process(receipt)
    points = 0

    receipt.items.each do |item|
      if item.short_description.length % 3 == 0
        points += (item.price.to_f * 0.2).ceil
      end
    end

    points
  end
end