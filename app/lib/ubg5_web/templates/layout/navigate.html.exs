html lang: "en" do
  head do
    meta charset: "utf-8"
    meta http_equiv: "X-UA-Compatible", content: "IE=edge"
    meta name: "viewport", content: "width=device-width, initial-scale=1.0"
    title "Navigate"
    style """
     body {
         font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
     }
     .search-form {
         margin: 50px 30%;
     }

     .search-form label {
         width: 100%;
         display: flex
     }

     .search-submit {
         width: 100px;
         border: none;
     }
     .search-term {
         flex: 1;
         padding: 0 7px;
         border: solid 1px #777;
         margin-right: 5px;
     }
     .search-term:focus {
         outline: none;
         border-color: #7a7;
     }
     .search-term, .search-submit {
         height: 26px;
         line-height: 26px;
         border-radius: 5px;
         box-sizing: border-box;
     }
    """
  end

  body do

    form class: "search-form", action: "/navigate", method: "GET" do
      label for: "" do
        input class: "search-term", name: "verse", type: "text", value: ""
        input class: "search-submit", type: "submit", value: "Otwórz"
      end # label
    end #form

    script """
     var $searchTerm = document.querySelector('.search-term');
     /* var $searchForm = document.querySelector('.search-form'); */

     $searchTerm.focus();
     
     /* $searchForm.addEventListener('submit', function (event) {
      *     event.stopPropagation();
      *     event.preventDefault();

      *     console.log('EVENT', event);
      * }); */

    """
  end # body
end # html
