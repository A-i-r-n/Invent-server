json.code (@shares ? 0 : 1)
json.data do
  json.list(@shares) do |share|
    case share.parent
      when Product
        json.set! 'product' do
          json.partial! 'jshare/product', product: share.parent
        end
    end
  end
end