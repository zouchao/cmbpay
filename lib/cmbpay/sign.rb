require 'digest'

module Cmbpay
  module Sign
    def self.generate(params, options={})
      query = Utils.params_to_string(params)

      Digest::SHA256.hexdigest("#{query}&#{options.delete(:key) || Cmbpay.key}")
    end

    # The test environment public key is fixed
    SANDBOX_CMBPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZs4l8Ez3F4MG0kF7RRSL+pn8M
mxVE3nfdXzjx6d3rH8IfDbNvNRLS0X0b5iJnPyFO8sbbUo1Im4zX0M8XA0xnnviG
yn5E6occiyUXJRgokphWb5BwaYdVhnLldctdimHoJTk3NFEQFav3guygR54i3tym
rDc8lWtuG8EczVu8FwIDAQAB
-----END PUBLIC KEY-----
    EOF

    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)

      sign    = params.delete('sign')
      string  = Utils.params_to_string(params['noticeData'])
      pub_key = options[:pub_key] || SANDBOX_CMBPAY_RSA_PUBLIC_KEY

      rsa = OpenSSL::PKey::RSA.new(pub_key)
      rsa.verify('sha1', Base64.decode64(sign), string)
    end

  end
end
