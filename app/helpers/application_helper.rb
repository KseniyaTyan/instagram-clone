module ApplicationHelper
    def full_title(title)
        " | " + title unless title.empty?
    end
end
