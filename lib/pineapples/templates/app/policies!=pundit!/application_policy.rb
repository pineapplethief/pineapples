class ApplicationPolicy
  attr_reader :user

  def initialize(user, model)
    @user = user
  end

  def index?
    false
  end

  # def show?
  #   scope.where(id: record.id).exists?
  # end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

end