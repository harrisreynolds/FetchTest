require 'rails_helper'

RSpec.describe ReceiptsController, type: :controller do
  describe 'POST #process_receipt' do
    let(:valid_params) do
      {
        retailer: "Target",
        purchaseDate: "2024-03-20",
        purchaseTime: "14:33",
        total: "35.35",
        items: [
          { shortDescription: "Mountain Dew", price: "1.99" },
          { shortDescription: "Pepsi", price: "2.49" }
        ]
      }
    end

    context 'with valid parameters' do
      it 'returns success and receipt id' do
        post :process_receipt, params: valid_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to include('id')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { valid_params.merge(retailer: nil) }

      it 'returns bad request status' do
        post :process_receipt, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Invalid receipt')
      end
    end
  end

  describe 'GET #points' do
    context 'basic functionality' do
      let(:receipt_id) { "valid-receipt-id" }
      let(:receipt) { Receipt.new("Target", "2024-03-20", "14:33", "35.35", []) }

      before do
        allow(ReceiptStore).to receive(:get).and_return(nil)
        allow(ReceiptStore).to receive(:get).with(receipt_id).and_return(receipt)
        allow_any_instance_of(PointCounter).to receive(:calculate_points).and_return(15)
      end

      context 'when receipt exists' do
        it 'returns points for the receipt' do
          get :points, params: { id: receipt_id }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq({ 'points' => 15 })
        end
      end

      context 'when receipt does not exist' do
        it 'returns not found status' do
          get :points, params: { id: 'non-existent-id' }
          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include('error' => 'Receipt not found')
        end
      end
    end

    context 'with a specific receipt example' do
      let(:specific_receipt_id) { "specific-test-id" }
      let(:specific_receipt) do
        Receipt.new(
          "Target",
          "2022-01-01",
          "13:01",
          "35.35",
          [
            { shortDescription: "Mountain Dew 12PK", price: "6.49" },
            { shortDescription: "Emils Cheese Pizza", price: "12.25" },
            { shortDescription: "Knorr Creamy Chicken", price: "1.26" },
            { shortDescription: "Doritos Nacho Cheese", price: "3.35" },
            { shortDescription: "   Klarbrunn 12-PK 12 FL OZ  ", price: "12.00" }
          ]
        )
      end

      before do
        RSpec::Mocks.space.proxy_for(ReceiptStore).reset
        RSpec::Mocks.space.proxy_for(PointCounter).reset
        
        allow(ReceiptStore).to receive(:get).with(specific_receipt_id).and_return(specific_receipt)
      end

      it 'calculates exactly 28 points for the sample receipt' do
        get :points, params: { id: specific_receipt_id }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({ 'points' => 28 })
      end

      it 'breaks down points correctly' do
        point_counter = PointCounter.new
        points = point_counter.calculate_points(specific_receipt)
        expect(points).to eq(28)
      end
    end

    context 'with another specific receipt example (M&M Corner Market)' do
      let(:mm_receipt_id) { "mm-market-receipt" }
      let(:mm_receipt) do
        Receipt.new(
          "M&M Corner Market",
          "2022-03-20",
          "14:33",
          "9.00",
          [
            { shortDescription: "Gatorade", price: "2.25" },
            { shortDescription: "Gatorade", price: "2.25" },
            { shortDescription: "Gatorade", price: "2.25" },
            { shortDescription: "Gatorade", price: "2.25" }
          ]
        )
      end

      before do
        RSpec::Mocks.space.proxy_for(ReceiptStore).reset
        RSpec::Mocks.space.proxy_for(PointCounter).reset
        
        allow(ReceiptStore).to receive(:get).with(mm_receipt_id).and_return(mm_receipt)
      end

      it 'calculates exactly 109 points for the sample receipt' do
        get :points, params: { id: mm_receipt_id }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({ 'points' => 109 })
      end

      it 'breaks down points correctly' do
        point_counter = PointCounter.new
        points = point_counter.calculate_points(mm_receipt)
        expect(points).to eq(109)
      end
    end
  end
end 