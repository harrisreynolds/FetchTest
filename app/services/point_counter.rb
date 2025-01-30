# Remove the require_relative statements as Rails should autoload these
# require_relative statements can sometimes cause issues with Rails autoloading

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
      puts "rule: #{rule.class.name}"
      test_points = rule.process(receipt)
      puts "test_points: #{test_points}"
      points += rule.process(receipt)
    end
    points
  end
end