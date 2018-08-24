require 'json'
require 'rest_client'
module Cmbpay
  module Service
    SANDBOX_MB_APPQRPAY_GATEWAY_URL = 'http://121.15.180.66:801/netpayment/BaseHttp.dll?MB_APPQRPay'
    MB_APPQRPAY_GATEWAY_URL = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MB_APPQRPay'

    SANDBOX_PUBLIC_URL = 'http://121.15.180.66:801/NetPayment_dl/BaseHttp.dll' # 公共apiurl(测试环境)
    SANDBOX_DO_BUSINESS_GATEWAY_URL = 'http://121.15.180.72/CmbBank_B2B/UI/NetPay/DoBusiness.ashx'
    SANDBOX_QUERY_SETTLED_ORDER_BY_MERCHANT_DATE_GATEWAY_URL  = "#{SANDBOX_PUBLIC_URL}?QuerySettledOrderByMerchantDate"
    SANDBOX_QUERY_ACCOUNTlIST_GATEWAY_URL                     = "#{SANDBOX_PUBLIC_URL}?QueryAccountList"
    SANDBOX_QUERY_SINGLE_ORDER_GATEWAY_URL                    = "#{SANDBOX_PUBLIC_URL}?QuerySingleOrder"
    SANDBOX_DO_REFUND_GATEWAY_URL                             = "#{SANDBOX_PUBLIC_URL}?DoRefund"
    SANDBOX_QUERY_REFUND_BY_DATE_GATEWAY_URL                  = "#{SANDBOX_PUBLIC_URL}?QueryRefundByDate"
    SANDBOX_QUERY_SETTLED_REFUND_GATEWAY_URL                  = "#{SANDBOX_PUBLIC_URL}?QuerySettledRefund"

    PUBLIC_URL = "https://payment.ebank.cmbchina.com/NetPayment/BaseHttp.dll" # 公共apiurl(生产环境)
    DO_BUSINESS_GATEWAY_URL = 'https://b2b.cmbchina.com/CmbBank_B2B/UI/NetPay/DoBusiness.ashx'
    QUERY_SETTLED_ORDER_BY_MERCHANT_DATE_GATEWAY_URL  = "#{PUBLIC_URL}?QuerySettledOrderByMerchantDate"
    QUERY_ACCOUNTlIST_GATEWAY_URL                     = "#{PUBLIC_URL}?QueryAccountList"
    QUERY_SINGLE_ORDER_GATEWAY_URL                    = "#{PUBLIC_URL}?QuerySingleOrder"
    DO_REFUND_GATEWAY_URL                             = "#{PUBLIC_URL}?DoRefund"
    QUERY_REFUND_BY_DATE_GATEWAY_URL                  = "#{PUBLIC_URL}?QueryRefundByDate"
    QUERY_SETTLED_REFUND_GATEWAY_URL                  = "#{PUBLIC_URL}?QuerySettledRefund"

    MB_APPQRPAY_REQUIRED_REQ_DATA = %w( orderNo amount payNoticeUrl clientIP )
    # 二维码支付API
    def self.mb_appqrpay(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, MB_APPQRPAY_REQUIRED_REQ_DATA)

      params = {
        'charset'         => 'utf-8',
        'jsonRequestData' => {
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
            'date'       => Time.now.strftime('%Y%m%d'),
          }.merge(req_data)
        }
      }

      request_args(get_gateway_url(__method__), sign_params(params, options))
    end

    # 查询招行公钥API
    def self.do_business(req_data={}, options = {})
      req_data = Utils.stringify_keys(req_data)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
            'txCode'     => 'FBPK'
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end


    QUERY_SETTLED_ORDER_BY_MERCHANT_DATE_REQUIRED_REQ_DATA = %w( beginDate endDate )
    # 按商户日期查询已结账订单API
    def self.query_settled_order_by_merchant_date(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, QUERY_SETTLED_ORDER_BY_MERCHANT_DATE_REQUIRED_REQ_DATA)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
            'operatorNo' => '9999',
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end


    QUERY_ACCOUNTlIST_REQUIRED_REQ_DATA = %w( date )
    # 查询入账明细API
    def self.query_accountList(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, QUERY_ACCOUNTlIST_REQUIRED_REQ_DATA)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
            'operatorNo' => '9999',
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end

    QUERY_SINGLE_ORDER_REQUIRED_REQ_DATA = %w( type date )
    # 查询单笔订单API
    def self.query_single_order(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, QUERY_SINGLE_ORDER_REQUIRED_REQ_DATA)
      if req_data['type'] == 'A'
        warn("Cmbpay Warn: must have bankSerialNo if type is A") unless req_data.keys.include? 'bankSerialNo'
      else
        warn("Cmbpay Warn: must have orderNo if type is B") unless req_data.keys.include? 'orderNo'
      end

      params = {
        'charset'  => 'utf-8',
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end

    DO_REFUND_REQUIRED_REQ_DATA = %w( date orderNo amount )
    # 退款API
    def self.do_refund(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, DO_REFUND_REQUIRED_REQ_DATA)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options[:merchantNo] || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
            'operatorNo' => '9999',
            'pwd' => options.delete(:merchantNo) || Cmbpay.merchant_no,
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end

    QUERY_REFUND_BY_DATE_REQUIRED_REQ_DATA = %w( beginDate endDate )
    # 按退款日期查询退款API
    def self.query_refund_by_date(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, QUERY_REFUND_BY_DATE_REQUIRED_REQ_DATA)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end

    QUERY_SETTLED_REFUND_REQUIRED_REQ_DATA = %w( type date )
    # 已处理退款查询API
    def self.query_settled_refund(req_data, options = {})
      req_data = Utils.stringify_keys(req_data)
      check_required_params(req_data, QUERY_SETTLED_REFUND_REQUIRED_REQ_DATA)
      params = {
        'jsonRequestData' => {
          'charset'  => 'utf-8',
          'reqData'  => {
            'merchantNo' => options.delete(:merchantNo) || Cmbpay.merchant_no,
            'branchNo'   => options.delete(:branchNo) || Cmbpay.branch_no,
            'dateTime'   => Time.now.strftime('%Y%m%d%H%M%S'),
          }.merge(req_data)
        }
      }
      request_remote(get_gateway_url(__method__), sign_params(params, options))
    end

    class << self
      private

      def get_gateway_url(method)
       prefix = Cmbpay.sandbox_mode ? 'SANDBOX_' : ''
       self.const_get("#{prefix}#{method.upcase}_GATEWAY_URL")
      end

      def request_args(gateway_url, params, options = {})
        gateway_url = options.delete(:gateway_url) || gateway_url
        params['jsonRequestData'] = JSON.generate params['jsonRequestData']
        {
          method: options[:method] || :post,
          url: gateway_url,
          payload: params,
        }
      end

      def request_remote(gateway_url, params, options = {})
        options = Cmbpay.extra_rest_client_options.merge(options)
        gateway_url = options.delete(:gateway_url) || gateway_url
        params['jsonRequestData'] = JSON.generate params['jsonRequestData']

        RestClient::Request.execute(
          {
            method: options[:method] || :post,
            url: gateway_url,
            payload: params,
            headers: { content_type: 'application/x-www-form-urlencoded' }
          }.merge(options)
        ).body
      end

      def sign_params(params, options = {})
        options[:key] ||= Cmbpay.key
        params['jsonRequestData'].merge!(
          'version'  => '1.0',
          'signType' => 'SHA-256',
          'sign'     => Sign.generate(params['jsonRequestData']['reqData'], options)
        )
        params
      end

      def check_required_params(params, names)
        return unless Cmbpay.debug_mode?
        names.each do |name|
          warn("Cmbpay Warn: missing required option: #{name}") unless params.has_key?(name)
        end
      end
    end
  end
end
