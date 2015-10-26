module ApplicationHelper
  # Set current page title only <br>
  # @param page_title [String] Title string
  def title(page_title)
    content_for(:title) { page_title }
  end

  # Create Bootstrap-styled flash
  # @return [nil] nil
  def bootstrap_flash
    bootstrap_class_for = ->(type) do
      { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }[ type.to_sym ] || type.to_s
    end

    flash.each do |msg_type, msg|
      concat(
        content_tag(:div, msg, class: "alert #{bootstrap_class_for.(msg_type)} fade in") do
          concat content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' })
          concat msg
        end
      )
    end

    nil
  end
end
