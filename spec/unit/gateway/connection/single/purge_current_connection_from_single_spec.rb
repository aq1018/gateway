require 'spec_helper'

describe Gateway::Connection::Single, "#purge_current_connection_from_single!" do
  subject { described_class.new(gateway)  }

  let(:gateway) { mock() }
  let(:conn)    { mock() }

  it_should_behave_like 'a #purge_current_connection_from_single! method'

  it "should do nothing" do
    subject.purge_current_connection_from_single!
  end
end
