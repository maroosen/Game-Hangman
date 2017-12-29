/'
	Defines all text processing and formatting objects and functions.
	
	*** Notes ***
		
	- This version of text_format is case INSENSATIVE.
	- If multiple characters have been inputted as a guess, only the first character is chosen.
'/

Dim word(Any) As String       	' Word chosen for Hangman, to be stored as an array of string characters.
Dim reveal_word(Any) As String	' Revealed letters of the chosen word based on correct letter guesses, as an array.
Dim letter As String					' Current letter chosen by player to see if it's in word.

Dim low_range(1 To 2) As Integer = {97, 122}	' ASCII decimal ranges for lowercase letters.


/'
	Initializes word by converting w into an array
'/
Sub InitWord(dict_word As String, word() As String)
	ReDim word(1 To Len(dict_word)) As String

	For char As Integer = LBound(word) To UBound(word)
		word(char) = Mid(dict_word,char,1)
	Next
End Sub


/'
	Initializes reveal_word.
	All alphabetic string characters in word are replaced with `_' in reveal_word.
	All non-alphabetic string characters are kept in `reveal_word' (e.g. numbers, spaces, underscores).
	Characters are checked by converting them into lower-case and comparing them to their ASCII values.
	
	*** Note: This version of InitRevealWord is case-insensitive. ***
'/
Sub InitRevealWord(word() As String, reveal_word() As String, low_range() As Integer)
	Dim low_word_char As String		' Lower-case version of a string character in word.
	Dim low_word_char_ascii As Integer	' ASCII value of low_word_char.
	ReDim reveal_word(LBound(word) To UBound(word)) As String
	
	For char As Integer = LBound(word) To UBound(word)
		low_word_char = LCase(word(char))
		low_word_char_ascii = Asc(low_word_char)
		
		If low_word_char_ascii >= low_range(1) And low_word_char_ascii <= low_range(2) Then
			reveal_word(char) = "_"		' Letters are left blank
		Else
			reveal_word(char) = word(char) ' Non-letters are filled in with appropriate case.
		EndIf
	Next
	
End Sub

/'
	Checks the first character of letter and returns one of three values:
		- if the letter is an empty string, an empty string is returned;
		- if it's an alphabetical character, it's lower-case version is returned;
		- if it's a non-alphabetical character, a question mark is returned.
'/
Function CheckLetter(letter As String, low_range() As Integer) As String
	Dim char As String
	Dim char_ascii As Integer
	
	If Len(letter) = 0 Then
		char = ""
	ElseIf Len(letter) <> 0 Then
		char = LCase(Mid(letter,1,1))
		char_ascii = Asc(char)
	
		If char_ascii < low_range(1) Or char_ascii > low_range(2) Then
			char = "?"
		EndIf
		
	EndIf
	
	Return char
End Function


/'
	Determines if letter is in word. If it is, update reveal_word and return 0. Otherwise, return 1.
'/
Function UpdateRevealWord(letter As String, word() As String, reveal_word() As String) As Integer
	Dim updated As Integer = 0
	Dim succ_fail As Integer = 1
	
	For char As Integer = LBound(word) To UBound(word)
		If letter = LCase(word(char)) Then
			reveal_word(char) = word(char)	' Ensures proper character case is used.
			updated += 1
		EndIf
	Next
	
	
	If updated > 0 Then
		succ_fail = 0
	EndIf
	
	Return succ_fail

End Function

/' Determine if all the letters have been correctly guessed. Return 0 if yes, the number of missing letters if no.
'/
Function CheckIfWinGame(word() As String, reveal_word() As String) As integer
	Dim is_winner as Integer = 0
	
	For char As Integer = LBound(word) To UBound(word)
		If reveal_word(char) <> word(char) Then
			is_winner += 1
		EndIf
	Next

	Return is_winner

End Function

/'
	Prints a pretty version of reveal_word as a string.
	*** Note ***
			This version simply adds a space between each letter to break up underscores.
			Without it, missing letters (i.e. `_') blend together and form a single underline.
'/
Sub PrettyPrintReveal(reveal_word() As String)
	Dim pretty_reveal As String = ""
	
	For char As Integer = LBound(reveal_word) To UBound(reveal_word)
		pretty_reveal += reveal_word(char)
		
		If char < UBound(reveal_word) Then
			pretty_reveal += " "
		EndIf
	Next
	
	Print pretty_reveal
End Sub