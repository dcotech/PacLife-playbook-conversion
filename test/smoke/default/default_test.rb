# # encoding: utf-8

# Inspec test for recipe test::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
describe user('zabbix') do
  its('group') { should eq 'zabbix'}
  its('home') { should eq '/home/zabbix'}
  its('shell') { should eq '/bin/bash' }
end

describe directory('/home/zabbix/zabbix_agentd.d') do
  it { should exist }
end