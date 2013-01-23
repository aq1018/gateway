require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Gateway" do
  describe "Performance" do
    before do
      @profiler = Class.new do
        attr_reader :args
        def performance(*args) @args = args end
      end.new

      @class = Class.new do
        include Gateway::Feature::Performance

        attr_accessor :profiler
        def name() 'hi' end
        def initialize(p) @profiler = p end
      end

      @performer = @class.new @profiler
    end

    it "handles local jumps" do
      def @performer.with_perf(*a) super{ return } end

      @performer.with_perf(:foo, :req, {})

      @performer.profiler.args.should eq ['hi', anything, 200, 'OK', 'FOO req']
    end

    it "handles local jumps with errors" do
      def @performer.with_perf(*a) super{ raise 'hi' } end

      expect { @performer.with_perf(:foo, :req, {}) }.to raise_error RuntimeError

      @performer.profiler.args.should eq ['hi', anything, 500, 'RuntimeError - hi', 'FOO req']
    end
  end
end
