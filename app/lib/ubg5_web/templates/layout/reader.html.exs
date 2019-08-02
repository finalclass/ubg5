html lang: "en" do
  head do
    meta charset: "utf-8"
    meta http_equiv: "X-UA-Compatible", content: "IE=edge"
    meta name: "viewport", content: "width=device-width, initial-scale=1.0"
    title @book_short_name <> " " <> Integer.to_string(@chapter_number)
    style do
      partial @style_css
    end
  end

  body do
    cond do
      @show_chapters ->
        ul class: "chapters" do
          for chapter_num <- @book_chapters_numbers do
            li do
              a href: "/" <> @encoded_book_name <> "/" <> Integer.to_string(chapter_num),
                title: @book_name <> " " <> Integer.to_string(chapter_num) do
                text Integer.to_string(chapter_num)
              end
            end
          end
        end
      !@show_chapters ->
        ul class: "books" do
          for book <- @books do
            li do
              chapters_suffix = if book.nof_chapters > 1, do: "?chapters", else: ""
              a href: "/" <> book.encoded_name <> "/1" <> chapters_suffix,
                title: book.full_name,
                "data-nof_chapters": Integer.to_string(book.nof_chapters),
                "data-encoded-name": book.encoded_name do
                text book.short_name
              end
            end
          end
        end
    end # cond

    div class: "chapter-container" do
      div class: "chapter",
        "data-book-name": @book_name,
        "data-book-short-name": @book_short_name,
        "data-encoded-book-name": @encoded_book_name,
        "data-nt-index": @book_oblubienica_index,
        "data-ot-name": @book_biblehub_name,
        "data-chapter-number": @chapter_number do
        table class: "chapters-nav" do
          tr do
            td do
              if @prev_chapter_number do
                a class: "prev-chapter",
                  href: "/" <> @encoded_book_name <> "/" <> Integer.to_string(@prev_chapter_number) do
                  text "&laquo; rozdział " <> Integer.to_string(@prev_chapter_number)
                end
              end # if
            end # td

            td do
              cond do
                @show_chapters ->
                  a class: "show_chapters",
                    href: "/" <> @encoded_book_name <> "/" <> Integer.to_string(@chapter_number) do
                    text "księgi"
                  end
                !@show_chapters && length(@book_chapters_numbers) > 1 ->
                  a class: "show-chapters",
                    href: "/" <> @encoded_book_name <> "/" <> Integer.to_string(@chapter_number) <> "?chapters" do
                    text "rozdziały"
                  end
              end # cond
            end # td

            td do
              if @next_chapter_number do
                a class: "next-chapter",
                  href: "/" <> @encoded_book_name <> "/" <> Integer.to_string(@next_chapter_number) do
                  text "rozdział " <> Integer.to_string(@next_chapter_number) <> " &raquo;"
                end
              end
            end #td
          end # tr
        end # table

        h3 do
          text @book_name <> " " <> Integer.to_string(@chapter_number)
        end # h3

        for verse <- @verses do
          a class: "verse",
            href: "#" <> Integer.to_string(verse.number),
            "data-verse-number": Integer.to_string(verse.number) do
            div class: "verse-text" do
              text Integer.to_string(verse.number) <> " " <> verse.text
            end # .verse-text
          end # a.verse
        end # for
        
      end # .chapter
    end # .chapter-container

    div class: "flash-message" do
      span do
        text "Skopiowano"
      end # span
    end # div

    script do
      partial @scripts_js
    end

    style do
      partial @interlinear_link_css
    end
    
  end # body
end # html

