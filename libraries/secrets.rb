module Secrets
  class << self
    def load(key,env)
      retries = 0
      while retries <= 5
        begin
          data_bag_key = Chef::EncryptedDataBagItem.load_secret(key)
          Chef::EncryptedDataBagItem.load('secrets', env, data_bag_key)
          break
        rescue => e
          retries += 1
          Chef::Log.fatal("Failed to load encrypted secrets:\n#{e.inspect}\nretrying (1/5)")
          if retries == 5
            raise
          end
          sleep 5
        end
      end
    end
  end
end
