# Copyright (c) 2011-2015 Solano Labs All Rights Reserved

module Solano
  class SolanoCli < Thor
    desc "keys", "List SSH keys authorized for Solano CI"
    def keys
      user_details = solano_setup({:scm => false})

      begin
        if user_details then
          show_third_party_keys_details(user_details)
        end

        keys_details = @solano_api.get_keys
        show_keys_details(keys_details)
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::LIST_KEYS_ERROR
      end
    end

    desc "keys:add [NAME] [PATH]", "Authorize an existing keypair for Solano CI"
    method_option :dir, :type=>:string, :default=>nil
    define_method "keys:add" do |name, path|
      solano_setup({:scm => false})

      path = File.expand_path(path)

      output_dir = options[:dir] || ENV['SOLANO_GEM_KEY_DIR']
      output_dir ||= Default::SSH_OUTPUT_DIR

      begin
        keydata = Solano::Ssh.validate_keys name, path, @solano_api
        say Text::Process::ADD_KEYS_ADD % name
        result = @solano_api.set_keys({:keys => [keydata]})

        priv_path = path.sub(/[.]pub$/, '')
        say Text::Process::ADD_KEYS_ADD_DONE % [name, priv_path, result["git_server"] || Default::GIT_SERVER, priv_path]
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::ADD_KEYS_ERROR % name
      rescue SolanoError => e
        exit_failure e.message
      end
    end

    map "generate" => :gen
    desc "keys:gen [NAME]", "Generate and authorize a keypair for Solano CI"
    method_option :dir, :type=>:string, :default=>nil
    define_method "keys:gen" do |name|
      solano_setup({:scm => false})

      output_dir = options[:dir] || ENV['SOLANO_GEM_KEY_DIR']
      output_dir ||= Default::SSH_OUTPUT_DIR

      begin
        keydata = Solano::Ssh.validate_keys name, output_dir, @solano_api, true
        say Text::Process::ADD_KEYS_GENERATE % name

        result = @solano_api.set_keys({:keys => [keydata]})
        outfile = File.expand_path(File.join(output_dir, "identity.solano.#{name}"))
        say Text::Process::ADD_KEYS_GENERATE_DONE % [name, result["git_server"] || Default::GIT_SERVER, outfile]
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::ADD_KEYS_ERROR % name
      rescue SolanoError => e
        exit_failure e.message
      end
    end

    desc "keys:remove [NAME]", "Remove a key that was authorized for Solano CI"
    define_method "keys:remove" do |name|
      solano_setup({:scm => false})

      begin
        say Text::Process::REMOVE_KEYS % name
        result = @solano_api.delete_keys(name)
        say Text::Process::REMOVE_KEYS_DONE % name
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::REMOVE_KEYS_ERROR % name
      end
    end
  end
end  
