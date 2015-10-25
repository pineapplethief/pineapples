class BasePresenter < SimpleDelegator

  def initialize(model, view)
    @model = model
    @view = view
    super(model)
  end

  def class
    __getobj__.class
  end

  def h
    @view
  end


  protected

  def policy(record)
    h.policy(record)
  end

end
