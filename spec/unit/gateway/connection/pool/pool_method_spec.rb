require 'spec_helper'

describe Gateway::Connection::Pool, "#pool" do
  subject { connection.send :pool }

  let(:gateway)   { mock('gateway') }
  let(:conn)      { mock('conn') }
  let(:connection){ described_class.new(gateway) }

  it { should_not be_nil }

  its(:class) { should == ResourcePool }

  # check for memoization
  it { should === connection.send(:pool)}
end
