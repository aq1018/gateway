require 'spec_helper'

describe Gateway::Connection::Single, "#purge_current_connection!" do
  subject { connection }

  let(:gateway)   { mock('gateway') }
  let(:conn)      { mock('conn') }
  let(:connection){ described_class.new(gateway) }

  it_should_behave_like 'a #purge_current_connection! method'

  it "should do nothing" do
    subject.purge_current_connection!
  end
end
