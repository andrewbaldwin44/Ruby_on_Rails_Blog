module ApplicationHelper
    def render_markdown(content)
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
        html = markdown.render(content)

        apply_styles(html).html_safe
    end

    private

    def apply_styles(html)
      html.gsub!('<a', '<a class="link"')

      html
    end
end
