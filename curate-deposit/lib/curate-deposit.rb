module Curate::Deposit
  module_function
  def config
    Engine.config
  end

  def configure
    yield(config)
  end

  def new_form_for(work_type, options = {})
    @new_forms_for ||= {}
    @new_forms_for[work_type.to_sym] ||= begin
      configuration = options.fetch(:config) { config }
      finalizer = options.fetch(:finalizer) { Curate::FormFinalizer }
      work_config = configuration.new_form_for(work_type)
      finalizer.call(work_type, work_config)
    end.new
  end

  def authorize!(controller, work)
    true
  end

end

require "curate/deposit/engine"
require 'curate/deposit/works_responder'
require 'virtus'
