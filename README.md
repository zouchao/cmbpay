# Cmbpay
非官方sdk, 开发文档详见： [http://openhome.cmbchina.com/pay/Default.aspx][1]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cmbpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cmbpay

## Usage

### config

Create config/initializers/cmbpay.rb and put following configurations into it.
```ruby
# required
Cmbpay.merchant_no = 'YOUR_MERCHANT_NO'
Cmbpay.branch_no = 'YOUR_BRANCH_NO' # usually bank city area code
Cmbpay.key = 'YOUR_KEY'
Cmbpay.debug_mode = true # default is `true`
Cmbpay.sandbox_mode = false # cmbchina test environment, default is `false`
```

### APIs
Check official document for detailed request params and return fields

#### MB_APPQRPay
```ruby
# required fields
params = {
         :orderNo => "123124",
          :amount => "0.01",
    :payNoticeUrl => "http://baidu.com",
        :clientIP => "127.0.0.1"
}
r = Cmbpay::Service.mb_appqrpay params
# => {
#      :method => :post,
#         :url => "http://121.15.180.66:801/netpayment/BaseHttp.dll?MB_APPQRPay",
#     :payload => {
#                 :charset => "utf-8",
#         :jsonRequestData => "{\"version\":\"1.0\",\"signType\":\"SHA-256\",\"reqData\":{\"merchantNo\":\"YOUR_MERCHANT_NO\",\"branchNo\":\"YOUR_BRANCH_NO\",\"dateTime\":\"20180808110251\",\"date\":\"20180808\",\"orderNo\":\"123124\",\"amount\":\"0.01\",\"payNoticeUrl\":\"http://baidu.com\",\"clientIP\":\"127.0.0.1\"},\"sign\":\"50b51645e1b9201007511c5b11a8671c6ad8dde2eccb940e65da1ced414147dd\"}"
#     }
# }
```

### DoBusiness
```ruby
r = Cmbpay::Service.do_business

# => "{\"version\":\"1.0\",\"charset\":\"UTF-8\",\"sign\":\"1D79589FEBD0BBCDE326862A0AA1FCB5B06E10B694C9DB0FEFF1FC8F5B3E21BA\",\"signType\":\"SHA-256\",\"rspData\":{\"rspCode\":\"SUC0000\",\"rspMsg\":\"查询成功\",\"fbPubKey\":\"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZs4l8Ez3F4MG0kF7RRSL+pn8MmxVE3nfdXzjx6d3rH8IfDbNvNRLS0X0b5iJnPyFO8sbbUo1Im4zX0M8XA0xnnviGyn5E6occiyUXJRgokphWb5BwaYdVhnLldctdimHoJTk3NFEQFav3guygR54i3tymrDc8lWtuG8EczVu8FwIDAQAB\",\"dateTime\":\"20180824164250\"}}"
```

#### DoRefund
```ruby
params = {
          :date => "20160515",
       :orderNo => "9925343226347522701",
        :amount => '0.01',
    :operatorNo => "operatorNo", # Default is 9999
           :pwd => "pwd" # Default is your merchant no
}
r = Cmbpay::Service.do_refund params
# => "{\"version\":\"1.0\",\"charset\":\"UTF-8\",\"rspData\":{\"rspCode\":\"SUC0000\",\"rspMsg\":\"\",\"dateTime\":\"20160806150217\",\"bankSerialNo\":\"16280672300000000010\",\"currency\":\"10\",\"amount\":\"0.01\",\"refundRefNo\":\"608061000002\",\"bankDate\":\"20160806\",\"bankTime\":\"150052\",\"refundSerialNo\":\"123456789\",\"settleAmount\":\"0.01\",\"discountAmount\":\"0.01\"}}"
```


 [1]: http://openhome.cmbchina.com/pay/Default.aspx
