RSpec.describe "compatibility" do
  context "for moved constants" do
    describe "::Ruby::Gemini::VERSION" do
      it "is mapped to ::Gemini::VERSION" do
        expect(Ruby::Gemini::VERSION).to eq(Gemini::VERSION)
      end
    end

    describe "::Ruby::Gemini::Error" do
      it "is mapped to ::Gemini::Error" do
        expect(Ruby::Gemini::Error).to eq(Gemini::Error)
        expect(Ruby::Gemini::Error.new).to be_a(Gemini::Error)
        expect(Gemini::Error.new).to be_a(Ruby::Gemini::Error)
      end
    end

    describe "::Ruby::Gemini::ConfigurationError" do
      it "is mapped to ::Gemini::ConfigurationError" do
        expect(Ruby::Gemini::ConfigurationError).to eq(Gemini::ConfigurationError)
        expect(Ruby::Gemini::ConfigurationError.new).to be_a(Gemini::ConfigurationError)
        expect(Gemini::ConfigurationError.new).to be_a(Ruby::Gemini::ConfigurationError)
      end
    end

    describe "::Ruby::Gemini::Configuration" do
      it "is mapped to ::Gemini::Configuration" do
        expect(Ruby::Gemini::Configuration).to eq(Gemini::Configuration)
        expect(Ruby::Gemini::Configuration.new).to be_a(Gemini::Configuration)
        expect(Gemini::Configuration.new).to be_a(Ruby::Gemini::Configuration)
      end
    end
  end
end
