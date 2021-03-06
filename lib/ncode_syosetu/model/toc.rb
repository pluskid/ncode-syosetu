module NcodeSyosetu
  module Model
    class Toc
      attr_accessor :title, :author, :abstract, :url, :episodes

      def initialize(page)
        @url = page.uri.to_s
        @title = page.title
        @author = page.search(".novel_writername").text.chomp
        @abstract = page.search(".novel_ex").text.chomp

        @episodes = []
        page.search("dd.subtitle a").each do |sub_item|
          episode = { text: sub_item.text.gsub(/\s+/, " ").chomp }
          if sub_item.attr("href") =~ %r[/(\d+)/?$]
            episode[:number] = $1.to_i
          end
          @episodes << episode
        end

        @body_html =
          page.search(".novel_writername").to_xhtml <<
          page.search(".novel_ex").to_xhtml <<
          page.search(".index_box").to_xhtml
      end

      def html
        <<-HTML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>#{@title}</title>
</head>
<body>

#{@body_html}

</body>
</html>
        HTML
      end
    end
  end
end
