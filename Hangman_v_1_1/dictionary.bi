/'
	The set of all words that can be chosen for a game of Hangman.
	*** Note ***
		Words can be of any length or may be entire sentences. They may contain any ASCII character EXCEPT underscores.
'/

Dim dict(1 To 21) As String = _
	{"Bareheaded", "churchwoman", "nonextractible", "harmlessly", "supercharging", "steadier", "obituaries",_
	 "proctology", "imagine", "disquietingly", "redealt," "lifeblood", "overdiluted", "monotonal",_
	 "strangest", "glimmering", "covariance", "violate", "intermediately", "parallelizing", "annexation"}

Dim dict_length As Integer = UBound(dict) - LBound(dict) + 1

Dim dict_index As Integer		' Index number for word in dict