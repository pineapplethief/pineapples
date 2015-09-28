module Pineapples
  module Helpers
    def preexisting_git_repo?
      @preexisting_git_repo ||= (File.exist?('.git') || :nope)
      @preexisting_git_repo == true
    end
  end
end
