class Curate::Deposit::WorksController < Curate::Deposit::ApplicationController
  respond_to :html
  layout 'curate_nd/1_column'

  class_attribute :responder, instance_predicate: false, instance_accessor: false
  self.responder = Curate::Deposit::WorksResponder
  prepend_view_path Curate::FormAttributeResolver.new(self)

  def new
    validate_request(work)
    assign_attributes(work)
    respond_with(work)
  end

  def create
    validate_request(work)
    assign_attributes(work)
    create_deposit(work)
    respond_with(work)
  end

  protected
  def work
    @work ||= Curate::Deposit.new_form_for(self, params.fetch(:work_type))
  end
  helper_method :work

  def validate_request(work)
    Curate::Deposit.authorize!(self, work)
  end

  def assign_attributes(work)
    work.attributes = params.fetch(:work) { Hash.new }
  end

  def create_deposit(work)
    work.save
  end

end
