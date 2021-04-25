require 'net/smtp'

module Comments
  class CreateContract < Dry::Validation::Contract
    params do
      required(:body).filled
    end
  end

  class Create < ApplicationTransaction
    SMTP_ERRORS = [
      Net::SMTPAuthenticationError,
      Net::SMTPServerBusy,
      Net::SMTPSyntaxError,
      Net::SMTPFatalError,
      Net::SMTPUnknownError
    ].freeze

    try :assign_ticket, catch: ActiveRecord::RecordNotFound
    check :closed
    step :validate
    try :create_comment, catch: ActiveRecord::ActiveRecordError
    try :change_ticket_status, catch: ActiveRecord::ActiveRecordError
    map :extract_ticket
    try :notify_users_via_email, catch: SMTP_ERRORS

    private

    def assign_ticket
      ::Ticket.find(current_params[:ticket_id])
    end

    def closed(ticket)
      ticket.open?
    end

    def validate(ticket)
      attr = { ticket_id: ticket.id, user_id: current_params[:user_id], body: current_params[:body] }
      schema = CreateContract.new.call(attr)
      return Success(attr) if schema.success?

      Failure(schema)
    end

    def create_comment(_args)
      ::Comment.create(current_params)
    end

    def change_ticket_status(comment)
      comment.update_ticket_status!(user: comment.user, ticket: comment.ticket)
      comment
    end

    def extract_ticket(comment)
      comment.ticket
    end

    def notify_users_via_email(ticket)
      UserNotifierService.new(ticket: ticket, current_user: current_user).call
      ticket
    end
  end
end
