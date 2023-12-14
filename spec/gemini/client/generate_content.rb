RSpec.describe Gemini::Client do
  describe "#generate_content" do
    context "with a prompt", :vcr do
      let(:prompt) { "How high is the sky?" }
      let(:max_tokens) { 5 }

      let(:response) do
        Gemini::Client.new.generate_content(
          parameters: {
            model: model,
            prompt: prompt
          }
        )
      end
      let(:text) { response.dig("parts", 0, "text") }
      let(:cassette) { "#{model} content #{prompt}".downcase }

      context "with model: gemini-pro" do
        let(:model) { "gemini-pro" }

        it "succeeds" do
          VCR.use_cassette(cassette) do
            require 'byebug';byebug
            expect(response["zcandidates"].empty?).to eq(false)
          end
        end
      end
    end
  end
end
