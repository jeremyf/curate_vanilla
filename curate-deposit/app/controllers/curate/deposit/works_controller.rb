class Curate::Deposit::WorksController < Curate::Deposit::ApplicationController

  respond_to :html
  class_attribute :responder, instance_predicate: false, instance_accessor: false
  self.responder = Curate::Deposit::WorksResponder
  prepend_view_path Curate::FormAttributeResolver.new(self)

  def new
    authorize_action!
    assign_attributes
    respond_with_work
  end

  def create
    authorize_action!
    assign_attributes
    save_work
    respond_with_work
  end

  protected
  def work
    @work ||= Curate::Deposit.new_form_for(params.fetch(:work_type))
  end
  helper_method :work

  def authorize_action!
    Curate::Deposit.authorize!(self, work)
  end

  def assign_attributes
    work.attributes = params.fetch(:work) { Hash.new }
  end

  def save_work
    work.save
  end

  def respond_with_work
    respond_with(work)
  end


end
