class EveryTwoItemsRule
  def process(receipt)
    (receipt.items.length / 2).floor * 5
  end
end