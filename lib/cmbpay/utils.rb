module Cmbpay
  module Utils
    def self.stringify_keys(hash)
      new_hash = {}
      hash.each do |key, value|
        new_hash[(key.to_s rescue key) || key] = value
      end
      new_hash
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end
  end
end
