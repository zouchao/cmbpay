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



 [1]: http://openhome.cmbchina.com/pay/Default.aspx
