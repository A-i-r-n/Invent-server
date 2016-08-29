json.code (@user ? 0 : 1)
json.data do
  json.partial! 'jshare/user', user: @user
end