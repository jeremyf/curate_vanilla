require 'spec_helper'

module Curate
  describe FormAttributeResolver do
    before(:each) do
      @controller = Class.new(ApplicationController) do
        self.view_paths = [
          ActionView::FixtureResolver.new("curate/_title.html.erb" => "Curate/Title"),
          ActionView::FixtureResolver.new("curate/attribute/_title.html.erb" => "Curate/Attribute/Title"),
        ]

        prepend_view_path Curate::FormAttributeResolver.new(self, /\Acurate/)
      end.new
    end

    let(:controller) { @controller }
    let(:details) { {formats: [:html], locale: [:en], handlers: [:erb] } }
    let(:prefix_scope) { /\Acurate/ }
    subject { Curate::FormAttributeResolver.new(controller, prefix_scope) }

    it 'should ignore non-partials' do
      expect(subject.find_all('index', 'garble', false, details)).to be_empty
    end

    it 'should ignore non-matching scopes' do
      expect(subject.find_all('title', 'spam/curate/attribute', true, details)).to be_empty
    end

    it 'should resolve on partial with matching scope' do
      template = subject.find_all('title', 'curate/attribute', true, details).first

      # Note we found the better match in curate/attribute/_title as opposed to
      # curate/_title
      expect(template.source).to eq("Curate/Attribute/Title")
    end
  end
end
