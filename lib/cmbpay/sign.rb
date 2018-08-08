require 'digest'

module Cmbpay
  module Sign
    def self.generate(params, options={})
      key = options.delete(:key)

      query = params[:jsonRequestData][:reqData].sort.map do |k, v|
        "#{k}=#{v}"
      end.compact.join('&')

      Digest::SHA256.hexdigest("#{query}&#{key || Cmbpay.key}")
    end

    def self.verify?(params, options = {})
      params = params.dup
      params = params.merge(options)
      sign = params.delete('sign') || params.delete(:sign)

      generate(params) == sign
    end
  end
end

