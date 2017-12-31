/'
	Defines all text processing and formatting objects and functions.
	
	*** Notes ***
		
	- This version of text_format is case INSENSATIVE.
	- If multiple characters have been inputted as a guess, only the first character is chosen.
'/

Dim Shared word As String       		' Word chosen for Hangman.
Dim Shared reveal_word As String		' Revealed letters of the chosen word based on correct letter guesses.
Dim Shared letter As String			' Current letter chosen by player to see if it's in word.
Dim Shared prev_letters As String	' String of previously chosen letters.

Dim Shared low_range(1 To 2) As Integer = {97, 122}	' ASCII decimal ranges for lowercase letters.

/'
	Initializes reveal_word.
	All alphabetic string characters in word are replaced with `_' in reveal_word.
	All non-alphabetic string characters are kept in `reveal_word' (e.g. numbers, spaces, underscores).
	Characters are checked by converting them into lower-case and comparing them to their ASCII values.
	
	*** Note: This version of InitRevealWord is case-insensitive. ***
'/
Sub InitRevealWord()
	Dim word_char As String					' Current character of word.
	Dim low_word_char_ascii As Integer	' ASCII value of lower-case version of word_char.
	
	reveal_word = ""
 	
	For char As Integer = 1 To Len(word)
		word_char = Chr(word[char-1]) ' Mid(word,char,1)
		low_word_char_ascii = Asc(LCase(word_char))

		If low_word_char_ascii >= low_range(1) And low_word_char_ascii <= low_range(2) Then
			reveal_word = reveal_word + "_"		' Letters are left blank
		Else
			reveal_word += word_char ' Non-letters are filled in with appropriate case.
		EndIf
	Next
	
End Sub

/'
	Checks the first character of letter and returns one of three values:
		- if the letter is an empty string, an empty string is returned;
		- if it's an alphabetical character, it's lower-case version is returned;
		- if it's a non-alphabetical character, a question mark is returned.
'/
Function CleanLetter() As String
	Dim char As String
	Dim char_ascii As Integer
	
	If Len(letter) = 0 Then
		char = ""
	ElseIf Len(letter) <> 0 Then
		char = Chr(letter[0]) 'LCase(Mid(letter,1,1))
		char_ascii = Asc(LCase(char))
		
		If char_ascii < low_range(1) Or char_ascii > low_range(2) Then
			char = "?"
		EndIf
		
	EndIf
	
	Return char
End Function

/'
	Determines if letter has previously been chosen.
'/

Function CheckPrevLetters() As Integer
	Dim prev_choice As Integer
	
	If prev_letters = "" Then
		prev_choice = 0
	Else
		For n As Integer = 1 To Len(prev_letters)
			If LCase(Chr(letter[0])) = LCase(Chr(prev_letters[n-1])) Then 'LCase(Mid(prev_letters,n,1)) Then
				prev_choice = 1
			EndIf
		Next
	EndIf
	
	Return prev_choice
End Function

/'
	Determines if letter is in word. If it is, update reveal_word and return 0. Otherwise, return 1.
'/
Function UpdateRevealWord() As Integer
	Dim updated As Integer = 0
	Dim succ_fail As Integer = 1
	Dim word_char As String
	Dim word_len As Integer = Len(word)
	
	For char As Integer = 1 To word_len
		word_char = Chr(word[char-1]) 'Mid(word,char,1)
		If letter = LCase(word_char) Then
			If char = 1 Then
				' Replace first character.
				reveal_word[char-1] = word_char[0] 'reveal_word = word_char + Mid(reveal_word,2,word_len)
			ElseIf char <> word_len Then
				' Replace central character
				reveal_word[char-1] = word_char[0] 'reveal_word = Mid(reveal_word,1,char-1) + word_char + Mid(reveal_word,char+1,word_len)
			Else
				' Replace final character
				reveal_word[char-1] = word_char[0] 'reveal_word = Mid(reveal_word,1,word_len-1) + word_char 
			EndIf
			
			updated += 1
		EndIf
	Next
	
	
	If updated > 0 Then
		succ_fail = 0
	EndIf
	
	Return succ_fail

End Function

/'
	Determine if all the letters have been correctly guessed. Return 0 if yes, the number of missing letters if no.
'/
Function CheckIfWinGame() As Integer
	Dim is_winner as Integer
	
	If LCase(reveal_word) = LCase(word) Then
		is_winner = 0
	Else
		is_winner = 1
	End If

	Return is_winner

End Function

/'
	Returns a pretty version of a string, where a space is added between every character to improve readability.
'/
Function PrettyString(s As String) As String
	Dim pretty_s As String = ""
	Dim len_s As Integer = Len(s)
		For char As Integer = 1 To len_s
			pretty_s += Chr(s[char-1]) 'Mid(s, char, 1)
			
			If char < len_s Then
				pretty_s += " "
			EndIf
			
		Next
					
	Return pretty_s
End Function