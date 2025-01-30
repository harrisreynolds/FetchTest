class PurchaseTimeRule
  def process(receipt)
    time_tokens = receipt.purchase_time.split(':')
    hour = time_tokens.first.to_i
    minute = time_tokens.last.to_i
    in_window = (hour == 14 && minute > 0) || hour == 15
    in_window ? 10 : 0
  end
end