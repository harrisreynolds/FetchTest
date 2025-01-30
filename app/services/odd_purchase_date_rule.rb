class OddPurchaseDateRule
  def process(receipt)
    receipt.purchase_date.split('-').last.to_i.odd? ? 6 : 0
  end
end