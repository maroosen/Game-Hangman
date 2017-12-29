/'
	Things to do:
		- Clear screen after each attempt and re-draw
		- prompt when same letter is chosen twice
		- spread out try_again block over labels to clean up code
		- slow down game
		- make man animated
		- figure out how to make see work
'/




#Include "dictionary.bi"
#Include "picture.bi"
#Include "linguist.bi"

Const version As String = "1.0"	' Program version.
Const author As String = "M. A. Roosenmaallen"

Dim good_bad_guess As Integer
Dim play_again As String
Dim won_game As Integer

Dim seed As Double = 1.00 			' Seed value for random number generator


' Print program greeting.
Print "Welcome to Hangman version " + version + ", created by " + author + "."
Print "If more than one character is typed in, the first character will be chosen."
Print "To end the program, press Enter when prompted for a letter - do not type in a letter."

' Start new game.
new_game:
	Randomize
	
	' Choose next word and initialize word and reveal_word.
	dict_index = Int(Rnd*dict_length) + 1
	InitWord(dict(dict_index), word())
	InitRevealWord word(), reveal_word(), low_range()

	cur_frame = 1	' How many incorrect guesses have been made, determining which frame of the picture to print.
	Print "Starting new game. Please wait."

	Sleep 500

' Update game. Print picture, reveal_word, and querry for letter input.
Do
	DrawPicture(cur_frame, picture())
	PrettyPrintReveal(reveal_word())

	try_again:
		Print
		Input "Choose a letter: ", letter

		letter = CheckLetter(letter, low_range())

		If letter = "" then
			GoTo end_prog
		ElseIf letter = "?" Then
			Print "That is not a letter. Try again."
			GoTo try_again
		Else
			good_bad_guess = UpdateRevealWord(letter, word(), reveal_word())
		End If
		
		If good_bad_guess = 0 Then	' Correct guess. Check if word fully revealed.
			won_game = CheckIfWinGame(word(), reveal_word())
			If won_game = 0 Then
				GoTo you_win
			Else
				Print "Huzzah! Good guess. How about another?"
			EndIf
		Else									' Incorrect guess. Check if game is over.
			cur_frame += 1
			If cur_frame = num_frames Then
				GoTo you_lose
			Else
				Print "Oh nose! That letter doesn't exist. How about another?"
			End If
		End If
Loop

you_win:
	Print "Congratulations, you win!"
	Input "Would you like to play again? (Y)es or (N)o: ", play_again
		If LCase(Mid(play_again,1,1)) = "y" Then
			GoTo new_game
		Else
			GoTo end_prog
		End If

you_lose:
	Print "Well... that didn't go according to plan. I bet we'll do better next time."
	Input "Shall we have another go of it? (Y)es or (N)o: ", play_again
		If LCase(Mid(play_again,1,1)) = "y" Then
			GoTo new_game
		Else
			GoTo end_prog
		End If

end_prog:
 	Print "Thank you for playing! Press any key to exit."
 	
Sleep