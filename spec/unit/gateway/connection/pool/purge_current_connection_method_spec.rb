require 'spec_helper'

describe Gateway::Connection::Pool, "#purge_current_connection!" do
  subject { connection }

  let(:gateway)   { mock('gateway') }
  let(:conn)      { mock('conn') }
  let(:connection){ described_class.new(gateway) }

  it_should_behave_like 'a #purge_current_connection! method'

  it "should call #trash_current! on pool" do
    connection.send(:pool).should_receive(:trash_current!)
    connection.purge_current_connection!
  end
end
