# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

module Admin::BaseHelper
  
  # this is a custom version of the error_messages_for method, it's used
  # in preferences to create rails-esque error messages
  def gm_error_messages_for
    if !errors.empty?
      content_tag("div",
      content_tag(
      options[:header_tag] || "h2",
        "#{pluralize(errors.count, "error")} prohibited your preferences from being saved"
        ) +
        content_tag("p", "There were problems with the following fields:") +
        content_tag("ul", errors.full_messages.collect { |msg| content_tag("li", msg) }),
        "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation"
        )
    else
      ""
    end
  end
  
end