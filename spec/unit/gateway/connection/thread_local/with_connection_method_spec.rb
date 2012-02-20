require 'spec_helper'

describe Gateway::Connection::ThreadLocal, "#with_connection" do
  subject{ connection }

  let(:gateway)   { mock() }
  let(:conn)      { mock() }
  let(:connection){ described_class.new(gateway) }

  it_should_behave_like 'a #with_connection method'

  before do
    gateway.stub(:connect).and_return(conn)
  end

  it "invokes #connect on gateway at most once" do
    gateway.should_receive(:connect).once.with().and_return(conn)
    5.times { subject.with_connection {} }
  end
end
