shared_examples_for 'a #with_connection method' do
  before do
    gateway.stub(:connect).and_return(conn)
    gateway.stub(:disconnect).with(conn)
  end

  it "passes conn as argument into block" do
    subject.with_connection{ |c| c.should == conn }
  end

  it "invokes #connect on gateway exactly once" do
    gateway.should_receive(:connect).once().with(no_args()).and_return(conn)
    subject.with_connection {}
  end
end
