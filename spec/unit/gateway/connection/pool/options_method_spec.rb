require 'spec_helper'

describe Gateway::Connection::Pool, "#options" do
  subject{ connection.send(:options) }

  let(:gateway)   { mock() }
  let(:conn)      { mock() }
  let(:options)   { {:foo => :bar} }
  let(:connection){ described_class.new(gateway, options) }

  it{ should_not be_nil }

  context "with options key :delete_proc" do
    subject{ connection.send(:options)[:delete_proc] }

    it{ should_not be_nil }

    it "should invoke #disconnect on gateway when called" do
      gateway.should_receive(:disconnect).with(conn)
      subject.call conn
    end
  end

end
