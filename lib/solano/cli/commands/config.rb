# Copyright (c) 2011-2015 Solano Labs All Rights Reserved

module Solano
  class SolanoCli < Thor
    desc "config [suite | repo | org[:ACCOUNT]]", "Display config variables.
    The scope argument can be 'suite', 'repo', 'org' (if you are a member of
    one organization), or 'org:an_organization_name' (if you are a member of
    multiple organizations). The default is 'suite'."
    def config(scope="suite")
      params = {:repo => true}
      if scope == 'suite' then
        params[:suite] = true
      end
      solano_setup(params)

      begin
        config_details = @solano_api.get_config_key(scope)
        show_config_details(scope, config_details['env'])
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::LIST_CONFIG_ERROR
      rescue Exception => e
        exit_failure e.message
      end
    end

    desc "config:add [SCOPE] [KEY] [VALUE]", "Set KEY=VALUE at SCOPE.
    The scope argument can be 'suite', 'repo', 'org' (if you are a member of
    one organization), or 'org:an_organization_name' (if you are a member of
    multiple organizations)."
    define_method "config:add" do |scope, key, value|
      params = {:repo => true}
      if scope == 'suite' then
        params[:suite] = true
      end
      solano_setup(params)

      begin
        say Text::Process::ADD_CONFIG % [key, value, scope]
        result = @solano_api.set_config_key(scope, key, value)
        say Text::Process::ADD_CONFIG_DONE % [key, value, scope]
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::ADD_CONFIG_ERROR
      rescue Exception => e
        exit_failure e.message
      end
    end

    desc "config:remove [SCOPE] [KEY]", "Remove config variable NAME from SCOPE."
    define_method "config:remove" do |scope, key|
      params = {:repo => true}
      if scope == 'suite' then
        params[:suite] = true
      end
      solano_setup(params)

      begin
        say Text::Process::REMOVE_CONFIG % [key, scope]
        result = @solano_api.delete_config_key(scope, key)
        say Text::Process::REMOVE_CONFIG_DONE % [key, scope]
      rescue TddiumClient::Error::API => e
        exit_failure Text::Error::REMOVE_CONFIG_ERROR
      rescue Exception => e
        exit_failure e.message
      end
    end
  end
end
