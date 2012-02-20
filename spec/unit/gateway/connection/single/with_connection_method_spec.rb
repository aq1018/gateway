require 'spec_helper'

describe Gateway::Connection::Single, "#with_connection" do
  subject{ connection }

  let(:gateway)    { mock('gateway') }
  let(:conn)       { mock('conn') }
  let(:connection) { described_class.new(gateway) }

  it_should_behave_like 'a #with_connection method'

  before do
    gateway.stub(:connect).and_return(conn)
  end

  it "invokes #disconnect on gateway" do
    gateway.should_receive(:disconnect).with(conn)
    subject.with_connection {}
  end
end
