require 'spec_helper'

describe Gateway::Connection::Single, "#with_connection" do
  subject { described_class.new(gateway)  }

  let(:gateway) { mock() }
  let(:conn)    { mock() }

  it_should_behave_like 'a #with_connection method'
end
