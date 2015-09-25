class String
  def yes?
    self == 'yes' || self == 'ye' || self == 'yes'
  end

  def no?
    self == 'no' || self == 'n'
  end
end

module Pineapples
  module Helpers
    def ask_with_default(question, default, color = prompt_color)
      question = (question.split('?') << " [#{default}]?").join
      answer = ask(question, color)
      answer.to_s.strip.empty? ? default : answer
    end

    def ask_multiple(question, choices)
      say question, prompt_color
      choices.each_with_index do |choice, index|
        say "#{i}) #{choice}", options_color
      end
      ask 'Select one of the options above', select_color
    end

    def ask_option(key)
      option = fetch_option(key)

      if option.has_default?
        ask_with_default(question, option.default_text)
    end

    def preexisting_git_repo?
      @preexisting_git_repo ||= (File.exist?('.git') || :nope)
      @preexisting_git_repo == true
    end

    private

    def fetch_option(key)
      self.class.class_options[key]
    end

    def prompt_color
      :yellow
    end

    def options_color
      :cyan
    end

    def select_color
      :green
    end

  end
end
