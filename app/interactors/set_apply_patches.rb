
class SetApplyPatches
  include Interactor

  def call
    context.apply_patches = true
  end
end
