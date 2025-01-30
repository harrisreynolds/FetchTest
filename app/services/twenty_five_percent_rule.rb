class TwentyFivePercentRule
  def process(receipt)
    receipt.total.to_f % 0.25 == 0 ? 25 : 0
  end
end