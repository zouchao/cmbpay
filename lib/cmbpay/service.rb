require 'json'
require 'rest_client'
module Cmbpay
  module Service
    # MB_APPQRPAY_GATEWAY_URL = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MB_APPQRPay'
    MB_APPQRPAY_GATEWAY_URL = 'http://121.15.180.66:801/netpayment/BaseHttp.dll?MB_APPQRPay'

   CREATE_MB_APPQRPAY_REQUIRED_PARAMS = %w( orderNo amount payNoticeUrl clientIP )
   def self.mb_appqrpay(req_data, options = {})
     # params = Utils.stringify_keys(params)
     check_required_params(req_data, CREATE_MB_APPQRPAY_REQUIRED_PARAMS)

     params = {
       charset: 'utf-8',
       jsonRequestData: {
         version: '1.0',
         signType: 'SHA-256',
         reqData: {
           merchantNo: options.delete(:merchantNo) || Cmbpay.merchant_no,
           branchNo: options.delete(:branchNo) || Cmbpay.branch_no,
           dateTime: Time.now.strftime('%Y%m%d%H%M%S'),
           date: Time.now.strftime('%Y%m%d'),
         }.merge(req_data)
       }
     }

     request_args(MB_APPQRPAY_GATEWAY_URL, sign_params(params, options))
   end

   class << self
     private

     def request_args(get_gateway_url, params, options = {method: :post})
       gateway_url = options.delete(:gateway_url) || get_gateway_url
       params[:jsonRequestData] = JSON.generate params[:jsonRequestData]
       {
         method: options[:method] || :post,
         url: get_gateway_url,
         payload: params,
       }
     end

     def sign_params(params, options = {})
       options[:key] ||= Cmbpay.key
       params[:jsonRequestData].merge!(
         'sign'      => Sign.generate(params, options)
       )
       params
     end

     def check_required_params(options, names)
       return unless Cmbpay.debug_mode?
       names.each do |name|
         warn("Cmbpay Warn: missing required option: #{name}") unless options.has_key?(name.to_sym)
       end
     end
   end
  end
end
