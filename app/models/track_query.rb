class TrackQuery < ActiveRecord::Base
  include HTTParty
  base_uri 'api.kdniao.cc'

  EBUSINESSID = "1264684"
  APPKEY = "ed003bd5-fbb2-449d-a430-de71f7274328"

  def self.query_api
    request_data= {OrderCode:'',ShipperCode:'SF',LogisticCode:'589707398027'}.to_json
    params = {
        'EBusinessID' => EBUSINESSID,
        'RequestType' => '1002',
        'RequestData' =>  URI.encode(request_data) ,
        'DataType' => '2',
        'DataSign' => encrypt(request_data,APPKEY)
    }
   post("/Ebusiness/EbusinessOrderHandle.aspx", body: params)
  end

  def self.encrypt(content,key)
    URI.encode(Base64.strict_encode64(Digest::MD5.hexdigest("#{content}#{key}")))
  end



end