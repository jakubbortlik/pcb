#
#     Phonetic Corpus Builder: a Praat script for the creation of sound corpora.
#
#     Copyleft (ɔ) 2015 Jakub F. Bortlík
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#     If you wish to contact the author you can do so here:
#     jakub.bortlik(at)gmail.com
#
#     README
#     For the .wav to .mp3 conversion to work you have to have the lame codec
#     installed on your computer. On GNU/linux it has to be in your $PATH
#     environment variable. On Windows, by default, you should have in the
#     folder with this script a subdirectory "lame" with lame.exe in it. If you
#     have "lame.exe" installed elsewhere on your computer, you should change
#     the path to it in the script below.
#
#     The opening curly brackets "{" at the beginnings of some lines are there
#     simply to make navigation easier when using the text editor vim:
#     Press ]] to get to the next { and [[ to get to the previous {.
#     Important: these {'s are in lines that are not interpreted by the script.

################################################
#### INITIALIZATION - LOADING SETTINGS, ETC.
################################################

quit = 0

if unix = 1 or macintosh = 1
	slash$ = "/"
elif windows = 1
	slash$ = "\"
endif

while !quit

reset = 0
reopen = 0
reopened = 0
buttonClicked = 0
buttonClicked$ = ""
screen = 1
screen$ = "Main"
viewAndPlay = 0

nScreens = 6
mainScreen = 1
speakerScreen = 1
textsScreen = 2
soundScreen = 3
extractsScreen = 4
annotationScreen = 5
saveScreen = 6

screen1$ = "Main"
screen2$ = "Texts"
screen3$ = "Sound"
screen4$ = "Extracts"
screen5$ = "Annotation"
screen6$ = "Main"

if fileReadable (".pcbrc")
	settings = Read from file: ".pcbrc"
else
	settings = Create Table with column names: ".pcbrc", 29, "variable value"
	Set string value: 1, "variable", "name$"
	Set string value: 1, "value", """John Doe"""
	Set string value: 2, "variable", "prev_name$"
	Set string value: 2, "value", "name$"
	Set string value: 3, "variable", "gender"
	Set string value: 3, "value", "1"
	Set string value: 4, "variable", "prev_gender"
	Set string value: 4, "value", "gender"
	Set string value: 5, "variable", "age"
	Set string value: 5, "value", "25"
	Set string value: 6, "variable", "prev_age"
	Set string value: 6, "value", "age"
	Set string value: 7, "variable", "native_language$"
	Set string value: 7, "value", """English"""
	Set string value: 8, "variable", "prev_nat_lang$"
	Set string value: 8, "value", "native_language$"
	Set string value: 9, "variable", "speaker_code$"
	Set string value: 9, "value", """j"""
	Set string value: 10, "variable", "prev_speaker_code$"
	Set string value: 10, "value", "speaker_code$"
	Set string value: 11, "variable", "silentIL$"
	Set string value: 11, "value", """xxx"""
	Set string value: 12, "variable", "repeated_item$"
	Set string value: 12, "value", """"""
	Set string value: 13, "variable", "show_message"
	Set string value: 13, "value", "1"
	Set string value: 14, "variable", "generate_code_automatically"
	Set string value: 14, "value", "1"
	Set string value: 15, "variable", "tierNames$"
	Set string value: 15, "value", """code orth"""
	Set string value: 16, "variable", "fadeIn"
	Set string value: 16, "value", "10"
	Set string value: 17, "variable", "fadeOut"
	Set string value: 17, "value", "25"
	Set string value: 18, "variable", "silentMarginBefore"
	Set string value: 18, "value", "0.15"
	Set string value: 19, "variable", "silentMarginAfter"
	Set string value: 19, "value", "0.23"
	Set string value: 20, "variable", "prependSilence"
	Set string value: 20, "value", "50"
	Set string value: 21, "variable", "appendSilence"
	Set string value: 21, "value", "50"
	Set string value: 22, "variable", "trimBeginning"
	Set string value: 22, "value", "10"
	Set string value: 23, "variable", "trimEnd"
	Set string value: 23, "value", "10"
	Set string value: 24, "variable", "openPreviousExtractsFolderWindows$"
	Set string value: 24, "value", """.\"""
	Set string value: 25, "variable", "openPreviousExtractsFolderUnix$"
	Set string value: 25, "value", """./"""
	Set string value: 26, "variable", "savePreviousExtractsFolderWindows$"
	Set string value: 26, "value", """.\clean"""
	Set string value: 27, "variable", "savePreviousExtractsFolderUnix$"
	Set string value: 27, "value", """./clean"""
	Set string value: 28, "variable", "finalMargin"
	Set string value: 28, "value", "250"
	Set string value: 29, "variable", "initialMargin"
	Set string value: 29, "value", "150"
	selectObject: settings
	Save as text file: ".pcbrc"
endif

selectObject: settings
settingsRows = Get number of rows
for s to settingsRows
	var$ = Get value: s, "variable"
	val$ = Get value: s, "value"
	'var$' = 'val$'
endfor
if windows
	openPreviousExtractsFolder$ = openPreviousExtractsFolderWindows$
	savePreviousExtractsFolder$ = savePreviousExtractsFolderWindows$
else
	openPreviousExtractsFolder$ = openPreviousExtractsFolderUnix$
	savePreviousExtractsFolder$ = savePreviousExtractsFolderUnix$
endif


year = number (right$ (date$ (), 4))

demoWindowTitle: "Phonetic Corpus Builder"

buttonX = 12
buttonHor = 9
buttonY = 10
buttonVert = 4

rButtonX = 94
rButtonHor = 4
rButtonY = 10
rButtonVert = 3

colX = 97
colHor = 18
colY = 78
colVert = 3
colTextY = 76.5
colTextX = 98.75

demo Line width: 2

#########################
#### VARIOUS VARIABLES:
#########################
repaint = 0

buttonClicked$ = ""

speaker = 0
speaker$ = "%%Nothing selected.%"
prevSpeaker$ = "%%Nothing selected.%"
speakerCode$ = ""
speakerCodeScreen$ = ""
generate_code_automatically = 1

texts = 0
textsToSave = 0
texts$ = "%%Nothing selected.%"
textsScreen$ = "%%Nothing selected.%"
prevTexts$ = "%%Nothing selected.%"
textsPath$ = ""

sound = 0
soundToSave = 0
sound$ = "%%Nothing selected.%"
prevSound$ = "%%Nothing selected.%"
soundPath$ = ""
soundFolder$ = ""
soundNoExt$ = ""
monoOrStereo$ = ""
monoOrStereoScreen$ = ""
oppositeMOS$ = ""
convert_original_sound = 0
convert_extracted_sounds = 0
convert_to_stereo = 0
convert_to_mono = 0
openWithAnnotation = 0
reopenedSound$ = ""

extracted = 0
extracts = 0
nExtracts = 0
extractsToSave = 0
extracts$ = "%%Nothing selected.%"
prevExtracts$ = "%%Nothing selected.%"
openExtracts.folderContents = 0
removeUnsavedExt = 0
saveExtracts.numOrRange = 0
extrClicked = 0
extrColumns = 0
extrItems = 0
extrPages = 1
extrPage = 1
;extrCtrl = 0
fadeIn = 20
fadeOut = 25
extrMarked = 0
initial_margin = initialMargin
final_margin = finalMargin

textGridPath$ = ""
textGrid = 0
textGridToSave = 0
textGrid$ = ""
textGridName$ = ""
textGridScreen$ = "%%Nothing selected.%"
prevTextGrid$ = "%%Nothing selected.%"
silentIL$ = "xxx"
openWithSound = 0

repeated_item$ = ""

#############
### COLOURS:
#############

backgroundColour$ = "{0.2, 0.4, 0.5}"
headingColour$ = "Navy"
subHeadingColour$ = "Olive"

foreGroundColour$ = "{0.4, 0.6, 0.7}"
warningWindowColour$ = "{0.4, 0.6, 0.7}"
warningButtonColour$ = "{0.2, 0.4, 0.5}"
mainButtonColour$ =  "{0.4, 0.6, 0.7}"
resetButtonColour$ = "{0.5, 0.9, 0.5}"
quitButtonColour$ = "{0.9, 0.2, 0.2}"


##############
#### BUTTONS:
##############

nButtonsMain = 6

buttonMain1$ = "speaker"
buttonMain2$ = "texts"
buttonMain3$ = "sound"
buttonMain4$ = "extracts"
buttonMain5$ = "annotation"
buttonMain6$ = "save"

keyMain1$ = "p"
keyMain2$ = "t"
keyMain3$ = "l"
keyMain4$ = "e"
keyMain5$ = "a"
keyMain6$ = "s"

labelMain1$ = "S#%peaker"
labelMain2$ = "#%Texts"
labelMain3$ = "#%Long sound"
labelMain4$ = "#%Extracts"
labelMain5$ = "#%Annotation"
labelMain6$ = "#%Save"


#### Buttons for the Texts screen:

nButtonsTexts = 5

buttonTexts1$ = "open"
buttonTexts2$ = "inspect"
buttonTexts3$ = "modify"
buttonTexts4$ = "save"
buttonTexts5$ = "back"

keyTexts1$ = "o"
keyTexts2$ = "i"
keyTexts3$ = "m"
keyTexts4$ = "s"
keyTexts5$ = "b"

labelTexts1$ = "#%Open"
labelTexts2$ = "#%Inspect"
labelTexts3$ = "#%Modify"
labelTexts4$ = "#%Save"
labelTexts5$ = "#%Back"


#### Buttons for the Sound screen:

gotoAnnotation = 0
nButtonsSound = 6

buttonSound1$ = "open"
buttonSound2$ = "view"
buttonSound3$ = "extract"
buttonSound4$ = "convert"
buttonSound5$ = "save"
buttonSound6$ = "back"

keySound1$ = "o"
keySound2$ = "v"
keySound3$ = "e"
keySound4$ = "c"
keySound5$ = "s"
keySound6$ = "b"

labelSound1$ = "#%Open"
labelSound2$ = "#%View"
labelSound3$ = "#%Extract"
labelSound4$ = "#%Convert"
labelSound5$ = "#%Save"
labelSound6$ = "#%Back"


#### Buttons for the Extracts screen:

gotoAnnotation = 0
nButtonsExtracts = 8

buttonExtracts1$ = "open"
buttonExtracts2$ = "view"
buttonExtracts3$ = "fade"
buttonExtracts4$ = "addSilence"
buttonExtracts5$ = "trim"
buttonExtracts6$ = "convert"
buttonExtracts7$ = "save"
buttonExtracts8$ = "back"

keyExtracts1$ = "o"
keyExtracts2$ = "v"
keyExtracts3$ = "f"
keyExtracts4$ = "a"
keyExtracts5$ = "t"
keyExtracts6$ = "c"
keyExtracts7$ = "s"
keyExtracts8$ = "b"

labelExtracts1$ = "#%Open"
labelExtracts2$ = "#%View"
labelExtracts3$ = "#%Fade in/out"
labelExtracts4$ = "#%Add silence"
labelExtracts5$ = "#%Trim"
labelExtracts6$ = "#%Convert"
labelExtracts7$ = "#%Save"
labelExtracts8$ = "#%Back"

#### Buttons for the Annotation screen:

nButtonsAnnotation = 6

buttonAnnotation1$ = "open"
buttonAnnotation2$ = "pauses"
buttonAnnotation3$ = "intervals"
buttonAnnotation4$ = "label"
buttonAnnotation5$ = "save"
buttonAnnotation6$ = "back"

keyAnnotation1$ = "o"
keyAnnotation2$ = "p"
keyAnnotation3$ = "i"
keyAnnotation4$ = "l"
keyAnnotation5$ = "s"
keyAnnotation6$ = "b"

labelAnnotation1$ = "#%Open"
labelAnnotation2$ = "Mark #%pauses"
labelAnnotation3$ = "Add #%intervals"
labelAnnotation4$ = "#%Label"
labelAnnotation5$ = "#%Save"
labelAnnotation6$ = "#%Back"

rLabelSize = 15
rButtonsAnnotation = 6

rButtonAnnotation1$ = "shrink"
rButtonAnnotation2$ = "expand"
rButtonAnnotation3$ = "increase"
rButtonAnnotation4$ = "decrease"
rButtonAnnotation5$ = ""
rButtonAnnotation6$ = ""

rKeyAnnotation1$ = "h"
rKeyAnnotation2$ = "e"
rKeyAnnotation3$ = "n"
rKeyAnnotation4$ = "d"
rKeyAnnotation5$ = ""
rKeyAnnotation6$ = ""

rLabelAnnotation1$ = "S#%hrink"
rLabelAnnotation2$ = "#%Expand"
rLabelAnnotation3$ = "I#%ncrease"
rLabelAnnotation4$ = "#%Decrease"
rLabelAnnotation5$ = "%empty"
rLabelAnnotation6$ = "%empty"

warningOption$ = ""

@MainScreen

if show_message = 1 and unix = 1
	# This was more like a test if the ".pcbrc" works but maybe the message
	# could be used for something useful.
	beginPause: "When starting PCB for the first time"
		comment: "Do you want to show this message after restarting PCB?"
		boolean: "Show message", 1
	clicked = endPause: "Continue", 1
	if show_message = 0
		selectObject: settings
		col = Search column: "variable", "show_message"
		Set numeric value: col, "value", show_message
		Save as text file: ".pcbrc"
	endif
endif


label START
@MainScreen


#################################
#### WAIT FOR USER INPUT CYCLES
#################################

#### The main screen:
label MAIN
while !quit and !reset and demoWaitForInput()
	buttonClicked$ = ""
	buttonClicked = 0
	repaint = 0

	# this for loop makes it possible to click the big buttons on the left
	# and to press the keys:
	for i to nButtons'screen$'
		if demoClickedIn (buttonX - buttonHor, buttonX + buttonHor, 100
		... - ((i * buttonY) + buttonVert), 100 - ((i * buttonY) - buttonVert))
		... or (demoCommandKeyPressed () = 0 and demoKey$ () = key'screen$''i'$)
			buttonClicked = i
			buttonClicked$ = button'screen$''i'$
		endif
	endfor

	# Move to the selected screen
	if buttonClicked > 0
		if screen = mainScreen or screen = saveScreen
			screen = buttonClicked
			screen$ = screen'screen'$
			@'screen$'Screen
			if buttonClicked = 1 or buttonClicked = 6
				@'buttonClicked$''screen$'
			endif
		elif screen = extractsScreen
			@'screen$'Screen
			@'buttonClicked$''screen$'
		elif screen = textsScreen or screen = soundScreen or screen = annotationScreen
			@'screen$'Screen
			@'buttonClicked$''screen$'
		endif
	endif

	if demoKey$ () = "?"
		@ShowHelp'screen$'
	endif

	# interaction with the screens
	if screen = textsScreen
		# Re-load the file
		if demoKey$ () = "O" and textsPath$ <> ""
			reopen = 1
			@openTexts
		endif
	elif screen = soundScreen
		# Re-load the file
		if demoKey$ () = "O" and soundPath$ <> ""
			reopen = 1
			@openSound
		endif
	elif screen = annotationScreen
		if demoKey$ () = "o" and demoCommandKeyPressed () = 1
			openWithAnnotation = 1
			@openAnnotation
		endif
		# Re-load the file
		if demoKey$ () = "O" and textGridPath$ <> ""
			reopen = 1
			@openAnnotation
		endif
	elif screen = extractsScreen
		# extrItems is a dummy variable that equals the nr of extracts first but
		# is possibly modified in the ExtractsScreen procedure
		extrItems = nExtracts

		# this for cycle enables clicking the items in the four columns and selecting,
		# playing and viewing them
		for .c to 4
			# extrColumns equals 1 for 1–24 extracts, 2 for 25–49 extr., 3 for 
			# 50-74 extr., and 4 for 75-99 items
			for extr from (100 - (.c * 25) + 1) to extrItems
				# select the item by clicking anywhere in its rectangle:
				if demoClickedIn (
				... colX - (.c * colHor), colX - (.c * colHor) + colHor,
				... colY - (3 * (extr - (100 - (.c * 25)))),
				... colY + colVert - (3 * (extr - (100 - (.c * 25)))))
					extrClicked = extr

					# play the item by clicking at the name of the item:
					if demoClickedIn (
					... colX - (.c * colHor) + 4, colX - (.c * colHor) + 10,
					... colY - (3 * (extr - (100 - (.c * 25)))),
					... colY + colVert - (3 * (extr - (100 - (.c * 25)))))
						selectObject: extracts'extr'
						asynchronous Play

					# view the item by clicking at the Theta symbol or number of
					# the item:
					elif demoClickedIn (
					... colX - (.c * colHor) + 1.5, colX - (.c * colHor) + 3.5,
					... colY - (3 * (extr - (100 - (.c * 25)))),
					... colY + colVert - (3 * (extr - (100 - (.c * 25)))))
						selectObject: extracts'extr'
						View & Edit
						editor: "Sound " + extracts'extr'$
						Move cursor to: 0
						endeditor

					# Mark the item for batch manipulation
					elif demoClickedIn (
					... colX - (.c * colHor), colX - (.c * colHor) + 1.2,
					... colY - (3 * (extr - (100 - (.c * 25)))),
					... colY + colVert - (3 * (extr - (100 - (.c * 25)))))
						if extracts'extr'marked = 0
							extracts'extr'marked = 1
							extrMarked += 1
						elif extracts'extr'marked = 1
							extracts'extr'marked = 0
							extrMarked -= 1
						endif
					endif
					@PaintExtractsWindow: nExtracts, extrClicked
				endif
			endfor
		endfor

		# "r" is the "Refresh" key
		if demoKey$ () = "r" and extrClicked != 0
			@PaintSoundWave: extrClicked
		endif
		# "V" is the "Play + View & Edit" key
		if demoKey$ () = "V"
			viewAndPlay = 1
			@viewExtracts
		endif
		# "d" is the "mark" key
		if demoKey$ () = "d"
			if extracts'extrClicked'marked = 0
				extracts'extrClicked'marked = 1
				extrMarked += 1
			elif extracts'extrClicked'marked = 1
				extracts'extrClicked'marked = 0
				extrMarked -= 1
			endif
			@PaintExtractsWindow: nExtracts, extrClicked
		endif

		# "u" is the "unselect all" key
		if demoKey$ () = "u"
			for b to nExtracts
				extracts'b'marked = 0
			endfor
			extrMarked = 0
			@PaintExtractsWindow: nExtracts, extrClicked
		endif

		# "y" is the "select all" key
		if demoKey$ () = "y"
			for b to nExtracts
				extracts'b'marked = 1
			endfor
			extrMarked = nExtracts
			@PaintExtractsWindow: nExtracts, extrClicked
		endif

		# "i" is the "invert selection" key
		if demoKey$ () = "i"
			for b to nExtracts
				if extracts'b'marked = 0
					extracts'b'marked = 1
					extrMarked += 1
				elif extracts'b'marked = 1
					extracts'b'marked = 0
					extrMarked -= 1
				endif
			endfor
			@PaintExtractsWindow: nExtracts, extrClicked
		endif

		# these if cycles enable the use of the arrow keys/"hjkl" keys to navigate
		# through the list of extracts (use Ctrl + key to move by 5 extracts and
		# use Alt + key to move to next + play it:
		if extrClicked < nExtracts
			if demoKey$ () = "↓" or demoKey$ () = "j"
				if demoCommandKeyPressed () = 1 and extrClicked <= nExtracts - 5
					extrClicked += 5
					if demoOptionKeyPressed () = 1
						selectObject: extracts'extrClicked'
						asynchronous Play
					endif
				elif demoCommandKeyPressed () = 1 and extrClicked > nExtracts - 5
					extrClicked = nExtracts
					if demoOptionKeyPressed () = 1
						selectObject: extracts'extrClicked'
						asynchronous Play
					endif
				elif demoOptionKeyPressed () = 1
					extrClicked += 1
					selectObject: extracts'extrClicked'
					asynchronous Play
				else
					extrClicked += 1
				endif
				@PaintExtractsWindow: nExtracts, extrClicked
			elif demoKey$ () = "J" or (demoShiftKeyPressed () = 1 and demoKey$ () = "↓")
				extrClicked += 1
				selectObject: extracts'extrClicked'
				asynchronous Play
				View & Edit
				editor: "Sound " + extracts'extrClicked'$
				Move cursor to: 0
				endeditor
				@PaintExtractsWindow: nExtracts, extrClicked
			endif
		endif

		if extrClicked > 1
			if demoKey$ () = "↑" or demoKey$ () = "k"
				if demoCommandKeyPressed () = 1 and extrClicked > 5
					extrClicked -= 5
					if demoOptionKeyPressed () = 1
						selectObject: extracts'extrClicked'
						asynchronous Play
					endif
				elif demoCommandKeyPressed () = 1 and extrClicked <= 5
					extrClicked = 1
					if demoOptionKeyPressed () = 1
						selectObject: extracts'extrClicked'
						asynchronous Play
					endif
				elif demoOptionKeyPressed () = 1
					extrClicked -= 1
					selectObject: extracts'extrClicked'
					asynchronous Play
				else
					extrClicked -= 1
				endif
				@PaintExtractsWindow: nExtracts, extrClicked
			elif demoKey$ () = "K" or (demoShiftKeyPressed () = 1 and demoKey$ () = "↑")
				extrClicked -= 1
				selectObject: extracts'extrClicked'
				asynchronous Play
				View & Edit
				editor: "Sound " + extracts'extrClicked'$
				Move cursor to: 0
				endeditor
				@PaintExtractsWindow: nExtracts, extrClicked
			endif
		endif

		if extrClicked + 25 <= nExtracts 
			if demoKey$ () = "→" or demoKey$ () = "l"
				if demoOptionKeyPressed () = 1
					extrClicked += 25
					selectObject: extracts'extrClicked'
					asynchronous Play
				else
					extrClicked += 25
				endif
				@PaintExtractsWindow: nExtracts, extrClicked
			endif
		endif

		if extrClicked > 25
			if demoKey$ () = "←" or demoKey$ () = "h"
				if demoOptionKeyPressed () = 1
					extrClicked -= 25
					selectObject: extracts'extrClicked'
					asynchronous Play
				else
					extrClicked -= 25
				endif
				@PaintExtractsWindow: nExtracts, extrClicked
			endif
		endif

		# ";" is the play button:
		if demoKey$ () = ";"
			selectObject: extracts'extrClicked'
			asynchronous Play
		endif
	
		# ":" is the "interrupt playing" key
		if demoKey$ () = ":"
			Create Sound: "break", 0, 0.01, 44100, "0"
			asynchronous Play
			Remove
		endif
	endif

		# The "reset" button:
		if demoClickedIn (5, 11, 8, 14) or (demoCommandKeyPressed () = 1 and demoKey$ () = "r")
			if textsToSave = 1 or soundToSave = 1 or textGridToSave = 1 or extractsToSave = 1
				@warning: 2, "CANCEL", "RESET", "c", "r",
				... "The object list is not empty.",
				... "Sure you want to reset?"
				if warningOption$ = "RESET"
					reset = 1
					screen = mainScreen
				endif
			else
				screen = mainScreen
				reset = 1
			endif

		# The "quit" button:
		elif demoClickedIn (13, 19, 8, 14) or (demoCommandKeyPressed () = 1 and demoKey$ () = "q")
			if textsToSave = 1 or soundToSave = 1 or textGridToSave = 1 or extractsToSave = 1
				@warning: 2, "CANCEL", "QUIT", "c", "q",
				... "The object list is not empty.",
				... "Sure you want to quit?"
				if warningOption$ = "QUIT"
					quit = 1
				endif
			else
				quit = 1
			endif

		elif screen$ = "Extracts" and (demoClickedIn (44, 50, 91, 97) or demoKey$ () = "p")
			@previewSettings
		endif

	# From any screen (except the Extracts screen (4)) you can go to another
	# (texts, sound, etc.) by clicking the description instead of clicking the
	# Back button and then selecting the particular screen from the main screen:
	# Enable choosing the screens by clicking at the text in the screens.
	if !buttonClicked and screen != 4
		if demoClickedIn (25, 39, 28.5, 31.5)
		... or (demoCommandKeyPressed () = 1 and demoKey$ () = "p")
			@speakerMain
		elif demoClickedIn (25, 32, 23.5, 26.5)
		... or (demoCommandKeyPressed () = 1 and demoKey$ () = "t")
			repaint = 1
			screen = textsScreen
		elif demoClickedIn (25, 32, 18.5, 21.5)
		... or (demoCommandKeyPressed () = 1 and demoKey$ () = "l")
			repaint = 1
			screen = soundScreen
		elif demoClickedIn (25, 34, 13.5, 16.5)
		... or (demoCommandKeyPressed () = 1 and demoKey$ () = "e")
			repaint = 1
			screen = extractsScreen
		elif demoClickedIn (25, 35, 8.5, 11.5)
		... or (demoCommandKeyPressed () = 1 and demoKey$ () = "a")
			repaint = 1
			screen = annotationScreen
		endif
	endif

	# repaint the screen only if another screen is chosen or something
	# has changed which should be shown in the screen
	if buttonClicked or repaint
		screen$ = screen'screen'$
		@'screen$'Screen
	endif

	label MAIN_CANCEL
	# "p" or Escape repaints the the screen
	if index_regex (demoKey$ (), "\e") <> 0 or demoKey$ () = "p"
		screen$ = screen'screen'$
		@'screen$'Screen
	endif
endwhile



label QUIT
label MAIN_QUIT
label TEXTS_QUIT
label SOUND_QUIT
label EXTRACTS_QUIT
label ANNOTATION_QUIT

demo Erase all
demo Select inner viewport: 0, 100,  0, 100
demo Axes: 0, 100, 0, 100

demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

demo 'headingColour$'
demo Text special: 50, "centre", 60, "half", "Helvetica", 60, "0", "Finished"


##################################
#### CLEAR PRAAT'S OBJECT LIST
##################################

# The following loops select all the objects created by the script and remove
# them from the objects window:

selectedItems = numberOfSelected ()
for i to selectedItems
	sel'i' = selected (i)
endfor

select all
allItems = numberOfSelected ()
for i to allItems
	object'i' = selected (i)
endfor

for i to allItems
	if object'i' = settings
		removeObject: settings
	endif
	if object'i' = texts
		removeObject: texts
	endif
	if object'i' = sound
		removeObject: sound
	endif
	if object'i' = textGrid
		removeObject: textGrid
	endif
	if object'i' = extracts
		removeObject: extracts
	endif
	if object'i' = openExtracts.folderContents
		removeObject: openExtracts.folderContents
	endif
	for j to nExtracts
		if object'i' = extracts'j'
			removeObject: extracts'j'
		endif
	endfor
endfor

select all
remainingItems = numberOfSelected ()
for i to remainingItems
	rem'i' = selected (i)
endfor

selectObject ()
for i to remainingItems
	for j to selectedItems
		if rem'i' = sel'j'
			plusObject: sel'j'
		endif
	endfor
endfor

endwhile

goto FINISHED

#######################
#### SCREEN PROCEDURES
#######################
procedure MainScreen
	demo Erase all
	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100

	demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

	demo 'headingColour$'
	demo Text special: 60, "centre", 70, "half", "Helvetica", 60, "0", "Phonetic Corpus"
	demo Text special: 60, "centre", 55, "half", "Helvetica", 70, "0", "Builder"

	demo Black
	if texts$ = ""
		texts$ = prevTexts$
	endif
	if sound$ = ""
		sound$ = prevSound$
	endif
	if extracts$ = ""
		extracts$ = prevExtracts$
	endif
	if textGridScreen$ = ""
		textGridScreen$ = prevTextGrid$
	endif

	demo Text special: 25, "left", 28, "bottom", "Helvetica", 15, "0", "##Speaker (code):# 'speaker$' 'speakerCodeScreen$'"
	demo Text special: 25, "left", 23, "bottom", "Helvetica", 15, "0", "##Text(s):# 'texts$'"
	demo Text special: 25, "left", 18, "bottom", "Helvetica", 15, "0", "##Sound:# 'sound$' 'monoOrStereoScreen$'"
	demo Text special: 25, "left", 13, "bottom", "Helvetica", 15, "0", "##Extracts:# 'extracts$'"
	demo Text special: 25, "left", 8, "bottom", "Helvetica", 15, "0", "##Annotation:# 'textGridScreen$'"

	for i to nButtonsMain
		demo Paint rounded rectangle: mainButtonColour$, buttonX - buttonHor, buttonX
		... + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Draw rounded rectangle: buttonX - buttonHor, buttonX + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Text special: buttonX, "centre", 100 - (i * buttonY), "half",
		... "Helvetica", 20, "0", labelMain'i'$
	endfor

	# The "reset" button:
	demo Paint rounded rectangle: resetButtonColour$, 5, 11, 8, 14, 3
	demo Draw rounded rectangle: 5, 11, 8, 14, 3
	demo Text special: 8, "centre", 11, "half", "Helvetica", 15, "0", "#%Reset";

	# The "quit" button:
	demo Paint rounded rectangle: quitButtonColour$, 13, 19, 8, 14, 3
	demo Draw rounded rectangle: 13, 19, 8, 14, 3
	demo Text special: 16, "centre", 11, "half", "Helvetica", 15, "0", "#%Quit"
endproc


procedure TextsScreen: 
	demo Erase all
	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100

	demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

	demo 'subHeadingColour$'
	demo Text special: 25, "left", 90, "half", "Helvetica", 45, "0", "Texts"

	demo 'headingColour$'
	demo Text special: 60, "centre", 70, "half", "Helvetica", 60, "0", "Phonetic Corpus"
	demo Text special: 60, "centre", 55, "half", "Helvetica", 70, "0", "Builder"

	demo Black
	if texts$ = ""
		texts$ = prevTexts$
	endif
	if sound$ = ""
		sound$ = prevSound$
	endif
	if extracts$ = ""
		extracts$ = prevExtracts$ 
	endif
	if textGridScreen$ = ""
		textGridScreen$ = prevTextGrid$
	endif

	demo Text special: 25, "left", 28, "bottom", "Helvetica", 15, "0", "##Speaker (code):# 'speaker$' 'speakerCodeScreen$'"
	demo Text special: 25, "left", 23, "bottom", "Helvetica", 15, "0", "##Text(s):# 'texts$'"
	demo Text special: 25, "left", 18, "bottom", "Helvetica", 15, "0", "##Sound:# 'sound$' 'monoOrStereoScreen$'"
	demo Text special: 25, "left", 13, "bottom", "Helvetica", 15, "0", "##Extracts:# 'extracts$'"
	demo Text special: 25, "left", 8, "bottom", "Helvetica", 15, "0", "##Annotation:# 'textGridScreen$'"

	for i to nButtonsTexts
		demo Paint rounded rectangle: mainButtonColour$, buttonX - buttonHor, buttonX
		... + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Draw rounded rectangle: buttonX - buttonHor, buttonX + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Text special: buttonX, "centre", 100 - (i * buttonY), "half",
		... "Helvetica", 20, "0", labelTexts'i'$
	endfor

	# The "reset" button:
	demo Paint rounded rectangle: resetButtonColour$, 5, 11, 8, 14, 3
	demo Draw rounded rectangle: 5, 11, 8, 14, 3
	demo Text special: 8, "centre", 11, "half", "Helvetica", 15, "0", "#%Reset";

	# The "quit" button:
	demo Paint rounded rectangle: quitButtonColour$, 13, 19, 8, 14, 3
	demo Draw rounded rectangle: 13, 19, 8, 14, 3
	demo Text special: 16, "centre", 11, "half", "Helvetica", 15, "0", "#%Quit"
endproc


procedure SoundScreen
	demo Erase all
	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100

	demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

	demo 'subHeadingColour$'
	demo Text special: 25, "left", 90, "half", "Helvetica", 45, "0", "Long sound"

	demo 'headingColour$'
	demo Text special: 60, "centre", 70, "half", "Helvetica", 60, "0", "Phonetic Corpus"
	demo Text special: 60, "centre", 55, "half", "Helvetica", 70, "0", "Builder"

	demo Black
	if texts$ = ""
		texts$ = prevTexts$
	endif
	if sound$ = ""
		sound$ = prevSound$
	endif
	if extracts$ = ""
		extracts$ = prevExtracts$
	endif
	if textGridScreen$ = ""
		textGridScreen$ = prevTextGrid$
	endif

	demo Text special: 25, "left", 28, "bottom", "Helvetica", 15, "0", "##Speaker (code):# 'speaker$' 'speakerCodeScreen$'"
	demo Text special: 25, "left", 23, "bottom", "Helvetica", 15, "0", "##Text(s):# 'texts$'"
	demo Text special: 25, "left", 18, "bottom", "Helvetica", 15, "0", "##Sound:# 'sound$' 'monoOrStereoScreen$' 'reopenedSound$'"
	demo Text special: 25, "left", 13, "bottom", "Helvetica", 15, "0", "##Extracts:# 'extracts$'"
	demo Text special: 25, "left", 8, "bottom", "Helvetica", 15, "0", "##Annotation:# 'textGridScreen$'"

	for i to nButtonsSound
		demo Paint rounded rectangle: mainButtonColour$, buttonX - buttonHor, buttonX
		... + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Draw rounded rectangle: buttonX - buttonHor, buttonX + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Text special: buttonX, "centre", 100 - (i * buttonY), "half",
		... "Helvetica", 20, "0", labelSound'i'$
	endfor

	# The "reset" button:
	demo Paint rounded rectangle: resetButtonColour$, 5, 11, 8, 14, 3
	demo Draw rounded rectangle: 5, 11, 8, 14, 3
	demo Text special: 8, "centre", 11, "half", "Helvetica", 15, "0", "#%Reset";

	# The "quit" button:
	demo Paint rounded rectangle: quitButtonColour$, 13, 19, 8, 14, 3
	demo Draw rounded rectangle: 13, 19, 8, 14, 3
	demo Text special: 16, "centre", 11, "half", "Helvetica", 15, "0", "#%Quit"
endproc


procedure ExtractsScreen
	demo Erase all
	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100

	demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

	demo 'subHeadingColour$'
	demo Text special: 25, "left", 90, "half", "Helvetica", 45, "0", "Extracts"

	demo Black

	# this draws the main buttons, it has to come after the extracts' names
	# have been repainted
	for i to nButtonsExtracts
		demo Paint rounded rectangle: mainButtonColour$, buttonX - buttonHor, buttonX
		... + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Draw rounded rectangle: buttonX - buttonHor, buttonX + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Text special: buttonX, "centre", 100 - (i * buttonY), "half", "Helvetica", 20, "0", labelExtracts'i'$
	endfor

	# The "reset" button:
	demo Paint rounded rectangle: resetButtonColour$, 5, 11, 8, 14, 3
	demo Draw rounded rectangle: 5, 11, 8, 14, 3
	demo Text special: 8, "centre", 11, "half", "Helvetica", 15, "0", "#%Reset";

	# The "quit" button:
	demo Paint rounded rectangle: quitButtonColour$, 13, 19, 8, 14, 3
	demo Draw rounded rectangle: 13, 19, 8, 14, 3
	demo Text special: 16, "centre", 11, "half", "Helvetica", 15, "0", "#%Quit"

	# The "settings" button:
	demo Paint rounded rectangle: mainButtonColour$, 44, 50, 91, 97, 3
	demo Draw rounded rectangle: 44, 50, 91, 97, 3
	demo Text special: 47, "centre", 95, "half", "Helvetica", 12, "0", "#%Preview"
	demo Text special: 47, "centre", 93, "half", "Helvetica", 12, "0", "settings"

	if extracts > 0
		@PaintExtracts: nExtracts, extrClicked
	endif

	# Paint the sound wave and 100 ms lines.
	if extrClicked > 0
		@PaintSoundWave: extrClicked
	endif
endproc


procedure AnnotationScreen
	demo Erase all
	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100

	demo Paint rectangle: backgroundColour$, 0, 100, 0, 100

	demo 'subHeadingColour$'
	demo Text special: 25, "left", 90, "half", "Helvetica", 45, "0", "Annotation"

	demo 'headingColour$'
	demo Text special: 60, "centre", 70, "half", "Helvetica", 60, "0", "Phonetic Corpus"
	demo Text special: 60, "centre", 55, "half", "Helvetica", 70, "0", "Builder"

	demo Black
	if texts$ = ""
		texts$ = prevTexts$
	endif
	if sound$ = ""
		sound$ = prevSound$
	endif
	if extracts$ = ""
		extracts$ = prevExtracts$
	endif
	if textGridScreen$ = ""
		textGridScreen$ = prevTextGrid$
	endif

	demo Text special: 25, "left", 28, "bottom", "Helvetica", 15, "0", "##Speaker (code):# 'speaker$' 'speakerCodeScreen$'"
	demo Text special: 25, "left", 23, "bottom", "Helvetica", 15, "0", "##Text(s):# 'texts$'"
	demo Text special: 25, "left", 18, "bottom", "Helvetica", 15, "0", "##Sound:# 'sound$' 'monoOrStereoScreen$'"
	demo Text special: 25, "left", 13, "bottom", "Helvetica", 15, "0", "##Extracts:# 'extracts$'"
	demo Text special: 25, "left", 8, "bottom", "Helvetica", 15, "0", "##Annotation:# 'textGridScreen$'"

	for i to nButtonsAnnotation
		demo Paint rounded rectangle: mainButtonColour$, buttonX - buttonHor, buttonX
		... + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Draw rounded rectangle: buttonX - buttonHor, buttonX + buttonHor,
		... 100 - ((i * buttonY) + buttonVert),
		... 100 - ((i * buttonY) - buttonVert), 3
		demo Text special: buttonX, "centre", 100 - (i * buttonY), "half",
		... "Helvetica", 20, "0", labelAnnotation'i'$
	endfor

	# The "reset" button:
	demo Paint rounded rectangle: resetButtonColour$, 5, 11, 8, 14, 3
	demo Draw rounded rectangle: 5, 11, 8, 14, 3
	demo Text special: 8, "centre", 11, "half", "Helvetica", 15, "0", "#%Reset"

	# The "quit" button:
	demo Paint rounded rectangle: quitButtonColour$, 13, 19, 8, 14, 3
	demo Draw rounded rectangle: 13, 19, 8, 14, 3
	demo Text special: 16, "centre", 11, "half", "Helvetica", 15, "0", "#%Quit"
endproc


#####################
#### OTHER PROCEDURES
#####################


procedure markedToString
	select$ = ""
	.prevRange = 0
	extracts0marked = 0
	for .b to nExtracts
		.prev = .b - 1
		if extracts'.b'marked = 1 and select$ = ""
			select$ = string$ (.b)
		elif extracts'.b'marked = 1 and extracts'.prev'marked = 1 and .prevRange = 0
			select$ = select$ + "-" + string$ (.b)
			.prevRange = 1
		elif extracts'.b'marked = 1 and extracts'.prev'marked = 1 and .prevRange = 1
			select$ = select$ - string$ (.prev) + string$ (.b)
			.prevRange = 1
		elif extracts'.b'marked = 1 
			select$ = select$ + " " + string$ (.b)
			.prevRange = 0
		endif
	endfor
endproc


procedure backTexts
	screen = mainScreen
endproc


procedure backSound
	screen = mainScreen
endproc


procedure backExtracts
	screen = mainScreen
endproc


procedure backAnnotation
	screen = mainScreen
endproc


procedure warning: .nButtons, .label1$, .label2$, .key1$, .key2$, .line1$, .line2$
	warningOption$ = ""
	.key1$ = left$ (.label1$, 1)
	.key1$ = replace_regex$ (.key1$, ".*", "\L&", 0)
	.key2$ = left$ (.label2$, 1)
	.key2$ = replace_regex$ (.key2$, ".*", "\L&", 0)

	demo Paint rounded rectangle: warningWindowColour$, 30, 70, 30, 70, 1
	demo Draw rounded rectangle: 30, 70, 30, 70, 1
	demo Text special: 37, "centre", 55, "half", "Helvetica", 60, "0", "!"
	demo Text special: 50, "centre", 55, "half", "Helvetica", 15, "0", .line1$
	demo Text special: 50, "centre", 52, "half", "Helvetica", 15, "0", .line2$
	for b to .nButtons
		.x = 64 - (b * 12)
		demo Paint rounded rectangle: warningButtonColour$, .x, .x + 8, 40, 45, 1
		demo Draw rounded rectangle: .x, .x + 8, 40, 45, 1
		demo Text special: .x + 4, "centre", 42.5, "half", "Helvetica", 15, "0", .label'b'$
	endfor

	while warningOption$ = "" and demoWaitForInput ()
		for b to .nButtons
			.x = 64 - (b * 12)
			if demoKey$ () = .key'b'$ or demoClickedIn (.x, .x + 8, 40, 45)
				warningOption$ = .label'b'$
			endif
		endfor
	endwhile

	@'screen$'Screen
endproc


procedure textToNumbers: .source$, .text$, .max, .noValue
	# Place the labels XXXX_AGAIN and XXXX_CANCEL at the appropriate positions
	# in the original procedure with respect to the position of the
	# @textToNumber call.

	.items = 0
	.nor = 0

	# Reject selections with characters other than digits, the space and the
	# dash:
	if index_regex (.text$, "[^0-9 -]") <> 0
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Only use digits, spaces",
		... "and dashes in selection."
		if warningOption$ = "AGAIN"
			'.source$'.label$ = "AGAIN"
			goto TEXT_TO_NUMBERS_END
		endif

	# Reject empty selections or those which which do not contain digits:
	elif .text$ = "" or index_regex (.text$, "\d") = 0
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Invalid selection:",
		... """'.text$'"""
		if warningOption$ = "AGAIN"
			'.source$'.label$ = "AGAIN"
			goto TEXT_TO_NUMBERS_END
		endif
	else

		# Look for spaces and dashes in the variable .text$;
		# remove doubled characters, spaces around dashes " - ", and spaces at
		# the beginning or end:
		.text$ = replace_regex$ (.text$, " +", " ", 0)
		.text$ = replace$ (.text$, " -", "-", 0)
		.text$ = replace$ (.text$, "- ", "-", 0)
		.text$ = replace_regex$ (.text$, "-+", "-", 0)
		.text$ = replace_regex$ (.text$, "^ ", "", 0)
		.text$ = replace_regex$ (.text$, " $", "", 0)

		.length = length (.text$)
		.space = index (.text$, " ")

		# Save all numbers or ranges as .nor'X'$. This is skipped if there is
		# no space in the selection:
		while .space > 0
			.nor = .nor + 1
			.length = length (.text$)
			.nor'.nor'$ = left$ (.text$, .space - 1)
			.text$ = right$ (.text$, .length - .space)
			.space = index (.text$, " ")
		endwhile

		# If there is no space in the selection, it will be correctly recognized
		# as just one number:
		.nor = .nor + 1
		.nor'.nor'$ = .text$

		# Get the values of individual numbers and ranges:
		for n to .nor
			if index (.nor'n'$, "-") = 0
				.items = .items + 1
				'.source$'.value'.items' = number (.nor'n'$)
				.value = '.source$'.value'.items'
				if .value > .max or .value = .noValue
					label NO_OBJECT
					@warning: 2, "AGAIN", "CANCEL", "a", "c", "You haven't got",
					... "object Nr '.value'"
					'.source$'.label$ = warningOption$
					goto TEXT_TO_NUMBERS_END
				endif
			else
				.length = length (.nor'n'$)
				.dash = index (.nor'n'$, "-")
				.from$ = left$ (.nor'n'$, .dash -1)
				.to$ = right$ (.nor'n'$, .length - .dash)

				# If the selection contains something like "1-5-8", report
				# incorrect range:
				if index (.to$, "-") <> 0
					goto INCORRECT_RANGE
				endif

				# Reject selections with incomplete ranges (e.g., 12-, -8)
				if .from$ <> "" and .to$ <> ""
					.from = number (.from$)
					.to = number (.to$)
				else
					@warning: 2, "AGAIN", "CANCEL", "a", "c", "Incomplete range
					... in:", """'.text$'"""
					if warningOption$ = "CANCEL"
						'.source$'.label$ = "CANCEL"
						goto TEXT_TO_NUMBERS_END
					else
						'.source$'.label$ = "AGAIN"
						goto TEXT_TO_NUMBERS_END
					endif
				endif

				# Reject selections with incorrect ranges (e.g., 12-9):
				if .from >= .to
					label INCORRECT_RANGE
					@warning: 2, "AGAIN", "CANCEL", "a", "c", "Incorrect range
					... in:", """'.text$'"""
					if warningOption$ = "CANCEL"
						'.source$'.label$ = "CANCEL"
						goto TEXT_TO_NUMBERS_END
					else
						'.source$'.label$ = "AGAIN"
						goto TEXT_TO_NUMBERS_END
					endif

				# Reject selections which do not match a particular value:
				elif .from = .noValue or .to = .noValue
					.value = .noValue
					goto NO_OBJECT

				# Reject selections which exceed the maximum:
				elif .to > .max
					@warning: 2, "AGAIN", "CANCEL", "a", "c", "Selection ('.to')
					... exceeds", "number of extracts ('.max')."
					if warningOption$ = "CANCEL"
						'.source$'.label$ = "CANCEL"
						goto TEXT_TO_NUMBERS_END
					else
						'.source$'.label$ = "AGAIN"
						goto TEXT_TO_NUMBERS_END
					endif
				endif

				# Get the individual values in a range:
				for i from .from to .to
					.items = .items + 1
					'.source$'.value'.items' = i
				endfor
			endif

			# Get the number of values:
			'.source$'.items = .items
		endfor
	endif
	label TEXT_TO_NUMBERS_END
endproc


procedure textToStrings: .source$, .text$
	# Place the labels XXXX_AGAIN and XXXX_CANCEL at the appropriate positions
	# in the original procedure with respect to the position of the
	# @textTostrings call.
	#
	# The outcome of this procedure are strings with prepended '.source$'
	# and appended 'number of strings' and the total number ('.source$'.strings)
	# of these strings$.

	.strings = 0

	# Reject empty selections:
	if .text$ = ""
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "No tier names", "selected!"
		if warningOption$ = "AGAIN"
			'.source$'.label$ = "AGAIN"
			goto TEXT_TO_STRINGS_END
		endif
	elif index (.text$, ", ") <> 0
		@warning: 2, "AGAIN", "CONTINUE", "a", "c", "Tier names contain", "a
		... comma!"
		if warningOption$ = "AGAIN"
			'.source$'.label$ = "AGAIN"
			goto TEXT_TO_STRINGS_END
		elif warningOption$ = "CONTINUE"
			goto TEXT_TO_STRINGS_CONTINUE
		endif
	else
		label TEXT_TO_STRINGS_CONTINUE

		# Remove repeated spaces and spaces at the beginning or end of .text$:
		.text$ = replace_regex$ (.text$, " +", " ", 0)
		.text$ = replace_regex$ (.text$, "^ ", "", 0)
		.text$ = replace_regex$ (.text$, " $", "", 0)

		.length = length (.text$)
		.space = index (.text$, " ")

		# Save all strings as .string'X'$. This is skipped if there is no space
		# in .text$:
		while .space > 0
			.strings = .strings + 1
			.length = length (.text$)
			'.source$'.string'.strings'$ = left$ (.text$, .space - 1)
			.text$ = right$ (.text$, .length - .space)
			.space = index (.text$, " ")
		endwhile

		# If there is no space in the selection, it will be correctly recognized
		# as just one string$. Otherwise, the last string$ is saved in the next
		# two lines:
		.strings = .strings + 1
		'.source$'.string'.strings'$ = .text$

		'.source$'.strings = .strings

	endif
	label TEXT_TO_STRINGS_END
endproc


procedure reverse: .input$, .output$
	'.output$' = ""
	.inputLength = length (.input$)
	for .l to .inputLength
		'.output$' = mid$ (.input$, .l, 1) + '.output$'
	endfor
endproc


procedure speakerMain
	if speaker$ <> "%%Nothing selected.%"
		prevSpeaker$ = speaker$
	endif
	beginPause: "Enter speaker data"
		sentence: "Name", "'name$'"
		optionMenu: "Gender", gender
			option: "male"
			option: "female"
			option: "other"
		integer: "Age", age
		sentence: "Native language", "'native_language$'"
		sentence: "Code", "'speaker_code$'"
		boolean: "Generate code automatically", generate_code_automatically
		boolean: "Save speaker settings", 0
	clicked = endPause: "Cancel", "OK", 2, 1
	if clicked = 2
		if generate_code_automatically = 1
			speakerCode$ = left$ (name$, 1)
			speakerCode$ = replace_regex$ (speakerCode$, ".*", "\L&", 0)
			speakerCodeScreen$ = "(" + speakerCode$ + ")"
			speaker$ = "'name$', 'gender$', 'native_language$', 'age' years"
			speaker = 1
			speaker_code$ = speakerCode$
		else
			speakerCode$ = speaker_code$
			speakerCodeScreen$ = "(" + speakerCode$ + ")"
			speaker$ = "'name$', 'gender$', 'native_language$', 'age' years"
			speaker = 1
		endif
		if save_speaker_settings = 1
			selectObject: settings
			col = Search column: "variable", "name$"
			Set string value: col, "value", """'name$'"""
			col = Search column: "variable", "gender"
			Set numeric value: col, "value", gender
			col = Search column: "variable", "age"
			Set numeric value: col, "value", age
			col = Search column: "variable", "native_language$"
			Set string value: col, "value", """'native_language$'"""
			col = Search column: "variable", "speaker_code$"
			Set string value: col, "value", """'code$'"""
			col = Search column: "variable", "generate_code_automatically"
			Set numeric value: col, "value", generate_code_automatically

			selectObject: settings
			Save as text file: ".pcbrc"
		endif
	endif
endproc


procedure saveMain
	if textGrid <> 0 and sound <> 0 and texts <> 0
		beginPause: "Save"
			comment: "What do you want to save?"
			boolean: "Text file", 1
			optionMenu: "Format of text", 1
				option: "text file"
				option: "tab-separated file"
				option: "comma-separated file"
			boolean: "Recording", 1
			boolean: "Annotation", 1
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			annotation = 0
			recording = 0
			text_file = 0
			
		endif
		if annotation = 1
			fileSave$ = chooseWriteFile$: "Save as text file", "'soundNoExt$'.TextGrid"
			if fileSave$ <> ""
				selectObject: textGrid
				Save as text file: fileSave$
			endif
		endif
		if recording = 1
			fileSave$ = chooseWriteFile$: "Save as WAV file", "'sound$'"
			if fileSave$ <> ""
				Save as WAV file: fileSave$
			endif
		endif
		if text_file = 1
			fileSave$ = chooseWriteFile$: "Save as text file", "'textsPath$'"
			if fileSave$ <> "" and format_of_text$ = "text_file"
				Save as text file: fileSave$
			elif fileSave$ <> "" and format_of_text$ = "tab-separated file"
				Save as tab-separated file: fileSave$
			elif fileSave$ <> "" and format_of_text$ = "tab-separated file"
				Save as comma-separated file: fileSave$
			endif
		endif
	elif textGrid <> 0 and sound = 0 and texts <> 0
		fileSave$ = chooseWriteFile$: "Save as text file", "'soundNoExt$'.TextGrid"
		if fileSave$ <> ""
			selectObject: textGrid
			Save as text file: fileSave$
		endif
	elif textGrid = 0 and sound <> 0
		fileSave$ = chooseWriteFile$: "Save as WAV file", "'sound$'"
		if fileSave$ <> ""
			Save as WAV file: fileSave$
		endif
	else
		@warning: 1, "OK", "", "o", "", "Nothing to save.", ""
	endif
	label SAVE_CANCEL
endproc


#####################
#### TEXTS PROCEDURES
#####################

procedure openTexts
	label OPEN_TEXTS_AGAIN
	if texts$ <> "%%Nothing selected.%"
		prevTexts$ = texts$
	endif
	if !reopen
		textsPath$ = chooseReadFile$: "Open a table file"
	endif

	if rindex (textsPath$, ".wav") > 0 or rindex (textsPath$, ".TextGrid") > 0
		texts$ = prevTexts$
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Select a .txt, .csv",
		... "or similar file."
		goto OPEN_TEXTS_'warningOption$'

	else
		if textsPath$ <> ""
			if texts <> 0
				selectObject: texts
				Remove
			endif
			if !fileReadable (textsPath$)
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "File not readable!",
				... "Check the path!"
				goto OPEN_TEXTS_'warningOption$'
			endif

			texts = Read Table from tab-separated file: textsPath$
			texts$ = selected$ ("Table")
			if reopen = 1
				reopened = 1
			endif
		endif

		.pathLength = length (textsPath$)
		.fullStop = rindex (textsPath$, ".")
		.extension$ = right$ (textsPath$, .pathLength - (.fullStop - 1))
		if !reopened
			texts$ = replace$ (texts$, "_", "\_ ", 0) + .extension$
		else
			texts$ = replace$ (texts$, "_", "\_ ", 0) + .extension$ + " (reopened)"
		endif
	endif
	label OPEN_TEXTS_CANCEL
	reopen = 0
	@TextsScreen
	if reopened = 1
		texts$ = texts$ - " (reopened)"
		reopened = 0
	endif
endproc


procedure inspectTexts
	if texts = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Nothing to inspect.",
		... "Open some texts first."
		if warningOption$ = "OPEN"
			@openTexts
			if texts <> 0
				selectObject: texts
				View & Edit
			endif
		endif
	else
		selectObject: texts
		View & Edit
	endif
endproc


procedure modifyTexts
	label MODIFY_TEXTS_AGAIN
	if texts <> 0
		beginPause: "Modify texts"
			comment: "What do you want to modify?"
			comment: "Rename a column"
			word: "Old label", ""
			word: "New label", ""
			comment: "Change a word"
			integer: "Row number", "0"
			word: "Column label", "orth"
			text: "New word", ""
			comment: "Remove row"
			integer: "Row to remove", "0"
			comment: "Insert row with a word in a column"
			integer: "Row to insert", "0"
			word: "Word to insert", ""
			word: "Column for insertion", "code"
			comment: "Randomize rows"
			boolean: "Randomize rows", 0
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto MODIFY_TEXTS_CANCEL
		endif
		if new_label$ <> old_label$
			selectObject: texts
			nColumns = Get number of columns
			for c to nColumns
				colLabel$ = Get column label: c
				if colLabel$ = old_label$
					Set column label (index): c, new_label$
					textsToSave = 1
				endif
			endfor
		endif
		if row_number <> 0 and column_label$ <> "" and new_word$ <> ""
			selectObject: texts
			nRows = Get number of rows
			nColumns = Get number of columns
			if row_number <= nRows
				for c to nColumns
					colLabel$ = Get column label: c
					if colLabel$ = column_label$
						Set string value: row_number, column_label$, new_word$
						textsToSave = 1
					endif
				endfor
			endif
		endif
		if row_to_remove <> 0
			selectObject: texts
			nRows = Get number of rows
			if row_to_remove <= nRows
				Remove row: row_to_remove
				textsToSave = 1
			endif
		endif
		if row_to_insert <> 0
			selectObject: texts
			nRows = Get number of rows
			if row_to_insert <= nRows + 1
				Insert row: row_to_insert
				textsToSave = 1
			endif
			if word_to_insert$ <> ""
				Set string value: row_to_insert, column_for_insertion$, word_to_insert$
				textsToSave = 1
			endif
		endif
		if randomize_rows = 1
			selectObject: texts
			Randomize rows
			textsToSave = 1
		endif
		label MODIFY_TEXTS_CANCEL
	else
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Nothing to modify.", "Open
		... some texts first."
		if warningOption$ = "OPEN"
			@openTexts
			if texts <> 0
				selectObject: texts
				View & Edit
				goto MODIFY_TEXTS_AGAIN
			endif
		endif
	endif
endproc


procedure saveTexts
	if texts <> 0
		beginPause: "Save texts"
			comment: "Choose file format:"
			optionMenu: "Format of text", 1
				option: "tab-separated file"
				option: "text file"
				option: "comma-separated file"
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto SAVE_TEXTS_CANCEL
		endif

		if format_of_text = 1 or format_of_text = 3
			.extension$ = ".csv"
		elif format_of_text = 2
			.extension$ = ".txt"
		endif
		textsNoExt$ = textsPath$ - right$ (textsPath$, 4)
		fileSave$ = chooseWriteFile$: "Save as text file", "'textsNoExt$''.extension$'"
		if fileSave$ <> "" and format_of_text$ = "text_file"
			Save as text file: fileSave$
		elif fileSave$ <> "" and format_of_text$ = "tab-separated file"
			Save as tab-separated file: fileSave$
		elif fileSave$ <> "" and format_of_text$ = "comma-separated file"
			Save as comma-separated file: fileSave$
		endif

		label SAVE_TEXTS_CANCEL
	else
		@warning: 1, "OK", "", "o", "", "Nothing to save.", ""
	endif
endproc


######################
#### SOUND PROCEDURES
######################

procedure openSound
	label OPEN_SOUND_AGAIN
	if sound$ <> "%%Nothing selected.%"
		prevSound$ = sound$
	endif

	if !reopen and !openWithAnnotation
		soundPath$ = chooseReadFile$: "Open a sound file"
	elif openWithAnnotation
		
	endif

	if openWithAnnotation = 1
		openWithAnnotation = 0
	endif
	
	if soundPath$ = ""
		goto OPEN_SOUND_CANCEL
	endif

	# Restrict sound selection to these formats: AIFF, AIFC, WAV, NIST and FLAC
	if index (soundPath$, ".aiff") = 0 and index (soundPath$, ".aifc") = 0
	... and index (soundPath$, ".wav") = 0
	... and index (soundPath$, ".nist") = 0  and index (soundPath$, ".flac") = 0
	... and index (soundPath$, ".mp3") = 0
		sound$ = prevSound$
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Select a .wav, .aiff, .aifc",
		... ".nist, .flac or mp3 file."
		if warningOption$ = "AGAIN"
			goto OPEN_SOUND_AGAIN
		endif
	else
		if soundPath$ <> ""
			if sound <> 0
				selectObject: sound
				Remove
			endif

			if fileReadable (soundPath$)
				# This is empty so that the script proceeds normally if the file
				# exists and is readable.
			else
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "File not readable!",
				... "Check the path!"
				goto OPEN_SOUND_'warningOption$'
			endif

			sound = Open long sound file: soundPath$
			soundNoExt$ = selected$ ("LongSound")
			View
			editor: "LongSound 'soundNoExt$'"
			.report$ = LongSound info
			Close
			endeditor

			monoOrStereo = extractNumber (.report$, "Number of channels:")
			if monoOrStereo = 1
				monoOrStereo$ = "mono"
			elif monoOrStereo = 2
				monoOrStereo$ = "stereo"
			endif
			monoOrStereoScreen$ = "(" + monoOrStereo$ + ")"

			if reopen = 1
				reopened = 1
			endif
		endif

		pathLength = length (soundPath$)
		fullStop = rindex (soundPath$, ".")
		.extension$ = right$ (soundPath$, pathLength - (fullStop - 1))
		sound$ = soundNoExt$ + .extension$
		soundFolder$ = soundPath$ - sound$
		sound$ = replace$ (sound$, "_", "\_ ", 0)

		if !reopened
			reopenedSound$ = ""
		else
			reopenedSound$ = "(reopened)"
		endif

		if fileReadable (soundFolder$ + slash$ + soundNoExt$ + ".TextGrid") and !textGrid and !reopen
			textGridPath$ = soundFolder$ + slash$ + soundNoExt$ + ".TextGrid"
			openWithSound = 1
			@openAnnotation
		endif
	endif
	label OPEN_SOUND_CANCEL
	reopen = 0
	@SoundScreen
	if reopened = 1
		reopenedSound$ = ""
		reopened = 0
	endif
endproc


procedure viewSound
	if sound = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Open a sound", "file first."
		if warningOption$ = "OPEN"
			@openSound
		endif
	else
		selectObject: sound
		View
		editor: "LongSound 'soundNoExt$'"
		Move cursor to: 0
		endeditor
	endif
endproc


procedure extractSound
	if sound = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Open a sound", "file first."
		if warningOption$ = "OPEN"
			@openSound
		endif
			goto EXTRACT_SOUND_CANCEL
	elif textGrid = 0
		@warning: 2, "TEXTGRID", "CANCEL", "t", "c", "Open or create", "a
		... TextGrid first."
		if warningOption$ = "TEXTGRID"
			screen = 5
			screen$ = screen'screen'$
			@'screen$'Screen
			endif
		goto EXTRACT_SOUND_CANCEL
	endif
	beginPause: "Select extraction options"
		comment: "Select the tier for interval extraction"
		natural: "Tier to extract", 1
		comment: "Do not extract intervals labelled with a particular label:"
		comment: "(If empty, all labelled intervals will be extracted.)"
		word: "Skip label", "xxx"
		comment: "Include speaker code in the extract name?"
		boolean: "Include code", 1
	clicked = endPause: "Cancel", "Continue", 2, 1
	if clicked = 1
		goto EXTRACT_SOUND_CANCEL
	endif

	if include_code = 1 and speakerCode$ <> ""
		extSpeaker$ = "-" + "'speakerCode$'"
	elif include_code = 1
		@warning: 2, "SELECT", "CANCEL", "", "", "No speaker selected.", "Do it now?"
		if warningOption$ = "SELECT"
			@speakerMain
			if speakerCode$ <> ""
				extSpeaker$ = "-" + "'speakerCode$'"
			else
				extSpeaker$ = ""
			endif
		else
			extSpeaker$ = ""
		endif
	else
		extSpeaker$ = ""
	endif

	selectObject: textGrid
	numberOfIntervals = Get number of intervals: tier_to_extract

	intToExtract = 0
	for int to numberOfIntervals
		selectObject: textGrid
		intLabel$ = Get label of interval: tier_to_extract, int
		if intLabel$ <> skip_label$ and intLabel$ <> ""
			intToExtract = intToExtract + 1
			extract'intToExtract' = int
		endif
	endfor

	# This if-jump extracts the samples and renames them to match their "code".
	if intToExtract = 0
		@warning: 1, "OK", "", "o", "", "'No intervals", "to extract."
	else
		@warning: 2, "EXTRACT", "CANCEL", "e", "c", "'intToExtract' samples will
		... be", "extracted."

		if warningOption$ = "CANCEL"
			goto EXTRACT_SOUND_CANCEL
		endif

		if nExtracts <> 0 and extractsToSave = 0
			label EXTRACT_SOUND_REMOVE
			@removeExtracts
		elif nExtracts <> 0 and extractsToSave = 1
			@warning: 2, "REMOVE", "CANCEL", "r", "c", "Remove existing",
			... "extracted files?"
			goto EXTRACT_SOUND_'warningOption$'
		endif

		extracts = Create Table with column names: "extracts", 0, "Extracts"

		for int to intToExtract
			selectObject: textGrid
			startTime = Get starting point: tier_to_extract, extract'int'
			endTime = Get end point: tier_to_extract, extract'int'
			extLabel$ = Get label of interval: tier_to_extract, extract'int'

			if repeated_item$ <> "" and index (right$ (extLabel$, 3), repeated_item$) <> 0
				rep$ = right$ (extLabel$, 3)
				extLabel$ = "'extLabel$'" - rep$ + extSpeaker$ + rep$
			else
				extLabel$ = "'extLabel$''extSpeaker$'"
			endif

			selectObject: sound
			extracts'int' = Extract part: startTime, endTime, "no"
			Rename: "'extLabel$'"
			selectObject: extracts
			Append row
			Set string value: int, "Extracts", extLabel$ + ".wav"

			extracts'int'$ = extLabel$
			nExtracts += 1
			extracts'int'marked = 0
		endfor
		extracts$ = "You have 'nExtracts' extracts."
		extractsToSave = 1
		extrClicked = 1

		extrColumns = floor (nExtracts / 25)

	endif
	label EXTRACT_SOUND_CANCEL
endproc


procedure convertSound
	label CONVERT_SOUND_AGAIN
	if sound = 0 and nExtracts = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Open a sound", "file first."
		if warningOption$ = "OPEN"
			@openSound
			if sound <> 0
				goto CONVERT_SOUND_OPENED
			endif
		endif
		goto CONVERT_SOUND_CANCEL

	else
		label CONVERT_SOUND_OPENED
		if monoOrStereo$ = "mono"
			oppositeMOS$ = "stereo"
		elif monoOrStereo$ = "stereo"
			oppositeMOS$ = "mono"
		endif

		beginPause: "Convert sound files"
			comment: "Convert the original file to 'oppositeMOS$'?"
			boolean: "Convert to 'oppositeMOS$'", 0
			comment: "Select a new name for the file:"
			word: "Name of 'oppositeMOS$'", "'soundNoExt$'_'oppositeMOS$'"
			comment: "Convert extracted sound files?"
			boolean: "Extracted files to mp3", 0
			comment: "For the conversion, the originally extracted .wav files have to be saved."
			comment: "Do you want to discard these .wav files after conversion?"
			boolean: "Discard extracted wav", 0
			comment: "Select the bit rate:"
			optionMenu: "Bit rate (kbit/s)", 4
				option: "128"
				option: "160"
				option: "224"
				option: "320"
			comment: "Select the sampling rate:"
			optionMenu: "Sampling rate (Hz)", 2
				option: "22050"
				option: "44100"
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto CONVERT_SOUND_CANCEL
		endif
	
	endif
	
	if convert_to_'oppositeMOS$' = 1 and fileReadable (soundPath$)
		.originalDirectoryName$ = chooseDirectory$: "Choose a directory to save the converted long sound file in"
		if .originalDirectoryName$ = ""
			goto CONVERT_SOUND_CANCEL
		endif
		selectObject: sound
		Remove
		'monoOrStereo$'Sound = Read from file: "'soundPath$'"
		'oppositeMOS$'Sound = Convert to 'oppositeMOS$'
		name_of_new_file$ = name_of_'oppositeMOS$'$
		soundPath$ = "'.originalDirectoryName$'/'name_of_new_file$'.wav"
		Save as WAV file: "'soundPath$'"
		selectObject: 'oppositeMOS$'Sound
		plusObject: 'monoOrStereo$'Sound
		Remove
		sound =  Open long sound file: soundPath$
		soundNoExt$ = selected$ ("LongSound")

		selectObject: sound
		View
		editor: "LongSound 'soundNoExt$'"
		.report$ = LongSound info
		Close
		endeditor

		monoOrStereo = extractNumber (.report$, "Number of channels:")
		if monoOrStereo = 1
			monoOrStereo$ = "mono"
		elif monoOrStereo = 2
			monoOrStereo$ = "stereo"
		endif
		monoOrStereoScreen$ = "(" + monoOrStereo$ + ")"

		pathLength = length (soundPath$)
		fullStop = rindex (soundPath$, ".")
		.extension$ = right$ (soundPath$, pathLength - (fullStop - 1))
		sound$ = soundNoExt$ + .extension$
		soundFolder$ = soundPath$ - sound$
		sound$ = replace$ (sound$, "_", "\_ ", 0)
	endif

	label CONVERT_SOUND_EXTRACTED_FILES_OPENED
	if extracted_files_to_mp3 = 1 and nExtracts <> 0
		extractsFolder$ = chooseDirectory$: "Choose a directory to save the converted extracted files in"
		if extractsFolder$ <> ""
			for i to nExtracts
				selectObject: extracts'i'
				.extWavTemp$ = extracts'i'$
				.path$ = "'extractsFolder$''slash$''.extWavTemp$'.wav"
				.out$ = "'extractsFolder$''slash$''.extWavTemp$'.mp3"
				Save as WAV file: "'extractsFolder$''slash$''.extWavTemp$'.wav"
				if unix = 1 or macintosh = 1
					system lame -h -V 2 --resample 'sampling_rate$' --tt '.extWavTemp$' --ty 'year' -b 'bit_rate$' '.path$' '.out$'
				elif windows = 1
					system .\lame\lame.exe -h -V 2 --resample 'sampling_rate$' --tt '.extWavTemp$' --ty 'year' -b 'bit_rate$' '.path$' '.out$'
				endif
				if discard_extracted_wav = 1
					deleteFile (.path$)
				endif
			endfor
		endif
	elif extracted_files_to_mp3 = 1 and nExtracts = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "No extracted", "sounds to convert."
		if warningOption$ = "OPEN"
			@openExtracts
			if nExtracts <> 0
				goto CONVERT_SOUND_EXTRACTED_FILES_OPENED
			endif
		endif
	endif

	label CONVERT_SOUND_CANCEL
endproc


procedure saveSound
	if sound <> 0
		beginPause: "Save"
			comment: "What do you want to save?"
			boolean: "Original long sound file", 0
			boolean: "Extracted sounds", 0
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto SAVE_SOUND_CANCEL
		endif

		if original_long_sound_file = 1
			selectObject: sound
			fileSave$ = chooseWriteFile$: "Save as WAV file", "'soundNoExt$'.wav"
			if fileSave$ <> ""
				Save as WAV file: fileSave$
			endif
		endif
		if extracted_sounds = 1
			if extractsToSave = 0
				@warning: 1, "OK", "", "o", "", "No extracted", "sounds to
				... save."
				goto SAVE_SOUND_CANCEL
			endif
			.directory$ = chooseDirectory$: "Choose a directory to save all the new files in"
			if .directory$ <> ""
				for n to nExtracts
					selectObject: extracts'n'
					fileToSave$ = extracts'n'$
					Save as WAV file: "'.directory$'/'fileToSave$'.wav"
				endfor
			endif
		endif
	else
		@warning: 1, "OK", "", "o", "", "Nothing to save.", ""
	endif
	label SAVE_SOUND_CANCEL
endproc


#########################
#### EXTRACTS PROCEDURES
#########################

procedure PaintSoundWave: .markedExtr
	selectObject: extracts'.markedExtr'
	.extrDur = Get total duration
	if .extrDur < 10
		.lines = 10
		.steps = 0.1
	else
		.lines = 100
		.steps = 1
	endif
	.extrStep = .lines / .extrDur

	# Select the Sound Wave viewport
	demo Select inner viewport: 53, 97, 83, 97
	demo Axes: 0, 100, 0, 100

	# Repaint the Sound Wave window
	demo Paint rectangle: backgroundColour$, -5, 115, -10, 115
	demo Paint rectangle: foreGroundColour$, 0, 100, 0, 100

	# Draw the 100 ms lines
	nSteps = floor (.extrDur / .steps)
	for .s to nSteps
		demo Line width: 1.0
		demo Draw line: (.extrStep * .s), 0.0, (.extrStep * .s), -5
	endfor

	# Draw lines at start and end of the recording to see if the
	# recording will have enough silence at the end, so that it is played
	# correctly with external media players:
	demo Red
	demo Line width: 0.5

	if (final_margin + initial_margin < (1000 * .extrDur * 0.85))
		if final_margin > 0
			demo Text special: 100 - (.extrStep * final_margin / 100), "centre", 102, "bottom", "Helvetica", 10, "0", string$(final_margin) + " ms from end"
			demo Draw line: 100 - (.extrStep * final_margin / 100), 100.0, 100 - (.extrStep * final_margin / 100), 0.0
		endif
		if initial_margin > 0
			demo Text special: (.extrStep * initial_margin / 100), "centre", 102, "bottom", "Helvetica", 10, "0", string$(initial_margin) + " ms from start"
			demo Draw line: (.extrStep * initial_margin / 100), 100.0, (.extrStep * initial_margin / 100), 0.0
		endif
	else
		demo Text special: 50, "centre", 102, "bottom", "Helvetica", 10, "0", "Margins too close"
	endif

	demo Black

	# Draw the sound wave.
	demo Line width: 0.75
	demo Draw: 0, 0, 0, 0, "yes", "Curve"

	demo Select inner viewport: 0, 100,  0, 100
	demo Axes: 0, 100, 0, 100
	demo Line width: 2.0
endproc

procedure PaintExtractsWindow: .extrItems, .markedExtr
	@PaintSoundWave: .markedExtr
	@PaintExtracts: nExtracts, .markedExtr
endproc

# Write out the extracts if there are any and highlight the selected one.
procedure PaintExtracts: .extrItems, .markedExtr
	demo Black
	extrPage = floor (.markedExtr / 100.1) + 1
	maxItemsOnPage = extrPage * 100
	if extrPages > 1
		demo Paint rectangle: backgroundColour$, colX - ((colHor * 4)) - 0.25, colX - ((colHor * 4)) + 5, colY, colY + 3
		demo Text special: 25, "left", 78, "bottom", "Helvetica", 15, "0", "< 'extrPage' / 'extrPages' >"
	endif
	demo Paint rectangle: foreGroundColour$, colX - ((colHor * 4)) - 0.25, colX + 0.25, colY - 75.5, colY + 0.5

	# for 4 columns with at most 25 items each:
	for .c to 4
		if .extrItems > (maxItemsOnPage + 25) - (.c * 25)
			.extrItems = (maxItemsOnPage + 25) - (.c * 25)
			extrItems = .extrItems
		endif

		for .i from (maxItemsOnPage - (.c * 25) + 1) to .extrItems

			.x = colX - (.c * colHor)
			.y = colY - (3 * (.i - (maxItemsOnPage - (.c * 25))))

			demo Paint rectangle: "{1, 1, 1}",
			... colX - (.c * colHor) + 0.25, colX - (.c * colHor) + 1.2,
			... colY - (3 * (.i - (maxItemsOnPage - (.c * 25)))) + 1.1, colY + colVert - (3 * (.i - (maxItemsOnPage - (.c * 25)))) - 0.6
			if extracts'.i'marked = 1
				demo Draw line: .x + 0.3, .y + 1.1, .x + 1.2, .y - 0.65 + colVert
				demo Draw line: .x + 0.3, .y - 0.65 + colVert, .x + 1.2, .y + 1.1
			endif

			extrName$ = extracts'.i'$
			extrName$ = replace$ (extrName$, "_", "\_ ", 0)
			demo Text special: colTextX - (.c * colHor), "left", colTextY - (3 * (.i - (maxItemsOnPage - (.c * 25) + 1))), "half", "Helvetica", 10, "0", "\O.  '.i'. 'extrName$'.wav"
		endfor
	endfor

	# Write and draw the selected item.
	for .c to 4
		if .markedExtr > (maxItemsOnPage - (.c * 25)) and .markedExtr < ((maxItemsOnPage + 26) - (.c * 25))
			.x = colX - (.c * colHor)
			.y = colY - (3 * (.markedExtr - (maxItemsOnPage - (.c * 25))))
			demo White

			# Paint the background of the selected item.
			demo Paint rectangle: backgroundColour$, .x, .x + colHor, .y, .y + colVert

			# Paint the check box.
			demo Paint rectangle: "{1, 1, 1}", .x + 0.25, .x + 1.2, .y + 1.1, .y - 0.6 + colVert
			extrName$ = extracts'.markedExtr'$
			extrName$ = replace$ (extrName$, "_", "\_ ", 0)
			demo Text special: colTextX - (.c * colHor), "left", colTextY - (3 * (.markedExtr - (maxItemsOnPage - (.c * 25) + 1))), "half", "Helvetica", 10, "0", "\O.  '.markedExtr'. 'extrName$'.wav"
			if extracts'.markedExtr'marked = 1
				demo Black
				demo Draw line: .x + 0.3, .y + 1.1, .x + 1.2, .y - 0.65 + colVert
				demo Draw line: .x + 0.3, .y - 0.65 + colVert, .x + 1.2, .y + 1.1
			endif
		endif
	endfor
	demo Black
endproc

procedure previewSettings
	label PREVIEW_SETTINGS_AGAIN

	beginPause: "Choose preview settings"
		comment: "Select the initial and final margins (red lines) in milliseconds."
		comment: "Cannot be negative, default values are 150 and 150 ms, respectively."
		comment: "Set to 0 to disable margins."
		real: "Initial margin (ms)", initialMargin
		real: "Final margin (ms)", finalMargin
		boolean: "Save preview settings", 0
	clicked = endPause: "Cancel", "Apply", 2, 1
	if clicked = 1
		goto PREVIEW_SETTINGS_CANCEL
	endif

	# Force the Initial and Final margins into sensible values.
	if initial_margin < 0
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Initial margin cannot be negative:", """'initial_margin'"""
		if warningOption$ = "AGAIN"
			goto PREVIEW_SETTINGS_AGAIN
		else
			goto PREVIEW_SETTINGS_CANCEL
		endif
	elif final_margin < 0
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Final margin cannot be negative:", """'final_margin'"""
		if warningOption$ = "AGAIN"
			goto PREVIEW_SETTINGS_AGAIN
		else
			goto PREVIEW_SETTINGS_CANCEL
		endif
	endif

	if save_preview_settings = 1
		selectObject: settings
		col = Search column: "variable", "initialMargin"
		Set numeric value: col, "value", initial_margin
		initialMargin = initial_margin
		col = Search column: "variable", "finalMargin"
		Set numeric value: col, "value", final_margin
		finalMargin = final_margin
		selectObject: settings
		Save as text file: ".pcbrc"
	endif

	label PREVIEW_SETTINGS_CANCEL
endproc


procedure removeExtracts
	# Remove old extracts, the extracts table and the .folderContents table
	# before opening new ones:
	selectObject: extracts
	for i to nExtracts
		plusObject: extracts'i'
		extracts'i'$ = ""
		extracts's'marked = 0
	endfor
	Remove
	extracts = 0
	nExtracts = 0
	extrClicked = 0
	extrMarked = 0
endproc


procedure openExtracts
	label OPEN_EXTRACTS_AGAIN
	.dirInList = 0
	label OPEN_EXTRACTS_SELECT
	if extracts$ <> "%%Nothing selected.%"
		prevExtracts$ = extracts$
	endif

	beginPause: "Do you want to use previous extracts folder?"
		comment: "Do you want to use the previous extracts folder:"
		folderLength = length (openPreviousExtractsFolder$) 
		if folderLength > 80
			comment: left$ (openPreviousExtractsFolder$, 80) + "..."
			comment: "..." + right$ (openPreviousExtractsFolder$, folderLength - 80) + "?"
		else
			comment: openPreviousExtractsFolder$ + "?"
		endif
		word: "Previous", openPreviousExtractsFolder$
		comment: "Do you want to save new extracts folder name?"
		boolean: "Save extracts folder name", 1
	clicked = endPause: "Cancel", "Use previous", "Choose new", 2, 1
	if clicked = 1
		goto OPEN_EXTRACTS_CANCEL
	elif clicked = 3
		extractsFolder$ = chooseDirectory$: "Choose a directory to open short extracts from"
		if extractsFolder$ = ""
			goto OPEN_EXTRACTS_CANCEL
		endif
	else
		.slashRindex = rindex (previous$, slash$)
		.pathToDir$ = left$ (previous$, .slashRindex)
		.dirName$ = right$ (previous$, length (previous$) - .slashRindex)
		.dir_list = Create Strings as directory list: "directoryList", .pathToDir$
		nDirs = Get number of strings
		for d to nDirs
			selectObject: .dir_list
			d$ = Get string: d
			if .dirName$ = d$
				.dirInList = 1
			endif
		endfor
		removeObject: .dir_list
		if .dirInList
			extractsFolder$ = previous$
		else
			.dirScreen$ = replace$ (.dirName$, "_", "\_ ", 0)
			@warning: 2, "AGAIN", "CANCEL", "o", "c", "Folder '.dirScreen$' does",
			... "not exist."
			if warningOption$ = "AGAIN"
				goto OPEN_EXTRACTS_AGAIN
			else
				goto OPEN_EXTRACTS_CANCEL
			endif
		endif
	endif

	if save_extracts_folder_name = 1
		openPreviousExtractsFolder$ = extractsFolder$
		selectObject: settings
		if unix
			variable$ = "openPreviousExtractsFolderUnix$"
		else
			variable$ = "openPreviousExtractsFolderWindows$"
		endif
		col = Search column: "variable", "'variable$'"
		Set string value: col, "value", """'openPreviousExtractsFolder$'"""
		selectObject: settings
		Save as text file: ".pcbrc"
	endif

	.folderContents = Create Strings as file list: "extractsFolderContents", "'extractsFolder$'"
	.nFiles = Get number of strings

	.n_openable = 0

	for n to .nFiles
		selectObject: .folderContents
		.file$ = Get string: n
		# Get extension including the dot
		.dot_index = rindex (.file$, ".")
		.extension$ = right$ (.file$, length (.file$) - .dot_index + 1)
		if .extension$ = ".wav" or .extension$ = ".mp3" or .extension$ = ".flac"
			.n_openable = .n_openable + 1
			.openableFull'.n_openable'$ = .file$
			.n_openable'.n_openable'$ = .file$ - .extension$
		endif
	endfor

	if .n_openable = 0
		selectObject: .folderContents
		Remove
		.folderContents = 0
		@warning: 2, "SELECT", "CANCEL", "s", "c", "Select a folder which", "contains .wav, .mp3, or .flac"
		goto OPEN_EXTRACTS_'warningOption$'

	elif nExtracts <> 0 and extracts <> 0 and extractsToSave = 1
		@warning: 2, "REMOVE", "CANCEL", "r", "c", "Remove existing", "extracted files?"
		if warningOption$ = "REMOVE"
			@removeExtracts
		else
			goto OPEN_EXTRACTS_CANCEL
		endif
	endif

	selectObject: .folderContents
	Remove
	.folderContents = 0

	if .n_openable > 0
		nExtracts = .n_openable
		extracts = Create Table with column names: "extracts", 0, "Extracts"
		for n to nExtracts
			fileName$ = .openableFull'n'$
			extracts'n'$ = .n_openable'n'$
			extracts'n' = Read from file: "'extractsFolder$'/'fileName$'"
			Rename: extracts'n'$
			selectObject: extracts
			Append row
			Set string value: n, "Extracts", fileName$
			extracts'n'marked = 0
		endfor
		extracts$ = "You have 'nExtracts' extracts."
		extractsToSave = 1
		
		@extrScreenValues
		repaint = 1
	else
		extracts$ = "%%Nothing selected.%"
	endif
	label OPEN_EXTRACTS_CANCEL
endproc


procedure extrScreenValues
	extrPages = floor (nExtracts / 100.1) + 1
	extrPage = 1
	extrColumns = (floor (nExtracts / 25.1) + 1) - ((extrPages - 1) * 4)
	extrClicked = 1
endproc


procedure viewExtracts
	label LISTEN_EXTRACTS_AGAIN
	if extracts = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "No extracts", "to listen to."
		if warningOption$ = "OPEN"
			@openExtracts
			if extracts <> 0
				@ExtractsScreen
				demoShow ()
				goto LISTEN_EXTRACTS_AGAIN
			endif
		endif
	else
		if extrClicked = 0
			extrClicked = 1
		endif
		selectObject: extracts'extrClicked'
		if viewAndPlay
			asynchronous Play
			viewAndPlay = 0
		endif
		View & Edit
		editor: "Sound " + extracts'extrClicked'$
		Move cursor to: 0
		endeditor
	endif
	label LISTEN_EXTRACTS_CANCEL
endproc


procedure fadeExtracts
	label FADE_EXTRACTS_AGAIN

	if extracts <> 0
		beginPause: "Apply fade in/out extracts"
			comment: "Which extracts do you want to apply fade in/out to?"
			comment: "Write the numbers of the samples, or a range like this: ""1 3-5 8""."
			if extrMarked > 0
				@markedToString
				text: "Select extracted", select$
			elif nExtracts = 1
				text: "Select extracted", "1"
			else
				text: "Select extracted", "1-'nExtracts'"
			endif
			comment: "Set to 0 if you do not wish to apply either one:"
			real: "Fade in (tens of ms)", fadeIn
			real: "Fade out (tens of ms)", fadeOut
			boolean: "Save fade settings", 0
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto FADE_EXTRACTS_CANCEL
		endif

		if save_fade_settings = 1
			selectObject: settings
			col = Search column: "variable", "fadeIn"
			Set numeric value: col, "value", fade_in
			fadeIn = fade_in
			col = Search column: "variable", "fadeOut"
			Set numeric value: col, "value", fade_out
			fadeOut = fade_out
			selectObject: settings
			Save as text file: ".pcbrc"
		endif

		# change the tens-of-ms values to values appropriate for the cosine
		# function below
		fade_in = fade_in / 100
		fade_out = fade_out / 100

		.items = 0

		# .nor stands for "numbers or ranges" that will be extracted from the
		# string "Select_exstacted"
		.nor = 0

		.label$ = "CONTINUE"
		@textToNumbers: "fadeExtracts", select_extracted$, nExtracts, 0

		# If the .label$ variable does not get its value in the @textToNumbers
		# procedure, it has the default value "CONTINUE"
		goto FADE_EXTRACTS_'.label$'
		label FADE_EXTRACTS_CONTINUE

		# this if cycle creates the fade in/out
		if .items > 0
			for i to .items
				va = .value'i'
				selectObject: extracts'va'
				.end = Get end time
				if fade_in > 0
					Set part to zero: 0, 0.001, "at exactly these times"
					Formula: "if x < fade_in then self * (1 - (cos (0.5 * pi * (x / fade_in)) ^ 2)) else self fi"
				endif
				if fade_out > 0
					Set part to zero: .end - 0.001, .end, "at exactly these times"
					Formula: "if (x > (.end - fade_out)) then self * (1 - (cos ((0.5 * pi * ((.end - x) / fade_out))) ^ 2)) else self fi"
				endif
			endfor
		endif
		fade_in = fade_in * 100
		fade_out = fade_out * 100

	else
		@warning: 2, "OPEN", "CANCEL", "o", "c", "No extracts to apply", "fade in/out to."
		if warningOption$ = "OPEN"
			@openExtracts
		endif
		goto FADE_EXTRACTS_CANCEL
	endif
	label FADE_EXTRACTS_CANCEL
endproc


procedure addSilenceExtracts
	label ADD_SILENCE_EXTRACTS_AGAIN

	if extracts <> 0
		beginPause: "Add silence to extracts"
			comment: "Which extracts do you want to add silence to?"
			comment: "Write the numbers of the samples, or a range like this: ""1 3-5 8""."
			if extrMarked > 0
				@markedToString
				text: "Select extracted", select$
			elif nExtracts = 1
				text: "Select extracted", "1"
			else
				text: "Select extracted", "1-'nExtracts'"
			endif
			comment: "Set to 0 if you do not wish to apply either one:"
			real: "Prepend silence (ms)", prependSilence
			real: "Append silence (ms)", appendSilence
			boolean: "Save add silence settings", 0
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto ADD_SILENCE_EXTRACTS_CANCEL
		endif

		if save_add_silence_settings = 1
			selectObject: settings
			col = Search column: "variable", "prependSilence"
			Set numeric value: col, "value", prepend_silence
			prependSilence = prepend_silence
			col = Search column: "variable", "appendSilence"
			Set numeric value: col, "value", append_silence
			appendSilence = append_silence
			selectObject: settings
			Save as text file: ".pcbrc"
		endif

		.items = 0

		# .nor stands for "numbers or ranges" that will be extracted from the
		# string "Select_exstacted"
		.nor = 0

		.label$ = "CONTINUE"
		@textToNumbers: "addSilenceExtracts", select_extracted$, nExtracts, 0

		# If the .label$ variable does not get its value in the @textToNumbers
		# procedure, it has the default value "CONTINUE"
		goto ADD_SILENCE_EXTRACTS_'.label$'
		label ADD_SILENCE_EXTRACTS_CONTINUE

		# these if cycles prepend and append silence:
		if .items > 0
			if prepend_silence > 0
				prep_sil_s = prepend_silence / 1000
				for i to .items
					va = .value'i'
					selectObject: extracts'va'
					sampling_frequency = Get sampling frequency
					silence = Create Sound: "silence", 0, prep_sil_s, sampling_frequency, "0"
					selectObject: extracts'va'
					new = Copy: extracts'va'$
					selectObject: extracts'va'
					Remove
					extracts'va' = new
					selectObject: silence
					plusObject: extracts'va'
					new = Concatenate
					selectObject: extracts'va'
					plusObject: silence
					Remove
					extracts'va' = new
					selectObject: extracts'va'
					Rename: extracts'va'$
				endfor
			endif

			if append_silence > 0
				app_sil_s = append_silence / 1000
				for i to .items
					va = .value'i'
					selectObject: extracts'va'
					sampling_frequency = Get sampling frequency
					silence = Create Sound: "silence", 0, app_sil_s, sampling_frequency, "0"
					selectObject: extracts'va'
					plusObject: silence
					new = Concatenate
					selectObject: extracts'va'
					plusObject: silence
					Remove
					extracts'va' = new
					selectObject: extracts'va'
					Rename: extracts'va'$
				endfor
			endif
		endif

	else
		@warning: 2, "OPEN", "CANCEL", "o", "c", "No extracts to add", "silence to."
		if warningOption$ = "OPEN"
			@openExtracts
		endif
		goto ADD_SILENCE_EXTRACTS_CANCEL
	endif
	label ADD_SILENCE_EXTRACTS_CANCEL
endproc


procedure trimExtracts
	label TRIM_EXTRACTS_AGAIN

	if extracts <> 0
		beginPause: "Trim extracts"
			comment: "Which extracts do you want to trim?"
			comment: "Write the numbers of the samples, or a range like this: ""1 3-5 8""."
			if extrMarked > 0
				@markedToString
				text: "Select extracted", select$
			elif nExtracts = 1
				text: "Select extracted", "1"
			else
				text: "Select extracted", "1-'nExtracts'"
			endif
			comment: "Set to 0 if you do not wish to apply either one:"
			real: "Trim beginning (ms)", trimBeginning
			real: "Trim end (ms)", trimEnd
			boolean: "Save trim settings", 0
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto TRIM_EXTRACTS_CANCEL
		endif

		if save_trim_settings = 1
			selectObject: settings
			col = Search column: "variable", "trimBeginning"
			Set numeric value: col, "value", trim_beginning
			trimBeginning = trim_beginning
			col = Search column: "variable", "trimEnd"
			Set numeric value: col, "value", trim_end
			trimEnd = trim_end
			selectObject: settings
			Save as text file: ".pcbrc"
		endif

		.items = 0

		# .nor stands for "numbers or ranges" that will be extracted from the
		# string "Select_exstacted"
		.nor = 0

		.label$ = "CONTINUE"
		@textToNumbers: "trimExtracts", select_extracted$, nExtracts, 0

		# If the .label$ variable does not get its value in the @textToNumbers
		# procedure, it has the default value "CONTINUE"
		goto TRIM_EXTRACTS_'.label$'
		label TRIM_EXTRACTS_CONTINUE

		# these if cycles trim the extracts:
		if .items > 0
			for i to .items
				va = .value'i'
				selectObject: extracts'va'
				.end = Get end time
				trim_beg = trim_beginning / 1000
				if trim_beg > 0 and trim_beg < .end
					new = Extract part: trim_beg, .end, "rectangular", 1, "no"
					selectObject: extracts'va'
					Remove
					extracts'va' = new
					selectObject: extracts'va'
					Rename: extracts'va'$
				endif
				selectObject: extracts'va'
				.end = Get end time
				trim_e = trim_end / 1000
				if trim_e > 0 and trim_e < .end
					new = Extract part: 0, .end - trim_e, "rectangular", 1, "no"
					selectObject: extracts'va'
					Remove
					extracts'va' = new
					selectObject: extracts'va'
					Rename: extracts'va'$
				endif
			endfor
		endif

	else
		@warning: 2, "OPEN", "CANCEL", "o", "c", "No extracts to trim.", ""
		if warningOption$ = "OPEN"
			@openExtracts
		endif
		goto TRIM_EXTRACTS_CANCEL
	endif
	label TRIM_EXTRACTS_CANCEL
endproc


procedure convertExtracts
	label CONVERT_EXTRACTS_AGAIN
	extracted_files_to_mp3 = 0

	if nExtracts = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Nothing to convert.", ""
		if warningOption$ = "OPEN"
			@openExtracts
		endif
		goto CONVERT_EXTRACTS_CANCEL

	else
		beginPause: "Convert extracts"
			comment: "Convert the extracted sound files to mp3?"
			boolean: "Extracted files to mp3", 1
			comment: "Which extracts do you want to convert?"
			comment: "Write the numbers of the samples, or a range like this: ""1 3-5 8""."
			if extrMarked > 0
				@markedToString
				text: "Select extracted", select$
			elif nExtracts = 1
				text: "Select extracted", "1"
			else
				text: "Select extracted", "1-'nExtracts'"
			endif
			comment: "Do you want to discard the originally extracted .wav files?"
			comment: "(WARNING: If you save converted files in the same folder,"
			comment: "as the originals, these would be deleted too!)"
			boolean: "Discard extracted wav", 1
			comment: "Select the bit rate:"
			optionMenu: "Bit rate (kbit/s)", 4
				option: "128"
				option: "160"
				option: "224"
				option: "320"
			comment: "Select the sampling rate:"
			optionMenu: "Sampling rate (Hz)", 2
				option: "22050"
				option: "44100"
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto CONVERT_EXTRACTS_CANCEL
		endif
	endif

	if extracted_files_to_mp3 = 1
		.items = 0
		.nor = 0
		.label$ = "CONTINUE"
		@textToNumbers: "convertExtracts", select_extracted$, nExtracts, 0
		# If the .label$ variable does not get its value in the @textToNumbers
		# procedure, it has the default value "CONTINUE"
		goto CONVERT_EXTRACTS_'.label$'
		label CONVERT_EXTRACTS_CONTINUE

		if .items > 0
			extractsFolder$ = chooseDirectory$: "Choose a directory to save the converted extracted files in"
			if extractsFolder$ <> ""
				for i to .items
					va = .value'i'
					selectObject: extracts'va'
					.extWavTemp$ = extracts'va'$
					.path$ = "'extractsFolder$'/'.extWavTemp$'.wav"
					.out$ = "'extractsFolder$'/'.extWavTemp$'.mp3"
					Save as WAV file: .path$
					if unix = 1 or macintosh = 1
						system lame -h -V 2 --resample 'sampling_rate$' --tt '.extWavTemp$' --ty 'year' -b 'bit_rate$' '.path$' '.out$'
					elif windows = 1
						system .\lame\lame.exe -h -V 2 --resample 'sampling_rate$' --tt '.extWavTemp$' --ty 'year' -b 'bit_rate$' '.path$' '.out$'
					endif
					if discard_extracted_wav = 1
						deleteFile (.path$)
					endif
				endfor
			endif
		endif
	else
		@warning: 1, "OK", "", "o", "", "Select something else.", ""
	endif
	label CONVERT_EXTRACTS_CANCEL
endproc


procedure saveExtracts
	label SAVE_EXTRACTS_AGAIN

	if nExtracts <> 0
		beginPause: "Save"
			comment: "Which extracts do you want to save?"
			comment: "Write the numbers of the samples, or a range like this: ""1 3-5 8""."
			if extrMarked > 0
				@markedToString
				text: "Select extracted", select$
			elif nExtracts = 1
				text: "Select extracted", "1"
			else
				text: "Select extracted", "1-'nExtracts'"
			endif
		clicked = endPause: "Cancel", "Continue", 2, 1
		if clicked = 1
			goto SAVE_EXTRACTS_CANCEL
		endif

		.items = 0
		.nor = 0
		.label$ = "CONTINUE"
		@textToNumbers: "saveExtracts", select_extracted$, nExtracts, 0
		goto SAVE_EXTRACTS_'.label$'
		label SAVE_EXTRACTS_CONTINUE

		# Save the objects according to the list produced byt the @textToNumbers
		# procedure:
		if .items > 0
			beginPause: "Do you want to use previous extracts folder?"
				comment: "Do you want to use the previous extracts folder:"
				folderLength = length (savePreviousExtractsFolder$) 
				if folderLength > 80
					comment: left$ (savePreviousExtractsFolder$, 80) + "..."
					comment: "..." + right$ (savePreviousExtractsFolder$, folderLength - 80) + "?"
				else
					comment: savePreviousExtractsFolder$ + "?"
				endif
				comment: "Do you want to save new extracts folder name?"
				boolean: "Save extracts folder name", 1
			clicked = endPause: "Cancel", "Use previous", "Choose new", 2, 1
			if clicked = 1
				goto SAVE_EXTRACTS_CANCEL
			elif clicked = 3
				.directory$ = chooseDirectory$: "Choose a directory to save the files in"
				if extractsFolder$ = ""
					goto SAVE_EXTRACTS_CANCEL
				endif
			else
				.directory$ = savePreviousExtractsFolder$
			endif

			if save_extracts_folder_name = 1
				savePreviousExtractsFolder$ = .directory$
				selectObject: settings
				if unix
					variable$ = "savePreviousExtractsFolderUnix$"
				else
					variable$ = "savePreviousExtractsFolderWindows$"
				endif
				col = Search column: "variable", "'variable$'"
				Set string value: col, "value", """'savePreviousExtractsFolder$'"""
				selectObject: settings
				Save as text file: ".pcbrc"
			endif

			# .directory$ = chooseDirectory$: "Choose a directory to save the files in"
			if .directory$ <> ""
				for i to .items
					va = .value'i'
					selectObject: extracts'va'
					fileToSave$ = extracts'va'$
					Save as WAV file: "'.directory$'/'fileToSave$'.wav"
				endfor
			endif
		endif

	else
		@warning: 1, "OK", "", "o", "", "Nothing to save.", ""
	endif
	label SAVE_EXTRACTS_CANCEL
endproc


procedure DrawHelpFrame
	help_from_x = 30
	help_to_x = 80
	help_from_y = 15
	help_to_y = 80
	demo Paint rounded rectangle: warningWindowColour$, help_from_x, help_to_x, help_from_y, help_to_y, 1
	demo Draw rounded rectangle: help_from_x, help_to_x, help_from_y, help_to_y, 1
	# Heading
	demo Text special: 33, "left", 75, "half", "Helvetica", 15, "0", "Keyboard shortcuts - 'screen$' Screen"
	demo Text special: 33, "left", 22, "half", "Helvetica", 15, "0", "? - show help"
	demo Text special: 33, "left", 19, "half", "Helvetica", 15, "0", "x - hide help (or click the \xx above)"
	# The "x" for hiding the Help
	demo Text special: help_to_x - 2, "centre", help_to_y - 3, "half", "Helvetica", 20, "0", "\xx"
endproc


procedure CloseHelp
	x_clicked = 0
	while x_clicked = 0 and demoWaitForInput ()
		if demoKey$ () = "x" or demoClickedIn (help_to_x - 3, help_to_x - 1, help_to_y - 4, help_to_y - 2)
			x_clicked = 1
		endif
	endwhile
	@'screen$'Screen
endproc


procedure ShowHelpMain
	@DrawHelpFrame
	demo Text special: 33, "left", 67, "half", "Helvetica", 15, "0", "p - change speaker data)"
	demo Text special: 33, "left", 64, "half", "Helvetica", 15, "0", "t - edit texts"
	demo Text special: 33, "left", 61, "half", "Helvetica", 15, "0", "l - edit Long Sound"
	demo Text special: 33, "left", 58, "half", "Helvetica", 15, "0", "e - edit extracts"
	demo Text special: 33, "left", 55, "half", "Helvetica", 15, "0", "a - edit annoation"
	demo Text special: 33, "left", 52, "half", "Helvetica", 15, "0", "s - save..."
	demo Text special: 33, "left", 49, "half", "Helvetica", 15, "0", "(Only GNU/Linux: Ctrl+r - reset (all data will be lost)"
	demo Text special: 33, "left", 46, "half", "Helvetica", 15, "0", "(Only GNU/Linux: Ctrl+q - quit"
	@CloseHelp
endproc


procedure ShowHelpExtracts
	@DrawHelpFrame
	demo Text special: 33, "left", 67, "half", "Helvetica", 15, "0", "; - play (or click on the sample name)"
	demo Text special: 33, "left", 64, "half", "Helvetica", 15, "0", ": - interrupt playing"
	demo Text special: 33, "left", 61, "half", "Helvetica", 15, "0", "h,j,k,l - move around"
	demo Text special: 33, "left", 58, "half", "Helvetica", 15, "0", "(Only GNU/Linux: Ctrl+h,j,k,l - move around by 5)"
	demo Text special: 33, "left", 55, "half", "Helvetica", 15, "0", "(Only GNU/Linux: Ctrl+Alt+h,j,k,l - move to next by 5 and play"
	demo Text special: 33, "left", 52, "half", "Helvetica", 15, "0", "Shift+h,j,k,l - move to next, View & Edit and play"
	demo Text special: 33, "left", 49, "half", "Helvetica", 15, "0", "d - select one item"
	demo Text special: 33, "left", 46, "half", "Helvetica", 15, "0", "i - invert selection"
	demo Text special: 33, "left", 43, "half", "Helvetica", 15, "0", "u - unselect all"
	demo Text special: 33, "left", 40, "half", "Helvetica", 15, "0", "y - select all"
	demo Text special: 33, "left", 37, "half", "Helvetica", 15, "0", "v - View & Edit (or click on the \O symbol)"
	demo Text special: 33, "left", 34, "half", "Helvetica", 15, "0", "V - Play + View & Edit"
	demo Text special: 33, "left", 31, "half", "Helvetica", 15, "0", "r - refresh the screen"
	@CloseHelp
endproc

procedure ShowHelpTexts
	@DrawHelpFrame
	@CloseHelp
endproc
procedure ShowHelpSound
	@DrawHelpFrame
	@CloseHelp
endproc
procedure ShowHelpAnnotation
	@DrawHelpFrame
	@CloseHelp
endproc

#########################
#### ANNOTATION PROCEDURES
#########################

procedure openAnnotation
	label OPEN_ANNOTATION_AGAIN
	if textGridScreen$ <> "%%Nothing selected.%"
		prevTextGrid$ = textGridScreen$
	endif

	if !reopen and !openWithSound
		textGridPath$ = chooseReadFile$: "Open a TextGrid file"
	endif

	if openWithSound = 1
		openWithSound = 0
	endif

	if textGridPath$ <> ""
		if rindex (textGridPath$, ".TextGrid") = 0
			textGridScreen$ = prevTextGrid$
			@warning: 2, "AGAIN", "CANCEL", "a", "c", "Select a TextGrid file",
			... ""
			goto OPEN_ANNOTATION_'warningOption$'

		else
			if textGridToSave = 1 and textGrid <> 0
				@warning: 2, "IGNORE", "CANCEL", "i", "c", "Unsaved changes",
				... "in existing TextGrid!"
				if warningOption$ = "CANCEL"
					goto OPEN_ANNOTATION_CANCEL
				else
					selectObject: textGrid
					Remove
				endif
			elif textGrid <> 0
				selectObject: textGrid
				Remove
			endif

			if fileReadable (textGridPath$)
				textGrid = Read from file: textGridPath$
				if reopen = 1
					reopened = 1
				endif
				textGrid$ = selected$ ("TextGrid")
				textGridName$ = textGrid$
				textGridToSave = 1
				if reopened
					textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0) + ".TextGrid" + " (reopened)"
				else
					textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0) + ".TextGrid"
				endif
				repaint = 1
			else
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "File not readable!",
				... "Check the path!"
				goto OPEN_ANNOTATION_'warningOption$'
			endif
		endif

		if openWithAnnotation = 1
			.noExt$ = textGridPath$ - ".TextGrid"

			if fileReadable (.noExt$ + ".wav")
				soundPath$ = .noExt$ + ".wav"
				openWithAnnotation = 1
				@openSound
			endif
		endif
		reopen = 0
		@AnnotationScreen
		if reopened = 1
			textGridScreen$ = textGridScreen$ - " (reopened)"
			reopened = 0
		endif
	endif
	label OPEN_ANNOTATION_CANCEL
endproc


procedure pausesAnnotation
	if sound = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Open a sound", "file first."
		if warningOption$ = "OPEN"
			@openSound
		endif
	else
		beginPause: "Marking pauses"
			boolean: "Mark pauses automatically", 1
			comment: "If you choose automatic pause marking a new TextGrid will be created!"
			comment: "Choose tier names of the new TextGrid (separated by spaces):"
			text: "Tier names", tierNames$
			comment: "Silence threshhold of e.g. -35 will detect more regions as voiced than -25"
			real: "Silence threshold (db)", -25
			comment: "Set the minimum silent interval duration (s):"
			real: "Minimum silence", 0.7
			comment: "Set the minimum sounding interval duration (s):"
			real: "Minimum sounding", 0.05
			comment: "Set the minimum margin of silence before the sounding interval (s):"
			real: "Silent margin before", silentMarginBefore
			comment: "Set the minimum margin of silence after the sounding interval (s):"
			real: "Silent margin after", silentMarginAfter
			word: "Silent interval label", silentIL$
			word: "Sounding interval label", ""
			boolean: "Save pauses settings", 0
			clicked = endPause: "Cancel", "Continue", 2, 1

		if clicked = 1
			goto PAUSES_ANNOTATION_CANCEL
		endif

	if save_pauses_settings
		selectObject: settings
		col = Search column: "variable", "tierNames$"
		Set string value: col, "value", """'tier_names$'"""
		tierNames$ = tier_names$
		col = Search column: "variable", "silentMarginBefore"
		Set numeric value: col, "value", silent_margin_before
		silentMarginBefore = silent_margin_before
		col = Search column: "variable", "silentMarginAfter"
		Set numeric value: col, "value", silent_margin_after
		silentMarginAfter = silent_margin_after
		selectObject: settings
		Save as text file: ".pcbrc"
	endif

		if tier_names$ <> "" and index (tier_names$, " ") = 0
			.nTiers = 1
			newTierName1$ = tier_names$
			goto ONE_TIER
		endif

		.nTiers = 0
		tier_names_left$ = tier_names$
		.space = index (tier_names_left$, " ")

		while .space > 0
			.nTiers = .nTiers + 1
			newTierName'.nTiers'$ = left$ (tier_names_left$, .space - 1)
			tier_names_left_length = length (tier_names_left$)
			tier_names_left$ = right$ (tier_names_left$, tier_names_left_length - .space)
			.space = index (tier_names_left$, " ")
			if .space = 0
				.nTiers = .nTiers + 1
				newTierName'.nTiers'$ = tier_names_left$
			endif
		endwhile

		label ONE_TIER
		if textGrid <> 0
			if mark_pauses_automatically = 1
				@warning: 2, "NEW", "CANCEL", "n", "c", "Create new TextGrid",
				... "and delete the existing one?"
				if warningOption$ = "CANCEL"
					goto PAUSES_ANNOTATION_CANCEL
				endif
				selectObject: textGrid
				Remove
				goto CREATE_NEW_TEXTGRID
			else
				selectObject: sound
				plusObject: textGrid
				View & Edit
				editor: "TextGrid 'textGridName$'"
				Move cursor to: 0
				endeditor
			endif

		elif textGrid = 0
			label CREATE_NEW_TEXTGRID
			if mark_pauses_automatically = 1
				normalSound = Read from file: "'soundPath$'"
				intensity = To Intensity: 100, 0, "yes"
				silentIL$ = silent_interval_label$
				soundingIL$ = sounding_interval_label$
				textGrid = To TextGrid (silences): silence_threshold, minimum_silence, minimum_sounding, "'silentIL$'", "'soundingIL$'"
				textGrid$ = "'soundNoExt$'.TextGrid"
				textGridName$ = soundNoExt$
				textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0)
				textGridFolder$ = soundFolder$
				textGridPath$ = textGridFolder$ + textGrid$
				@MainScreen

				# This for cycle moves the interval boundaries to create a
				# "silent_margin": 
				selectObject: textGrid
				.nIntervals = Get number of intervals: 1
				sma = (silent_margin_after + 0.035)
				smb = (silent_margin_before + 0.015)
				for n to .nIntervals
					.intLabel$ = Get label of interval: 1, n
					.intStart = Get starting point: 1, n
					.intEnd = Get end point: 1, n
						if .intLabel$ = silentIL$
							if n > 1
								if .intEnd > (.intStart + sma)
									Set interval text: 1, n, ""
									Insert boundary: 1, (.intStart + sma)
									Remove boundary at time: 1, .intStart
									Set interval text: 1, n, silentIL$
								endif
							endif
							if n < .nIntervals
								if .intStart < (.intEnd - smb)
								Insert boundary: 1, (.intEnd - smb)
								Remove boundary at time: 1, .intEnd
							endif
						endif
					endif
				endfor

				# Create and (re)name the tiers in the TextGrid:
				selectObject: textGrid
				if .nTiers = 1
					Set tier name: 1, newTierName1$
				elif .nTiers > 1
					Set tier name: 1, newTierName1$
					for i from 2 to .nTiers
						Duplicate tier: 1, i, newTierName'i'$
					endfor
				endif

				selectObject: normalSound
				plusObject: intensity
				Remove

				selectObject: sound
				plusObject: textGrid
				View & Edit
				editor: "TextGrid 'textGridName$'"
				Move cursor to: 0
				endeditor
			else
				selectObject: sound
				textGrid = To TextGrid: tier_names$, ""
				textGridToSave = 1
				textGrid$ = "'soundNoExt$'.TextGrid"
				textGridName$ = soundNoExt$
				textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0)
				textGridFolder$ = soundFolder$
				textGridPath$ = textGridFolder$ + textGrid$
				@MainScreen
				plusObject: sound
				View & Edit
				editor: "TextGrid 'textGridName$'"
				Move cursor to: 0
				endeditor
			endif
		endif

		textGridToSave = 1
		label PAUSES_ANNOTATION_CANCEL
	endif
endproc


procedure intervalsAnnotation
# TODO: swap left and right context for search in final position
# clean-up

	label INTERVALS_ANNOTATION_AGAIN

if textGrid = 0
	@warning: 2, "OPEN", "CANCEL", "o", "c", "Open or create", "a textGrid
	... first."
	if warningOption$ = "OPEN"
		@openAnnotation
	endif
else

	beginPause: "Add intervals to tier"
		comment: "Which tier should be searched for items that come in the new intervals?"
		natural: "Source tier", 1
		comment: "In which tier should the new intervals be created?"
		natural: "Target tier", 4
		comment: "What are the items that should receive new intervals?"
		sentence: "Search for", "a|e|i|o|u|y|á|é|í|ó|ú|A|E|I|O|U|Y|Á|É|Í|Ó|Ú" 
		comment: "(The search uses regular expressions. See Praat manual.)"
		comment: "What is the position of the item in the word?"
		optionMenu: "Position", 2
			option: "Anywhere"
			option: "Initial"
			option: "Medial"
			option: "Final"
		comment: "What is the label for empty intervals?"
		word: "Empty", "xxx"
		boolean: "Write labels", 1
		boolean: "Include left context", 1
		boolean: "Include right context", 1
	clicked = endPause: "Cancel", "Continue", 2, 1
	if clicked = 1
		goto INTERVALS_ANNOTATION_CANCEL
	endif

	if textGrid = 0
		goto INTERVALS_ANNOTATION_CANCEL
	endif

	selectObject: textGrid
	.nTiers = Get number of tiers

	# Issue warning message if the source tier does not exist:
	if source_tier > .nTiers
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Source tier 'source_tier'",
		... "does not exist."
		goto INTERVALS_ANNOTATION_'warningOption$'
	endif

	isIntervalTier = Is interval tier: source_tier
	if isIntervalTier <> 1
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "Source tier is not", "an interval
		... tier."
		goto INTERVALS_ANNOTATION_'warningOption$'
	endif

	.totalDur = Get total duration

	if position = 1
		.searchFor$ = "('search_for$')"
	elif position = 2
		.searchFor$ = "(\s|^| „|„|-)" + "('search_for$')"
	elif position = 3
		.searchFor$ = "([^ „])" + "('search_for$')" + "([^ ,.:;!?-])"
	elif position = 4
		@reverse: search_for$, "intervalsAnnotation.searchFor$"
		.searchFor$ = "(\s|^|“|,| ,|\.|\?|!|:|;|-)" + "('.searchFor$')"
	endif

	writeInfoLine: "The string you are looking for in tier 'source_tier' matches at:"

	# The following for-cycle searches the source tier, shows the results and
	# asks for confirmation before creating the new intervals.
	.nIntervals = Get number of intervals: source_tier
	.allNewInt = 0

	for i to .nIntervals
		.label$ = Get label of interval: source_tier, i
		# The following variable is there for reporting in the appendInfoLine:
		.origLabel$ = .label$
		if position = 4
			@reverse: .label$, "intervalsAnnotation.label$"
		endif

		# rindex_regex is used rather than index_regex because replace_regex$
		# below, if used once, replaces the right most match.
		.hit = rindex_regex (.label$, .searchFor$)
		.newInt = 0
		.labelRest$ = .label$

		while .hit > 0
			.newInt = .newInt + 1

			# For initial and final position replacement \3 is used because the
			# .searchFor$ consists of two groupings:
			if position = 1
				.match$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\2", 1)
				.int'i'lab'.newInt'$ = .match$

				.lContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\1", 1)
				if endsWith (.lContext$, " ") = 1
					.lContext$ = .lContext$ - " "
					.lBound$ = " "
				else
					.lBound$ = ""
				endif
				.lContextLength = length (.lContext$)
				.startWord = rindex_regex (.lContext$, " ")
				.lContext$ = right$ (.lContext$, .lContextLength - .startWord)

				.rContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\3", 1)
				if startsWith (.rContext$, " ") = 1
					.rContextLength = length (.rContext$)
					.rContext$ = right$ (.rContext$, .rContextLength - 1)
					.rBound$ = " "
				else
					.rBound$ = ""
				endif
				.endWord = index_regex (.rContext$, "( |$)")
				.rContext$ = left$ (.rContext$, .endWord - 1)

			elif position = 2
				.match$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\3", 1)
				.int'i'lab'.newInt'$ = .match$
				.lBound$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\2", 1)

				.lContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\1", 1)
				if endsWith (.lContext$, " ") = 1
					.lContext$ = .lContext$ - " "
					.lBound$ = " " + .lBound$
				endif
				.lContextLength = length (.lContext$)
				.startWord = rindex_regex (.lContext$, " ")
				.lContext$ = right$ (.lContext$, .lContextLength - .startWord)

				.rContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\4", 1)	
				.rBound$ = ""
				.endWord = index_regex (.rContext$, "(\s|$|“|,|\.|\?|!|:|;)")
				.rContext$ = left$ (.rContext$, .endWord - 1)

			elif position = 3
				.match$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\3", 1)
				.int'i'lab'.newInt'$ = .match$

				.lContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\1\2", 1)
				.lBound$ = ""
				.lContextLength = length (.lContext$)
				.startWord = rindex_regex (.lContext$, " ")
				.lContext$ = right$ (.lContext$, .lContextLength - .startWord)

				.rContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\4\5", 1)	
				.rBound$ = ""
				.endWord = index_regex (.rContext$, "(\s|$|“|,|\.|\?|!|:|;)")
				.rContext$ = left$ (.rContext$, .endWord - 1)

			elif position = 4
				.match$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\3", 1)
				.int'i'lab'.newInt'$ = .match$

				.rContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\1", 1)
				.rBound$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\2", 1)

				.lContext$ = replace_regex$ (.labelRest$, "(.*)" + .searchFor$ + "(.*)", "\4", 1)
				.lBound$ = ""
				.startWord = index_regex (.rContext$, "(\s)")
				.lContext$ = left$ (.rContext$, .startWord - 1)

				if endsWith (.rContext$, " ") = 1
					.rContext$ = .rContext$ - " "
					.rBound$ = " " + .rBound$
				endif
				.rContextLength = length (.rContext$)
				.endWord = rindex_regex (.rContext$, " ")
				.rContext$ = right$ (.rContext$, .rContextLength - .endWord)
			endif

			if include_left_context = 1 and include_right_context = 1 and position <> 4
				.int'i'lab'.newInt'$ = .lContext$ + .lBound$ + .int'i'lab'.newInt'$ + .rBound$ + .rContext$
			elif include_left_context = 1 and include_right_context = 1
				.int'i'lab'.newInt'$ = .rContext$ + .rBound$ + .int'i'lab'.newInt'$ + .lBound$ + .lContext$

			elif include_left_context = 1 and position <> 4
				.int'i'lab'.newInt'$ = .lContext$ + .lBound$ + .int'i'lab'.newInt'$
			elif include_left_context = 1
				.int'i'lab'.newInt'$ = .int'i'lab'.newInt'$ + .lBound$ + .lContext$

			elif include_right_context = 1 and position <> 4
				.int'i'lab'.newInt'$ = .int'i'lab'.newInt'$ + .rBound$ + .rContext$
			elif include_right_context = 1
				.int'i'lab'.newInt'$ = .rContext$ + .rBound$ + .int'i'lab'.newInt'$
			endif

			if position = 4
				.revIntLabel$ = .int'i'lab'.newInt'$
				@reverse: .revIntLabel$, "intervalsAnnotation.revIntLabel$"
				.int'i'lab'.newInt'$ = .revIntLabel$
			endif

			.reportMatch$ = .lContext$ + .lBound$ + "=" + .match$ + "=" + .rBound$ + .rContext$
			if position = 4
				@reverse: .reportMatch$, "intervalsAnnotation.reportMatch$"
			endif
			appendInfoLine: "'.hit'th char ('.reportMatch$') in interval 'i': ""'.origLabel$'""."

			.labelRest$ = left$ (.labelRest$, .hit - 1)
			.hit = rindex_regex (.labelRest$, .searchFor$)
		endwhile

		.newInt'i' = .newInt
		.allNewInt = .allNewInt + .newInt
	endfor

	if write_labels = 1
		@warning: 2, "OK", "CANCEL", "o", "c", "'.allNewInt' intervals will",
		... "be created."

		if warningOption$ = "CANCEL"
			goto INTERVALS_ANNOTATION_CANCEL
		endif
	else
		@warning: 1, "OK", "", "o", "", "There are '.allNewInt' hits",
		... "of your search."
		goto INTERVALS_ANNOTATION_SKIP
	endif

	# Issue warning message if the target tier does not exist:
	if target_tier > .nTiers
		@warning: 2, "INSERT", "CANCEL", "i", "c", "Target tier 'target_tier'",
		... "does not exist."
		if warningOption$ = "CANCEL"
			goto INTERVALS_ANNOTATION_CANCEL
		endif
		target_tier = .nTiers + 1
		Insert interval tier: target_tier, "newTier"
	endif

	# Issue warning message if the target tier is not empty:
	.nOldIntervals = Get number of intervals: target_tier
	if .nOldIntervals > 1
		@warning: 2, "AGAIN", "CANCEL", "a", "c", "The target tier", "is not empty!"
		goto INTERVALS_ANNOTATION_'warningOption$'
	endif

	# The following for-cycle searches the source tier, marks empty intervals
	# with 'xxx' and creates new intervals in the target tier.
	# 'prevEmpty' has to be 0 at the beginning so that a boundary is not
	# inserted at the beginning of the TextGrid
	prevEmpty = 0
	for i to .nIntervals

		.label$ = Get label of interval: source_tier, i
		if position = 4
			@reverse: .label$, "intervalsAnnotation.label$"
		endif

		.start = Get start point: source_tier, i
		.end = Get end point: source_tier, i
		.dur = .end - .start

		.hit = index_regex (.label$, .searchFor$)
		.newInt = 0
		.labelRest$ = .label$

		while .hit > 0
			.newInt = .newInt + 1
			
			.labelRest$ = replace_regex$ (.labelRest$, .searchFor$, "XXX", 1)
			.hit = index_regex (.labelRest$, .searchFor$)
		endwhile

		if .newInt = 0 and prevEmpty = 0
			.nTargIntervals = Get number of intervals: target_tier 
			Set interval text: target_tier, .nTargIntervals, empty$
			prevEmpty = 1
		elif .newInt > 0
			.newStep = .dur / .newInt
			if prevEmpty = 1
				Insert boundary: target_tier, .start
			endif
			for k to (.newInt - 1)
				if write_labels = 1
					# NewLabels are numbered from the end, so reverse the order:
					.reverse = .newInt - k + 1
					.nTargIntervals = Get number of intervals: target_tier 
					Set interval text: target_tier, .nTargIntervals, .int'i'lab'.reverse'$
				endif
				Insert boundary: target_tier, .start + (k * .newStep)
			endfor
			if write_labels = 1
				.nTargIntervals = Get number of intervals: target_tier 
				Set interval text: target_tier, .nTargIntervals, .int'i'lab1$
			endif
			if .end < .totalDur
				Insert boundary: target_tier, .end
			endif
			prevEmpty = 0
		endif
	endfor

	label INTERVALS_ANNOTATION_SKIP
	selectObject: textGrid
	if sound <> 0
		plusObject: sound
		View & Edit
		editor: "TextGrid 'textGridName$'"
		Move cursor to: 0
		endeditor
	else
		View & Edit alone
		editor: "TextGrid 'textGridName$'"
		Move cursor to: 0
		endeditor
	endif

	label INTERVALS_ANNOTATION_CANCEL
endif
# todo: count occurrences of the searched item in the string and cut up the
#	other tier
#    leave auto labelling for later, because it can be done more efficiently by
#    just auto-labelling that currently exists.
# add the possibility to ignore case in the regex search
# REPAIR: label$ replacement!
endproc


procedure labelAnnotation
	label LABEL_ANNOTATION_AGAIN

	if textGrid = 0
		@warning: 2, "OPEN", "CANCEL", "o", "c", "Open or create",
		... "a TextGrid first."
		if warningOption$ = "OPEN"
			@openAnnotation
		endif
	else
		demoShow ()
		choose_labelling_method = 0

		beginPause: "Annotation"
			optionMenu: "Choose labelling method", 1
				option: "Label existing TextGrid manually"
				option: "Label sound automatically"
				option: "Label new TextGrid manually"
				option: "Copy labels from another TextGrid"
			comment: "Choose tier names to (create &) label (separated by spaces):"
			text: "Tier names", tierNames$
			comment: "Do you want to include empty rows from the ""texts"" file?"
			boolean: "Include empty", 0
			comment: "Only use lines in the ""texts"" which have a label in a specific column?"
			boolean: "Use leading column", 1
			word: "Leading column", "code"
			comment: "Do you want to overwrite old labels (including/excluding ''silentIL$'')?"
			optionMenu: "Overwrite old labels", 1
				option: "Overwrite but skip ''silentIL$''"
				option: "Overwrite all intervals"
				option: "Do not overwrite"
			comment: "What is the label that should not be overwritten?"
			word: "Do not overwrite", silentIL$
			comment: "Overwrite repeated items with preceding label + label for repetition?"
			boolean: "Label repeated", 1
			comment: "What is the label for repeated items?"
			word: "Repeated item", "r"
			boolean: "Save annotation settings", 0
		clicked = endPause: "Cancel", "Continue", 2, 1

		if clicked = 1
			goto LABEL_ANNOTATION_CANCEL
		endif

		if save_annotation_settings = 1
			selectObject: settings
			col = Search column: "variable", "tierNames$"
			Set string value: col, "value", """'tier_names$'"""
			selectObject: settings
			Save as text file: ".pcbrc"
		endif

		if choose_labelling_method = 1 and textGrid <> 0
			goto LABEL_EXISTING_MANUALLY
		elif choose_labelling_method = 1
			goto LABEL_FIRST_MANUALLY
		elif choose_labelling_method = 2
			goto LABEL_SOUND_AUTOMATICALLY
		elif choose_labelling_method = 3
			goto LABEL_NEW_MANUALLY
		elif choose_labelling_method = 4
			@relabel
			goto LABEL_EXISTING_MANUALLY
		endif

		label LABEL_SOUND_AUTOMATICALLY
		if texts = 0
			@warning: 2, "OPEN", "CANCEL", "o", "c", "Open a text file first.",
			... ""
			if warningOption$ = "OPEN"
				@openTexts
				goto LABEL_SOUND_AUTOMATICALLY
			endif
			goto LABEL_ANNOTATION_CANCEL
		endif

		if textGrid = 0
			@warning: 2, "OPEN", "CANCEL", "o", "c", "Open or create",
			... "a TextGrid first."
			if warningOption$ = "OPEN"
				@openAnnotation
				goto LABEL_SOUND_AUTOMATICALLY
			endif
			goto LABEL_ANNOTATION_CANCEL
		elif textGrid <> 0 
			@warning: 2, "OVERWRITE", "CANCEL", "o", "c", "Overwrite existing",
			... "labels?"
			if warningOption$ = "OVERWRITE"
				goto OVERWRITE_A
			endif
			goto LABEL_EXISTING_MANUALLY
		endif

		label LABEL_NEW_MANUALLY
		if textGrid <> 0
			selectObject: textGrid
			Remove
		endif

		label LABEL_FIRST_MANUALLY

		if sound = 0
			@warning: 2, "OPEN", "CREATE", "o", "c", "Open a sound or create",
			... "independent textGrid."
			if warningOption$ = "OPEN"
				@openSound
			else
				beginPause: "Create new textGrid"
					real: "Start time (s)", 0.0
					real: "End time (s)", 1.0
					comment: "Choose the name of the TextGrid:"
					word: "TextGrid name", "default"
					comment: "For auto-labelling open/create a TextGrid with intervals and a"
					comment: "corresponding ""text(s)"" file with labels."
				clicked = endPause: "Cancel", "Continue", 2, 1
				if clicked = 1
					goto LABEL_ANNOTATION_CANCEL
				endif
				textGrid = Create TextGrid: start_time, end_time, tier_names$, ""
				textGrid$ = "'textgrid_name$'.TextGrid"
				textGridName$ = textgrid_name$
				goto TEXTGRID_WITHOUT_SOUND
			endif
		endif

		selectObject: sound
		textGrid = To TextGrid: tier_names$, ""
		textGrid$ = "'soundNoExt$'.TextGrid"
		textGridName$ = soundNoExt$

		label TEXTGRID_WITHOUT_SOUND

		textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0)
		textGridFolder$ = soundFolder$
		textGridPath$ = textGridFolder$ + textGrid$
		@AnnotationScreen
		if choose_labelling_method = 1 or choose_labelling_method = 3
			goto LABEL_EXISTING_MANUALLY
		endif

		### Automatic labelling
		label OVERWRITE_A

		selectObject: textGrid
		.nTiers = Get number of tiers
		for .j to .nTiers
			existingTier'.j'$ = Get tier name: .j
			numberOfIntervals'.j' = Get number of intervals: .j
		endfor

		# The @textToStrings proc produces '.strings' - the number of tiers that
		# are supposed to be labelled, and .string'N'$ - the individual tier
		# names.
		.label$ = "CONTINUE"
		@textToStrings: "labelAnnotation", tier_names$ 

		# If the .label$ variable does not get its value in the @textToStrings
		# procedure, it has the default value "CONTINUE"
		goto LABEL_ANNOTATION_'.label$'
		label LABEL_ANNOTATION_CONTINUE

		# Check whether the tiers specified in the form exist in the TextGrid
		# and associate the number (.tierToLabel'.s') of the tier with the name:
		for .s to .strings
			.tierExists'.s' = 0
			.tier$ = .string'.s'$
			for .j to .nTiers
				if .tier$ = existingTier'.j'$
					.tierExists'.s' = 1	
					.tierToLabel'.s' = .j
				endif
			endfor
			if .tierExists'.s' = 0
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "Tier ""'.tier$'""
				... does not", "exist in the TextGrid!"
				goto LABEL_ANNOTATION_'warningOption$'
			endif
		endfor

		# Check whether there are the columns with labels in the texts file:
		selectObject: texts
		.textRows = Get number of rows
		.textColumns = Get number of columns
		for .j to .textColumns
			.columnLabel'.j'$ = Get column label: .j
		endfor

		for .s to .strings
			.columnExists'.s' = 0
			.column$ = .string'.s'$
			for .j to .textColumns
				if .column$ = .columnLabel'.j'$
					.columnExists'.s' = 1	
				endif
			endfor
			if .columnExists'.s' = 0
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "Column ""'.column$'"" does not",
				... "exist in the texts file!"
				goto LABEL_ANNOTATION_'warningOption$'
			endif
		endfor

		# If a leading column is chosen, check whether it exists, and find out what
		# is the corresponding tier and which rows in the "texts" should be used:
		if use_leading_column = 1
			.leading_column = 0
			for .j to .nTiers
				if leading_column$ = existingTier'.j'$
					.leading_column = .j
				endif
			endfor

			if .leading_column = 0
				@warning: 2, "AGAIN", "CANCEL", "a", "c", "Leading column
				... ""'.column$'"" has no", "corresponding tier in TextGrid!"
				goto LABEL_ANNOTATION_'warningOption$'
			endif

			selectObject: texts
			# Count the total number (.nLabels) and remember the position
			# (.rwl'.nLabels') of rows which have a label in the leading column:
			.nLabels = 0
			for .tr to .textRows
				.label$ = Get value: .tr, leading_column$
				if .label$ <> ""
					.nLabels = .nLabels + 1
					.rwl'.nLabels' = .tr
				endif
			.leadColLabels = .nLabels
			endfor
		endif

		# Get all the labels for items in the text file, do it for each tier
		# individually:
		for .s to .strings
			selectObject: texts
			.tierToLabel = .tierToLabel'.s'
			.column$ = .string'.s'$

			# If the leading column is used, only get the labels from specific rows:
			# .rwl'.tr' are the rows which have a label in the leading column:
			if use_leading_column = 1
				for .tr to .nLabels
					label$ = Get value: .rwl'.tr', .column$
					label_'.column$'_'.tr'$ = label$
				endfor

			# If no leading column is used, get the labels for each column
			# individually:
			else
				.nLabels = 0
				for .tr to .textRows
					label$ = Get value: .tr, .column$
					if label$ <> "" or include_empty = 1
						.nLabels = .nLabels + 1
						label_'.column$'_'.nLabels'$ = label$
					endif
				endfor
			endif
			.nLabels'.s' = .nLabels

			# Compare the number of empty intervals (or those that should be
			# overwritten) in the tiers with the number of labels in the text file
			# and report if they mismatch:
			if (use_leading_column = 1 and .column$ = leading_column$) or use_leading_column = 0

				selectObject: textGrid
				if overwrite_old_labels = 1
					noLabel = Count labels: .tierToLabel, silentIL$
					empty = numberOfIntervals'.tierToLabel' - noLabel
				elif overwrite_old_labels = 2
					empty = numberOfIntervals'.tierToLabel'
				elif overwrite_old_labels = 3
					empty = Count labels: .tierToLabel, ""
				endif

				if .nLabels > empty
					excessCodes = .nLabels - empty
					if excessCodes = 1
						labelsPlSg$ = "label"
					else
						labelsPlSg$ = "labels"
					endif
					@warning: 2, "IGNORE", "CANCEL", "i", "c", "'excessCodes' more
					... 'labelsPlSg$' than empty", "intervals in tier ""'.column$'""!"
					if warningOption$ = "CANCEL"
						goto LABEL_ANNOTATION_CANCEL
					endif
				endif
			endif
		endfor

		# If leading column is used, goto the appropriate section of the script,
		# else annotate each tier individually:
		if use_leading_column = 1
			goto LEADING_COLUMN
		endif

		for .s to .strings
			.tierToLabel = .tierToLabel'.s'
			.column$ = .string'.s'$
			repeated = 0
			emptyInterval = 0
			leftEmpty = 0
			prevOldLabel$ = ""

			# For int from starting_interval to numberOfIntervals
			for int to numberOfIntervals'.tierToLabel'
				selectObject: textGrid
				oldLabel$ = Get label of interval: .tierToLabel, int

				# Skip intervals with 'xxx'; or any non-empty intervals if overwrite
				# is disabled:
				if (index (oldLabel$, do_not_overwrite$) <> 0 and overwrite_old_labels = 1) or (oldLabel$ <> "" and overwrite_old_labels = 3)
					goto DONT_OVERWRITE

				# Items that are repeated several times in a row and are
				# marked with "repeated_item$" in the annotation, get
				# the label of the preceding nonrepeated item:
				elif overwrite_old_labels <> 2 and label_repeated = 1
				... and (index (oldLabel$, "_'repeated_item$'") <> 0 or oldLabel$ =
				... repeated_item$)
				... and (index (prevOldLabel$, "_'repeated_item$'") <> 0 or
				... prevOldLabel$ = repeated_item$)
					label NEW_REPEATED_ITEM
					if emptyInterval > .nLabels'.s'
						leftEmpty = leftEmpty + 1
						goto DONT_OVERWRITE
					endif
					repeated = repeated + 1
					Set interval text: .tierToLabel, int, label_'.column$'_'emptyInterval'$ + "_'repeated_item$''repeated'"
					
					prevOldLabel$ = oldLabel$

				# This 'elif' resets the "repeated" variable:
				elif overwrite_old_labels <> 2 and label_repeated = 1
				... and (index (oldLabel$, "_'repeated_item$'") <> 0 or oldLabel$ =
				... repeated_item$)
				... and index (prevOldLabel$, repeated_item$) = 0
					repeated = 0
					goto NEW_REPEATED_ITEM

				# Empty intervals get a label from the 'texts' file:
				else
					emptyInterval = emptyInterval + 1
					if emptyInterval > .nLabels'.s'
						leftEmpty = leftEmpty + 1
						goto DONT_OVERWRITE
					endif
					Set interval text: .tierToLabel, int, label_'.column$'_'emptyInterval'$
					prevOldLabel$ = oldLabel$
				endif
				label DONT_OVERWRITE
			endfor

			# Report intervals which have not been labelled.
			# This can mean that the "texts" file or the pause labelling is
			# incorrect!
			if leftEmpty > 0
				@warning: 1, "OK", "", "o", "",
				... "'leftEmpty' empty intervals in tier ""'.column$'""",
				... "Check the transcription!"
			endif
		endfor
		goto LABEL_EXISTING_MANUALLY

		label LEADING_COLUMN

		# If the leading column is used, all tiers are labelled according to the
		# one which corresponds to the leading clumn.
		# This only works, if all tiers have the same number of equally aligned
		# intervals!
		.tierToLabel = .leading_column
		repeated = 0
		emptyInterval = 0
		leftEmpty = 0
		prevOldLabel$ = ""

		# Go through all the intervals in the "leading tier":
		for int to numberOfIntervals'.tierToLabel'
			selectObject: textGrid
			oldLabel$ = Get label of interval: .tierToLabel, int

			# Skip intervals with 'xxx'; or any non-empty intervals if overwrite
			# is disabled:
			if (index (oldLabel$, do_not_overwrite$) <> 0 and overwrite_old_labels = 1)
			... or (oldLabel$ <> "" and overwrite_old_labels = 3)
				goto DONT_OVERWRITE_LC

			# Items that are repeated several times in a row and are
			# marked with "repeated_item$" in the annotation, get
			# the label of the preceding nonrepeated item:
			elif overwrite_old_labels <> 2 and label_repeated = 1
			... and (index (oldLabel$, "_'repeated_item$'") <> 0 or oldLabel$ =
			... repeated_item$)
			... and (index (prevOldLabel$, "_'repeated_item$'") <> 0 or
			... prevOldLabel$ = repeated_item$)
				label NEW_REPEATED_ITEM_LC
				if emptyInterval > .leadColLabels
					leftEmpty = leftEmpty + 1
					goto DONT_OVERWRITE_LC
				endif
				repeated = repeated + 1
				Set interval text: .tierToLabel, int, label_'leading_column$'_'emptyInterval'$ + "_'repeated_item$''repeated'"
				prevOldLabel$ = oldLabel$

				# The text from the remaining tiers gets erased:
				for .s to .strings
					if .string'.s'$ <> leading_column$
						.column$ = .string'.s'$
						.remainingTier = .tierToLabel'.s'
						Set interval text: .remainingTier, int, label_'.column$'_'emptyInterval'$
					endif
				endfor

			# This 'elif' resets the "repeated" variable:
			elif overwrite_old_labels <> 2 and label_repeated = 1
			... and (index (oldLabel$, "_'repeated_item$'") <> 0 or oldLabel$ =
			... repeated_item$)
			... and index (prevOldLabel$, repeated_item$) = 0
				repeated = 0
				goto NEW_REPEATED_ITEM_LC

			# Empty intervals on the tier corresponding to the leading column
			# get a label from the 'texts' file:
			else
				emptyInterval = emptyInterval + 1
				if emptyInterval > .leadColLabels
					leftEmpty = leftEmpty + 1
					goto DONT_OVERWRITE_LC
				endif
				Set interval text: .tierToLabel, int, label_'leading_column$'_'emptyInterval'$
				prevOldLabel$ = oldLabel$

				# The remaining tiers are labelled:
				for .s to .strings
					if .string'.s'$ <> leading_column$
						.column$ = .string'.s'$
						.remainingTier = .tierToLabel'.s'
						Set interval text: .remainingTier, int, label_'.column$'_'emptyInterval'$
					endif
				endfor

			endif
			label DONT_OVERWRITE_LC

		endfor

		# Report intervals which have not been labelled.
		# This can mean that the "texts" file or the pause labelling is
		# incorrect!
		if leftEmpty > 0
			@warning: 1, "OK", "", "o", "",
			... "'leftEmpty' empty intervals in tier ""'leading_column$'""",
			... "Check the transcription!"
		endif

		# This part selects the TextGrid (and the sound) for Viewing & Editing:
		label LABEL_EXISTING_MANUALLY
		if sound <> 0
			selectObject: textGrid
			textGrid$ = selected$ ("TextGrid")
			textGridName$ = textGrid$
			textGridScreen$ = replace$ (textGrid$, "_", "\_ ", 0) + ".TextGrid"
			@AnnotationScreen
			selectObject: sound
			plusObject: textGrid
			View & Edit
			editor: "TextGrid 'textGridName$'"
			Move cursor to: 0
			endeditor
		else
			selectObject: textGrid
			View & Edit alone
			editor: "TextGrid 'textGridName$'"
			Move cursor to: 0
			endeditor
		endif

		textGridToSave = 1
	endif
	label LABEL_ANNOTATION_CANCEL
endproc


procedure relabel
	label RELABEL_AGAIN

	.oldTextGridPath$ = chooseReadFile$: "Open a TextGrid file"
	if .oldTextGridPath$ <> ""
		if fileReadable (.oldTextGridPath$)
			# This is empty so that the script proceeds normally if the file
			# exists and is readable.
		else
			@warning: 2, "AGAIN", "CANCEL", "a", "c", "File not readable!",
			... "Check the path!"
			goto RELABEL_'warningOption$'
		endif

		if rindex (.oldTextGridPath$, ".TextGrid") = 0
			@warning: 2, "AGAIN", "CANCEL", "a", "c", "Select a .TextGrid file",
			... ""
			goto RELABEL_'warningOption$'
		else
			.oldTextGrid = Read from file: .oldTextGridPath$
		endif


		if textGridToSave = 1
			@warning: 2, "IGNORE", "CANCEL", "i", "c", "Unsaved changes",
			... "in existing TextGrid!"
			if warningOption$ = "CANCEL"
				goto RELABEL_CANCEL
			endif

			selectObject: .oldTextGrid
			.oldTiers = Get number of tiers
			.oldInts = Get number of intervals: 1
			selectObject: textGrid
			.newTiers = Get number of tiers
			.newInts = Get number of intervals: 1

			if .oldInts <> .newInts
				@warning: 2, "IGNORE", "CANCEL", "i", "c",
				... "Numbers of intervals", "in tier 1 do not match!"
				goto RELABEL_'warningOption$'
			endif

			if .oldTiers <> .newTiers
				@warning: 2, "IGNORE", "CANCEL", "i", "c",
				... "Numbers of tiers", "do not match!"
				goto RELABEL_'warningOption$'
			endif

			label RELABEL_IGNORE
			for .t to .newTiers
				if .t > .oldTiers
					goto RELABEL_FINISH
				endif
				for .i to .newInts
					if .i > .oldInts
						goto RELABEL_NEXT_TIER
					endif
					selectObject: .oldTextGrid
					.code$ = Get label of interval: .t, .i
					selectObject: textGrid
					Set interval text: .t, .i, .code$
				endfor

				label RELABEL_NEXT_TIER
			endfor

			label RELABEL_FINISH
		endif
	endif
	selectObject: .oldTextGrid
	Remove
	label RELABEL_CANCEL
endproc


############################################################
### Procedures for the right side of the annotation screen
############################################################

label FINISHED

#########
# TODO
#########

# extracted - speakerCode$
# when extracting sounds - insert speakerCode$: warn if there is no speakerCode$

# enable: more than one speaker

# overview of files: show the real updated situation

# Lame - allow the user to change the location of it
# saving procedures: e.g. saving texts - suggest fileName$ automatically while
# saving extracts - don't crash when the file has been removed!
#                 - ask for confirmation when overwriting existing files

	# sampling rate and bit rate?

# Modification of "texts"
# • remove multiple lines (use @textToNumbers)
# • add to/remove from all labels;
# • add lines from TextGrid.
# • when opening texts protect from crashing when "Line incomplete"

##############
# annotation:
##############

# button for scaling textgrid and sound
# buttons for textgrid manipulation

# Introductory note: scripts works with data in "Praat Objects" - save changed
# files, think twice before saving/replacing!

# LongSound files vs normal Sound files

# Open extractions: individual files x all files in a folder

# Automatic annotation
	# move interval boundariers to zero crossings?
	# allow point tiers?

##########
# REPAIR:
##########

# when interrupting "Load textgrid" after the new file has been chosen, the new
# path is remembered and suggested for textgrid saving
# similarly when having an existing textgrid and creating a new one by "mark
# puases", after interrupting the creation of the new textgrid the path to the
# old is forgotten

# when interrupting "Load textgrid + sound" the sound is "reloaded" instead of
# loading a new sound when selecting "Open long sound"

# get rid of the confusion with textGrid$, textGridScreen$ and textGridScreen$

# procedure relabel - replace code$ with label$...

# 199 more codes than empty.....

# Opening files: find out if fileReadable for all opening procedures!
# Open TextGrid along with the sound of the same name

# script crashes after cancelled listen to... extract

# unsaved changes in textgrid - "ignore" does not ignore

# protect from crashing after files in the Object list have been deleted

########
# DONE
########

# choose tier to annotate: code, orth,... - make it universal - June 2015
# add intervals to a tier according to search results in another tier
