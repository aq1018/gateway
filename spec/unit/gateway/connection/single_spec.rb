require 'spec_helper'

describe Gateway::Connection::Single do
  subject { Gateway::Connection::Single.new(gateway)  }

  let(:gateway) { mock() }
  let(:conn)    { mock() }

  it_should_behave_like 'a #with_connection method'
end
