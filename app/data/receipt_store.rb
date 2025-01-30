class ReceiptStore
  @@receipts = {}

  def self.add(receipt)
    @@receipts[receipt.id] = receipt
  end

  def self.get(id)
    @@receipts[id]
  end

  def self.print_receipts
    puts @@receipts.inspect
  end
end