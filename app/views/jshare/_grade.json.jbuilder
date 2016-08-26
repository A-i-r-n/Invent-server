json.extract! grade,:id,:score,:content,:created_at

if grade.user
  json.set! 'user' do
    json.partial! 'jshare/user' ,user: grade.user
  end
end