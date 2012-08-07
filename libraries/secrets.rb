module Secrets
  class << self
    def load(key,env)
      begin
        data_bag_key = Chef::EncryptedDataBagItem.load_secret(key)
        Chef::EncryptedDataBagItem.load('secrets', env, data_bag_key)
      rescue => e
        Chef::Log.fatal("Failed to load encrypted secrets:\n#{e.inspect}")
        raise
      end
    end
  end
end
