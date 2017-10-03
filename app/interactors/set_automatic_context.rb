class SetAutomaticContext
  include Interactor

  def call
    context.automatic_update = true
  end
end
