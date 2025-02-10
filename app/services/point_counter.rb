class PointCounter
  def initialize
    @rules = [
      CharacterRule.new,
      EveryTwoItemsRule.new,
      ItemDescriptionRule.new,
      OddPurchaseDateRule.new,
      PurchaseTimeRule.new,
      RoundDollarRule.new,
      TwentyFivePercentRule.new
    ]
  end

  def calculate_points(receipt)
    points = 0
    @rules.each do |rule|
      test_points = rule.process(receipt)
      points += rule.process(receipt)
    end
    points
  end
end