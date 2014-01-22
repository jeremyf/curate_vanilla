module Curate
  # Responsible for providing a means of looking up attribute related partials
  # such that we can reuse common partials within the scope:
  #
  #  render 'curate/form/attribute/article/title'
  #
  # By prepending Curate::Form::AttributeResolver to the controller's
  # view path, we will lookup the curate/form/attribute/article/title first
  # in "curate/form/attribute/article/title" then "curate/form/attribute/title"
  class FormResolver < ActionView::Resolver
    attr_reader :prefix_scope
    attr_reader :controller
    def initialize(controller, prefix_scope = /\Acurate\/form\//, *args)
      @controller = controller
      @prefix_scope = prefix_scope
      super(*args)
    end

    private
    def find_templates(name, prefix, partial, details)
      return [] unless partial
      return [] unless prefix =~ @prefix_scope
      visited_name = name
      return [] if details.fetch(:__skip__, []).include?(visited_name)
      details[:__skip__] ||= []
      details[:__skip__] << visited_name
      prefix_slugs = prefix.split('/')
      fragmented_prefixes = (1..prefix_slugs.length).collect {|i| prefix_slugs[0..i-1].join("/") }.reverse
      fragmented_prefixes.each_with_object([]) do |prefix_fragment, collector|
        begin
          collector << find_view_paths(name, prefix_fragment, partial, details)
        rescue ActionView::MissingTemplate
          collector
        end
      end
    end
    def find_view_paths(*args)
      @controller.view_paths.find(*args)
    end
  end
end