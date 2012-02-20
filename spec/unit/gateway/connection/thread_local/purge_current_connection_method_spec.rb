require 'spec_helper'

describe Gateway::Connection::ThreadLocal, "#purge_current_connection!" do
  subject { connection }

  let(:gateway)   { mock('gateway') }
  let(:conn)      { mock('conn') }
  let(:connection){ described_class.new(gateway) }

  it_should_behave_like 'a #purge_current_connection! method'

  it "should remove conn from threa local" do
    subject.purge_current_connection!
    Thread.current[subject.send(:thread_local_connection_name)].should == nil
  end
end
