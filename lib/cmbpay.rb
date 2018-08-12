require "cmbpay/version"
require "Cmbpay/service"
require "Cmbpay/utils"
require "Cmbpay/sign"

module Cmbpay
  @sign_type = 'SHA-256'
  @sandbox_mode = false
  @debug_mode = true
  @extra_rest_client_options = {}

  class << self
    attr_accessor :merchant_no, :branch_no, :key, :sign_type, :extra_rest_client_options, :sandbox_mode, :debug_mode


    def debug_mode?
      !!@debug_mode
    end
  end
end
