shared_examples_for 'a #with_connection method' do
  before do
    gateway.stub(:connect).and_return(conn)
    gateway.stub(:disconnect).with(conn)
  end

  it "invokes #connect on gateway" do
    gateway.should_receive(:connect).with().and_return(conn)
    subject.with_connection { }
  end

  it "invokes #disconnect on gateway after block" do
    gateway.should_receive(:disconnect).with(conn)
    subject.with_connection { }
  end

  it "passes conn as argument into block" do
    subject.with_connection do |my_conn|
      my_conn.should == conn
    end
  end

end
