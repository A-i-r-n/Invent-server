json.code 0 if @products
json.data do
  json.list(@products) do |product|

    json.partial! 'jshare/product', product: product

    attachment = product.attachments.order(id: :asc).first
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end

  json.page params[:page]
end