module Secrets
  class << self
    def load(key,env='_default')
      if Chef::Config.solo
        return data_bag_item('secrets','solo')
      else
        retries = 0
        while retries <= 5
          begin
            data_bag_key = Chef::EncryptedDataBagItem.load_secret(key)
            return Chef::EncryptedDataBagItem.load('secrets', env, data_bag_key)
            break
          rescue => e
            retries += 1
            Chef::Log.fatal("Failed to load encrypted secrets:\n#{e.inspect}\nretrying (#{retries}/5)")
            if retries == 5
              raise
            end
            sleep 5
          end
        end
      end
    end
  end
end
