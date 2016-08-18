json.extract! lottery_record, :id,:code,:periods,:created_at, :updated_at

user = lottery_record.user
if user
  json.set! 'user' do
    json.partial! 'jshare/user',user: user
  end
end

lottery = lottery_record.lottery
if lottery
  json.set! 'lottery' do
    json.partial! 'jshare/lottery',lottery: lottery
  end
end