json.code (@visitor_logs ? 0 : 1)
json.data do
  json.list(@visitor_logs) do |visitor_log|
    case visitor_log.parent
      when Product
        json.set! 'product' do
          json.partial! 'jshare/product', product: visitor_log.parent
        end
    end
  end
end