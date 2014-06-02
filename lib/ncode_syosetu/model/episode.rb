require "erb"

module NcodeSyosetu
  module Model
    class Episode
      attr_accessor :title, :number, :body_html, :url

      def initialize(title, number, page)
        @url = page.uri.to_s
        @title = title
        @number = number

        begin
          require 'natto'
          require 'nkf'
          @nm = Natto::MeCab.new
        rescue
          @nm = nil
        end

        process_nodes(page.search(".novel_view"))
        @body_html =
          page.search(".novel_subtitle").to_xhtml <<
          page.search(".novel_view").to_xhtml
      end

      def process_nodes(nodes)
        unless @nm.nil?
          # if MeCab and natto available, add yomi annotation
          nodes.each { |n| process_node(n) }
        end
      end

      def process_node(node)
        unless node.node_name == 'ruby'
          if node.node_name == 'text'
            node.replace(annotate_text(node.text))
          else
            process_nodes(node.children)
          end
        end
      end

      def annotate_text(text)
        if text =~ /\A\s*\Z/
          text
        else
          memo = []
          text.gsub!(' ', '###') # mecab eats whitespaces
          @nm.parse(text) do |n|
            if n.char_type == 2                  # kanji
              yomi = n.feature.split(',')[-2]    # katakana yomi
              memo << "<ruby><rb>" + n.surface + "</rb><rp>(</rp><rt>" +
                NKF.nkf('-h1 -w', yomi) + "</rt><rp>)</rp></ruby>"
            else
              memo << n.surface                  # leave others alone
            end
          end
          memo.join.gsub('###', ' ')
        end
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
