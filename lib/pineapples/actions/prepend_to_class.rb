module Pineapples
  module Actions
    # Injects text right after the class definition. Since it depends on
    # insert_into_file, it's reversible.
    #
    # ==== Parameters
    # path<String>:: path of the file to be changed
    # klass<String|Class>:: the class to be manipulated
    # data<String>:: the data to append to the class, can be also given as a block.
    # config<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Examples
    #
    #   prepend_to_class "app/controllers/application_controller.rb", ApplicationController, "  filter_parameter :password\n"
    #
    #   prepend_to_class "app/controllers/application_controller.rb", ApplicationController do
    #     "  filter_parameter :password\n"
    #   end
    #
    def prepend_to_class(path, klass, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(after: /class #{klass}\n|class #{klass} .*\n/)
      insert_into_file(path, *(args << options), &block)
    end
  end
end
