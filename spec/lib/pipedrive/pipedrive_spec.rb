# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive do
  describe "#raise_error" do
    shared_examples_for "error" do |code, klass, context|
      let(:message) do
        [context.dig(:error), context.dig(:error_info)]
          .compact
          .join(". ")
      end

      it "raises error" do
        expect do
          described_class.raise_error(code, context)
        end.to raise_error(klass, /#{message}/)
      end
    end

    describe "error codes" do
      it_behaves_like "error",
                      400,
                      Pipedrive::BadRequestError,
                      error: "Bad Request"

      it_behaves_like "error",
                      401,
                      Pipedrive::UnauthorizedError,
                      error: "Invalid API token"

      it_behaves_like "error",
                      402,
                      Pipedrive::PaymentRequiredError,
                      error: "Payment Required",
                      error_info: "Company account is not open"

      it_behaves_like "error",
                      403,
                      Pipedrive::ForbiddenError,
                      error: "Forbidden",
                      error_info: "Request not allowed."

      it_behaves_like "error",
                      404,
                      Pipedrive::NotFoundError,
                      error: "Not Found",
                      error_info: "Resource unavailable"

      it_behaves_like "error",
                      405,
                      Pipedrive::MethodNotAllowedError,
                      error: "Method not allowed",
                      error_info: "Incorrect request method"

      it_behaves_like "error",
                      410,
                      Pipedrive::GoneError,
                      error: "Gone",
                      error_info: "Old resource permanently unavailable"

      it_behaves_like "error",
                      415,
                      Pipedrive::UnsupportedMediaTypeError,
                      error: "Unsupported Media Type",
                      error_info: "Feature is not enabled"

      it_behaves_like "error",
                      422,
                      Pipedrive::UnprocessableEntityError,
                      error: "Unprocessable entity",
                      error_info: "Webhooks limit reached"

      it_behaves_like "error",
                      429,
                      Pipedrive::TooManyRequestsError,
                      error: "Too Many Requests",
                      error_info: "Rate limit has been exceeded"

      it_behaves_like "error",
                      500,
                      Pipedrive::InternalServerError,
                      error: "Internal Server Error",
                      error_info: "Generic server error"

      it_behaves_like "error",
                      501,
                      Pipedrive::NotImplementedError,
                      error: "Not Implemented",
                      error_info: "Non-existent functionality"

      it_behaves_like "error",
                      503,
                      Pipedrive::ServiceUnavailableError,
                      error: "Service Unavailable",
                      error_info: "Scheduled maintenance"

      it_behaves_like "error",
                      1000,
                      Pipedrive::UnkownAPIError,
                      error: "Unknown error",
                      error_info: "Error not mapped"
    end

    describe "error data" do
      let(:response) do
        {
          error: "Bad request",
          data: "Error data",
          additional_data: { "abc" => 123 },
        }
      end

      it "includes data and additional data into the error" do
        described_class.raise_error(1000, response)
      rescue StandardError => e
        data = e.data
        expect(data).to include("Error data")
        expect(data).to include("abc")
        expect(data).to include("123")
      end
    end
  end
end
