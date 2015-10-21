module SimpleForm
  module Components
    module Prepend
      def prepend(wrapper_options = nil)
        @prepend ||= options[:prepend].to_s.html_safe if options[:prepend].present?
      end

      def has_prepend?
        prepend.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Prepend)
