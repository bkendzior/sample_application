# Copyright (c) 2014, 2015 Solano Labs All Rights Reserved

module Solano
  class SolanoCli < Thor
    desc 'server', "displays the saved connection info"
    def server
      solano_setup({:scm => false, :login => false})
      self.class.display
    end

    desc 'server:set --host HOST [--port PORT] [--proto PROTO] [--insecure]', "saves connection info"
    method_option :host, type: :string, required: true
    method_option :port, type: :numeric, default: 443
    method_option :proto, type: :string, default: 'https'
    method_option :insecure, type: :boolean, default: false
    define_method 'server:set' do
      solano_setup({:scm => false, :login => false})
      self.class.write_params options
    end
  end
end
