class RoundDollarRule
  def process(receipt)
    receipt.total.to_f * 100 % 100 == 0 ? 50 : 0
  end
end