module ActionView::Helpers
  class FormBuilder

    def inputs(options = {}, &block)
      update_options_with_class!(options, 'form-inputs')
      @template.content_tag(:div, options) { yield }
    end

    def actions(options = {}, &block)
      update_options_with_class!(options, 'form-actions')
      @template.content_tag(:div, options) { yield }
    end

    protected

    def update_options_with_class!(options, klass)
      options[:class] ||= ''
      class_string = options[:class].blank? ? klass : " #{klass}"
      options[:class] << class_string
      options
    end

  end
end
