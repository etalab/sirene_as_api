class ApplyPatches < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Attempting to apply patches, one patch at a time' unless context.links.empty?
    interactor.call

    puts
  end

  def call
    # Sorting in case patch index displays links in wrong order
    context.links.sort.each do |patch_link|
      apply_patch_with_log_msgs(patch_link)
    end
  end

  def apply_patch_with_log_msgs(link)
    apply_patch_before_log_msg(link)

    ApplyPatch.new(link: link).call

    apply_patch_after_log_msg(link)
  end

  def apply_patch_before_log_msg(link)
    stdout_info_log "Attempting to apply patch #{patch_filename(link)}"
  end

  def patch_filename(link)
    link.split('/').last
  end

  def apply_patch_after_log_msg(link)
    stdout_success_log "Patch #{patch_filename(link)} applied with success"

    2.times { puts }
  end
end
