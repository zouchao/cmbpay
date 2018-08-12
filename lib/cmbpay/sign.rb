require 'digest'

module Cmbpay
  module Sign
    def self.generate(params, options={})
      key = options.delete(:key)

      query = params.sort.map do |k, v|
        "#{k}=#{v}"
      end.compact.join('&')
      p query
      Digest::SHA256.hexdigest("#{query}&#{key || Cmbpay.key}")
    end

    CMBPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZs4l8Ez3F4MG0kF7RRSL+pn8M
mxVE3nfdXzjx6d3rH8IfDbNvNRLS0X0b5iJnPyFO8sbbUo1Im4zX0M8XA0xnnviG
yn5E6occiyUXJRgokphWb5BwaYdVhnLldctdimHoJTk3NFEQFav3guygR54i3tym
rDc8lWtuG8EczVu8FwIDAQAB
-----END PUBLIC KEY-----
    EOF

    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')
      sign = params.delete('sign')
      string = params_to_string(params['noticeData'])
      public_key = options['public_key'] || CMBPAY_RSA_PUBLIC_KEY

      RSA.verify?(public_key, string, sign)
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end

  end
end

