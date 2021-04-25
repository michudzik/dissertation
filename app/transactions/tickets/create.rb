module Tickets
  class CreateContract < Dry::Validation::Contract
    params do
      required(:note).filled(max_size?: 500)
      required(:title).filled(max_size?: 50)
      required(:department_id).filled
    end
  end

  class Create < ApplicationTransaction
    step :validate
    try :create_ticket, catch: ActiveRecord::ActiveRecordError

    private

    def validate(ticket_params)
      schema = CreateContract.new.call(ticket_params)
      return Success(ticket_params) if schema.success?

      Failure(schema)
    end

    def create_ticket(ticket_params)
      current_user.tickets.create(ticket_params)
    end
  end
end
