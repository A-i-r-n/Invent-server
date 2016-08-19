json.extract! lottery_record, :id,:code,:periods,:created_at, :updated_at

if lottery_record.user
  json.set! 'user' do
    json.partial! 'jshare/user',user: lottery_record.user
  end
end

if lottery_record.lottery
  json.set! 'lottery' do
    json.partial! 'jshare/lottery',lottery: lottery_record.lottery
  end
end