class Curate::Deposit::WorksController < Curate::Deposit::ApplicationController
  respond_to :html
  layout 'curate_nd/1_column'

  class_attribute :responder, instance_predicate: false, instance_accessor: false
  self.responder = Curate::Deposit::WorksResponder
  prepend_view_path Curate::FormAttributeResolver.new(self)

  def new
    validate_request(new_work)
    assign_attributes(new_work)
    respond_with(new_work)
  end

  def create
    validate_request(new_work)
    assign_attributes(new_work)
    create_deposit(new_work)
    respond_with(new_work)
  end

  def edit
    validate_request(existing_work)
    assign_attributes(existing_work)
    respond_with(existing_work)
  end

  def update
    validate_request(existing_work)
    assign_attributes(existing_work)
    update_deposit(existing_work)
    respond_with(existing_work)
  end

  protected
  def new_work
    @work ||= Curate::Deposit.new_form_for(self, params.fetch(:work_type))
  end

  def existing_work
    @work ||= Curate::Deposit.existing_form_for(self, params.fetch(:id))
  end

  attr_reader :work
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

  def update_deposit(work)
    work.save
  end

end
