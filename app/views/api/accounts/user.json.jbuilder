json.code (@user ? 0 : 1)
json.data do
  json.extract! @user, :id,:login,:idcard,:email,:name,:real_name,:sex,:phone,:birthday,:location,:slogan,:company,:job,:created_at, :updated_at
  avatar = @user.avatar
  if avatar then  json.avatar image_url(avatar.file.url) end
end