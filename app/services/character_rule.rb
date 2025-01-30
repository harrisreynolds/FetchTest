class CharacterRule
  def process(receipt)
    # Use gsub with regex to remove non-alphanumeric chars, then count length
    receipt.retailer.gsub(/[^a-zA-Z0-9]/, '').length
  end
end