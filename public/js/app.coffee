
console.log("app.coffee")


### Setup and Constants###

BOOK_TEXT = 
"The cats nestle close to their kittens,\n
The lambs have laid down with the sheep.\n
You are cozy and warm in your bed, my dear.\n
Please go the fuck to sleep.\n
\n
The windows are dark in the town, child.\n
The whales huddle down in the deep.\n
I'll read you one very last book if you swear\n
You'll go the fuck to sleep.\n
\n
The eagles who soar through the sky are at rest\n
And the creatures who crawl, run and creep.\n
I know you're not thirsty. That's bullshit. Stop lying.\n
Lie the fuck down, my darling, and sleep.\n
\n
The wind whispers soft through the grass, hon.\n
The field mice, they make not a peep.\n
It's been thirty-eight minutes already.\n
Jesus Christ, what the fuck? Go to sleep.\n
\n
All the kids from day care are in dreamland.\n
The froggie has made his last leap.\n
Hell no, you can't go to the bathroom.\n
You know where you can go? The fuck to sleep.\n
\n
The owls fly forth from the treetops.\n
Through the air they soar and they sweep.\n
The hot, crimson rage fills my heart, love.\n
For real: shut the fuck up and sleep.\n
\n
The cubs and the lions are snoring (snore)\n
Wrapped in a big, snuggly heap.\n
How come you can do all this other great shit\n
But you can't lie the fuck down and sleep?\n
\n
The seeds slumber beneath the earth now,\n
And the crops that the farmers will reap.\n
No more questions, this interview's over.\n
I've got two words for you, kid: fucking sleep.\n
\n
The tiger reclines in the Siberian jungle.\n
The sparrow has silenced her cheep.\n
Fuck your stuffed bear, I'm not getting you shit.\n
Close your eyes, cut the crap: sleep.\n
\n
Flowers doze low in the meadows\n
And high on the mountains so steep.\n
My life is a failure, I'm a shitty-ass parent.\n
Stop fucking with me please, and sleep.\n
\n
The giant pangolins of Madagascar are snoozing\n
As I lie here and openly weep.\n
Sure, fine, whatever, I'll bring you some milk.\n
Who the fuck cares? You're not gonna sleep.\n
\n
This room is all I can remember.\n
The furniture crappy and cheap.\n
You win! You escape, you run down the hall\n
As I nod the fuck off and sleep.\n
\n
Bleary and dazed I awaken\n
To find your eyes shut, so I keep\n
My fingers crossed tight, as I tip-toe away\n
And pray that you're fucking asleep.\n
\n
We're finally watching our movie.\n
Popcorn's in the microwave: \"beep!\"\n
Oh shit, goddamn it, you've got to be kidding.\n
Go the fuck back to sleep!\n"

window.BOOK_TEXT = BOOK_TEXT;
ART_LINE_CLASS = 'art-line'
Color = net.brehaut.Color;
generateShit = true
useText = true;

# if useText
    # generateShit = false


body = document.querySelector('body')
wordIndex = 0;
splitText = BOOK_TEXT.split(/\n| /)

getWord = ->
    if wordIndex >= splitText.length
        wordIndex = 0
        return ""
    return splitText[wordIndex++]

setPoemWord = (elem, elemType, nextWord) ->
    if elemType is 'select'
        option = document.createElement('option')
        option.textContent = nextWord
        elem.appendChild(option)
    if elemType is 'submit'
        elem.value = nextWord;
        return
    else 
        elem.value = nextWord


addRandomShit = () ->
    # console.log "bottom"
    newElem = inputElemFromType(randomInputElement())
    # if newElem.type is 'checkbox' or newElem.type is 'radio'
    #     j = Math.round(Math.random() * 2)
    #     copy = coinToss()
    #     body.appendChild(newElem)
    #     while j >= 0
    #         newerElem = document.createElement(newElem.type)
            # newerElem = inputElemFromType(newElem.type)
            # newerElem.checked = if copy then newElem.checked else coinToss()
            # newerElem.checked = true;
            # body.appendChild(newerElem)
            # j--
    # else 
    body.appendChild(newElem)

    # cleanRandomShit()

intializeRandomShit = () ->
    # for num in [0..600]
    for num in [0..splitText.length]
        addRandomShit()

    if generateShit
        $(window).scroll ->
            if $(window).scrollTop() + $(window).height() + 100 > $(document).height()
                for num in [0..30]
                    addRandomShit();

# cleanRandomShit = () ->
#     if body.childNodes.length > 2200
#         console.log "cleaning up"
#         $('.random-shit:above-the-top').remove()


randomInputElement = () ->
    inputTypes = ['submit','password', 'select', 'input', 'radio', 'checkbox', 'submit']
    # inputTypes = ['submit','password', 'select', 'input', 'textarea', 'radio', 'checkbox', 'button', 'textarea']
    elemType = inputTypes[Math.floor(inputTypes.length * Math.random())]
    return elemType

inputElemFromType = (elemType) ->
    elem = undefined;
    # console.log(elemType)
    if elemType is 'select'
        elem = document.createElement('select')
    else 
        elem = document.createElement('input')
        elem.type = elemType
        elem.value = "   "
        if elemType is 'checkbox' or elemType is 'radio'
            elem.checked = coinToss();
            # elem.checked = true;

    randomClasses = ["random-1", "random-2", "random-3"]
    randomClass = randomClasses[Math.floor(randomClasses.length * Math.random())]
    elem.className += "random-shit " + randomClass

    nextWord = getWord();
    if nextWord is ""
        elem = document.createElement("br")
    else 
        if useText
            setPoemWord(elem, elemType, nextWord)

    return elem

coinToss = () ->
    result =  Math.round(Math.random()) is 1
    return result

traverseRandomShit = () ->
    #this will go down them and then die...
    inputIndex = 0

    focusElem = () ->
        initialList = document.querySelectorAll('.random-shit')
        elem = initialList[inputIndex]
        if elem != undefined
            elem.focus()
            inputIndex++
            elem.checked = false;
            if elem.type == 'submit'
                elem.value = "   "
            else 
                elem.value = ""
        # elem.checked = !elem.checked;
        # console.log('foo')
        timeout = 60
        if elem != undefined
            if elem.type is 'radio' or elem.type is 'checkbox'
                timeout = 40
        window.setTimeout( ->
            focusElem()
        , timeout + Math.round(Math.random() * 100))

    focusElem()


### Execution ###

intializeRandomShit()
traverseRandomShit()

# window.setTimeout( ->
#     $.ajax({
#         url: "",
#         context: document.body,
#         success: (s,x) -> 
#             $(this).html(s);
#     });
# , 1000 )

# new tab
# virus
# art statements
# statements about internet legals
# http://www.artybollocks.com/#home
# http://www.elsewhere.org/pomo/
