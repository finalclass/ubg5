html lang: "en" do
  head do
    meta charset: "utf-8"
    meta http_equiv: "X-UA-Compatible", content: "IE=edge"
    meta name: "viewport", content: "width=device-width, initial-scale=1.0"
    title "Projektor"
    style """
     html,
     body {
         font-family: Tahoma, sans-serif;
         height: 100%;
         margin: 0;
         padding: 0
     }
     .hidden {
         display: none;
     }
     .instruction {
         overflow: hidden;
         padding: 0 20px;
     }
     .container {
         padding: 20px;
         display: flex;
         line-height: 2em;
         flex-direction: column;
         align-items: center;
         justify-content: center;
         height: 100%;
         box-sizing: border-box;
     }
     .container.hidden {
         display: none;
     }
     .container p {
         margin: 0;
         paddin: 0;
     }
     .verse {
         text-align: center;
         line-height: 2em;
     }
     .verse-address {
         text-align: center;
         font-style: italic;
     }
     .book-name:after {
         content: ' ';
     }
     .chapter-number:after {
         content: ':'
     }
    """ # style
  end # head
  body "data-proj-id": @proj_id do
    aside class: "instruction" do
      h1 "Projektor Biblii"
      h3 "Jak to działa?"
      p "Otwórz Biblię korzystając z poniższego linku:"
      a href: "",
        target: "_blank",
        class: "controller-link" do
        LINK
      end
      p "(Projektor można kontrolować tylko wchodząc na Biblię z powyższego linku)"
      p "Następnie jeśli w tamtej otwartej Biblii klikniesz wybrany werset to będzie on wyświetlony w tym oknie"
      p "Aby rozpocząć wyświetlanie wersetów, nacisnij przycisk:"
      button class: "start-button" do
        text "Rozpocznij"
      end
      p do
        text "Id projektora: "
        span class: "projector-id"
      end
    end

    div class: "container hidden" do
      p class: "verse"
      p class: "verse-address" do
        span class: "book-name"
        span class: "chapter-number"
        span class: "verse-number"
      end
    end

    script """
    var projId = sessionStorage.getItem('projId') || document.body.dataset.projId;
     var $startButton = document.querySelector('.start-button');
     var $instruction = document.querySelector('.instruction');
     var $verse = document.querySelector('.verse');
     var $bookName = document.querySelector('.book-name');
     var $chapterNumber = document.querySelector('.chapter-number');
     var $verseNumber = document.querySelector('.verse-number');
     var $projectorId = document.querySelector('.projector-id');
     var $controllerLink = document.querySelector('.controller-link');
     var $container = document.querySelector('.container');
     
     $projectorId.innerText = projId;
     sessionStorage.setItem('projId', projId);
     var controllerUrl = location.protocol + '//' + location.host + '/?proj_id=' + projId;
     $controllerLink.setAttribute('href', controllerUrl);
     $controllerLink.innerText = controllerUrl;
     
     $startButton.addEventListener('click', function () {
         $instruction.classList.add('hidden');
         $container.classList.remove('hidden');
         pollingLoop();
     });

     function pollingLoop() {
         fetch('/projector?proj_id=' + projId)
             .then(result => result.text())
             .then(text => {
                 var split = text.split(';');
                 var verseText = split.slice(3).join(';');
                 if (verseText.length === 0) {
                     $container.classList.add('hidden');
                 } else {
                     $container.classList.remove('hidden');
                     $bookName.innerText = split[0]
                     $chapterNumber.innerText = split[1];
                     $verseNumber.innerText = split[2];
                     $verse.innerText = verseText;
                 }
                 setTimeout(pollingLoop, 1000);
             })
             .catch(err => {
                 setTimeout(pollingLoop, 1000);
             });
     }
    """
    
    
  end # body
end # html
