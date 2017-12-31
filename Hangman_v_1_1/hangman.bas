/'
	Things to do:
		- spread out try_again block over labels to clean up code
'/

#Include "dictionary.bi"
#Include "picture.bi"
#Include "linguist.bi"

Const version As String = "1.1"	' Program version.
Const author As String = "M. A. Roosenmaallen"

Dim good_bad_guess As Integer		' Is the guessed letter in the word? 0/1
Dim repeat_letter As Integer		' Was the guessed letter previously chosen? 0/1
Dim play_again As String			' Play another game? y/n
Dim won_game As Integer				' Did you win the game with a succeful guess? 0/1

Dim response As String				' Game response after submitting an answer.

Dim seed As Double = 1.00 			' Seed value for random number generator


' Print program greeting.
Print "Welcome to Hangman version " + version + ", created by " + author + "."
Print "If more than one character is typed in, the first character will be chosen."
Print "To end the program, press Enter when prompted for a letter - do not type in a letter."

' Start new game.
new_game:
	Randomize 'seed
	
	' Choose next word, initialize reveal_word, and prev_letters.
	dict_index = Int(Rnd*dict_length) + 1
	word = dict(dict_index)
	InitRevealWord
	prev_letters = ""
	response = ""

	cur_frame = 1	' Set picture image to first frame
	Print "Starting new game. Please wait."

	Sleep 750

' Update game. Print picture, reveal_word, prev_word, and query for letter input.
Do
	Print
	DrawPicture(cur_frame, picture())
	Print PrettyString(reveal_word)
	Print "Letters Previously Chosen: " + PrettyString(prev_letters)
	
	try_again:

		Sleep 200
		Print response
		Input "Choose a letter: ", letter

		letter = CleanLetter

		If letter = "" Then				' Empty string. End program.
			GoTo end_prog
		ElseIf letter = "?" Then		' Not an alphabetic character. Prompty again.
			response = "That is not a letter. Try again."
			GoTo try_again
		Else									' Alphabetic letter. Check if letter was prev chosen.
			repeat_letter  = CheckPrevLetters
			If repeat_letter <> 0 Then	' Letter prev chosen. Prompt again.
				response = "You've already tried that letter. Pick another one."
				GoTo try_again
			EndIf
			
			prev_letters += letter		' Letter not prev chosen. Add letter to list of prev ones.
			good_bad_guess = UpdateRevealWord
		EndIf
		
		If good_bad_guess = 0 Then	' Correct guess. Check if word fully revealed.
			won_game = CheckIfWinGame
			If won_game = 0 Then
				GoTo you_win
			Else
				Cls
				response =  "Huzzah! Good guess. How about another?"
			EndIf
		Else									' Incorrect guess. Check if game is over.
			cur_frame += 1
			If cur_frame = num_frames Then
				GoTo you_lose
			Else
				Cls
				response = "Oh nose! That letter doesn't exist. How about another?"
			End If
		End If
Loop

you_win:
	Cls
	DrawPicture(cur_frame, picture())
	Print PrettyString(reveal_word)
	Print "Letters Previously Chosen: " + PrettyString(prev_letters)
	Print
	Print "Congratulations, you win!"
	Input "Would you like to play again? (Y)es or (N)o: ", play_again
		If LCase(Chr(play_again[0])) = "y" Then
			Cls
			GoTo new_game
		Else
			Cls
			GoTo end_prog
		End If

you_lose:
	Cls
	DrawPicture(cur_frame, picture())
	Print PrettyString(reveal_word)
	Print "Letters Previously Chosen: " + PrettyString(prev_letters)
	Print
	Print "Well... that didn't go according to plan. I bet we'll do better next time."
	Input "Shall we have another go of it? (Y)es or (N)o: ", play_again
		If LCase(Chr(play_again[0])) = "y" Then
			GoTo new_game
		Else
			GoTo end_prog
		End If

end_prog:
 	Print "Thank you for playing! Press any key to exit."
 	
Sleep