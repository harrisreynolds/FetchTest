class ReceiptsController < ApplicationController
  protect_from_forgery with: :null_session

  def process_receipt
    receipt = Receipt.new(params[:retailer], params[:purchaseDate], params[:purchaseTime], params[:total], params[:items])

    unless receipt.valid?
      render json: { error: 'Invalid receipt' }, status: 400
      return
    end

    ReceiptStore.add(receipt)
    render json: { id: receipt.id }
  end

  def points
    receipt = ReceiptStore.get(params[:id])

    if receipt.nil?
      render json: { error: 'Receipt not found' }, status: 404
      return
    end

    receipt.points = ::PointCounter.new.calculate_points(receipt) if receipt.points.nil?
    render json: { points: receipt.points }
  end
end
