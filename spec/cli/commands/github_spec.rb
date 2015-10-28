# Copyright (c) 2011, 2012, 2013, 2014 Solano Labs All Rights Reserved

require 'spec_helper'
require 'solano/cli'
require 'solano/cli/commands/github'

describe Solano::SolanoCli do
  describe "#github:migrate_hooks" do
    include_context "solano_api_stubs"

    it 'with empty suites' do
      solano_api.should_receive(:get_suites).and_return([])
      subject.should_receive(:exit_failure).with('You do not have any suites configured with solano')
      subject.send('github:migrate_hooks')
    end

    it 'with exist suites' do
      solano_api.should_receive(:get_suites).and_return([
        {'repo_ci_hook_key' => '', 'repo_name' => '', 'org_name' => ''}
      ])
      subject.should_receive(:say).with('Please enter your github credentials; we do not store them anywhere')
      HighLine.stub(:ask).and_return("somename")
      subject.should_receive(:say).with(/401 Bad credentials/)
      subject.send('github:migrate_hooks')
    end
  end
end
