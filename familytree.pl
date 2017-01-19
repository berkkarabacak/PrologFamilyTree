/*Eren Ulas 150114822
  Berk Karabacak 150114823
*/

:- dynamic module(familytree,[]).
	/*person(name,lastName,gender,birthDate,fatherName,motherName,deathDate,maritalStat,PartnerName).*/
	/* Family members to be added, here is an example */
	addPerson:- assert(person(osman,tekes,male,01/01/1940,'','','',married,cemile)),
	            assert(person(cemile,tekes,female,01/01/1943,'','','',married,osman)),

				assert(person(hasan,tekes,male,01/01/1976,osman,cemile,'',married,dilek)),
				assert(person(dilek,tekes,female,01/01/1976,'','','',married,hasan)),
				assert(person(pinar,tekes,female,01/01/1994,hasan,dilek,'',married,unal)),
				assert(person(unal,'',male,01/01/1994,'','','',married,pinar)),
				assert(person(ibrahim,'',male,01/01/2013,unal,pinar,'',single,'')),
				assert(person(enes,tekes,male,01/01/2006,hasan,dilek,'',single,'')),
				assert(person(omer,tekes,male,01/01/2002,hasan,dilek,'',single,'')),
				assert(person(rumeysa,tekes,female,01/01/2004,hasan,dilek,'',single,'')),

				assert(person(medine,ulas,female,01/01/1975,osman,cemile,'',married,refik)),
				assert(person(refik,ulas,male,01/01/1963,'','','',married,medine)),
				assert(person(eren,ulas,male,01/01/1994,refik,medine,'',single,'')),
				assert(person(erim,ulas,male,01/01/2004,refik,medine,'',single,'')),

				assert(person(aysel,biradli,female,01/01/1972,osman,cemile,'',married,mustafa)),
				assert(person(mustafa,biradli,male,01/01/1972,'','','',married,aysel)),
				assert(person(mehmet,biradli,male,01/01/1991,mustafa,aysel,'',single,'')),
				assert(person(cigdem,biradli,female,01/01/1989,mustafa,aysel,'',married,biradli)),
				assert(person(biradli,biradli,male,01/01/1987,'','','',married,cigdem)),
				assert(person(muhammet,biradli,male,01/01/2010,biradli,cigdem,'',single,'')),
				assert(person(ali,biradli,male,01/01/2012,biradli,cigdem,'',single,'')),

				assert(person(zeynep,tekes,female,01/01/1970,osman,cemile,'',married,faik)),
				assert(person(faik,tekes,male,01/01/1970,'','','',married,zeynep)),

				assert(person(ahmet,tekes,male,01/01/1969,osman,cemile,'',married,nezahat)),
				assert(person(nezahat,tekes,female,01/01/1969,'','','',married,ahmet)),
				assert(person(sezgin,tekes,male,01/01/1990,ahmet,nezahat,'',single,'')).
	
	/* returns the birth year*/
	getBirthYear(X,T):- person(X,_,_,_/_/T,_,_,_,_,_).
	
	/* returns the death year*/
	getDeathYear(X,T):- not(isAlive(X)),
						person(X,_,_,_,_,_,_/_/T,_,_).
	/* returns the year of today*/
	today(Year) :- get_time(X),
				   format_time(atom(Today), '%Y', X),
				   atom_number(Today, Year).
	/*calculates the age*/
	calcAge(X,Y):- getBirthYear(X,T),
				   today(Today),
				   Y is (Today - T).
	/*checks if the person is alive or not*/
	isAlive(X):- person(X,_,_,_,_,_,T,_,_),
				 T == ''.
	/*checks if the person is male */
	male(X):- person(X,_,male,_,_,_,_,_,_).
	
	/*checks if the person is female*/
	female(X):- person(X,_,female,_,_,_,_,_,_).
	
	/*checks if the person is married*/
	isMarried(X):- person(X,_,_,_,_,_,_,married,_).
	
	/*checks if Y is mother of X*/
	isMother(Y,X):- female(Y),
					person(X,_,_,_,_,Y,_,_,_),
					person(Y,_,_,_,_,_,_,_,_).
					
	/*checks if Y is father of X*/
	isFather(Y,X):- male(Y),
					person(X,_,_,_,Y,_,_,_,_),
					person(Y,_,_,_,_,_,_,_,_).
	
	/*checks if Y and Z are the partner of X*/
	isParent(Y,Z,X):- male(Y),
					  female(Z),
					  person(Y,_,_,_,_,_,_,_,_),
					  person(Z,_,_,_,_,_,_,_,_),
					  person(X,_,_,_,Y,Z,_,_,_).
	
	/*checks if X is grandmother of Y*/
	isGrandMother(X,Y):- female(X),
						 isFather(Z,Y),
						 isMother(X,Z);
						 female(X),
						 isMother(Z,Y),
						 isMother(X,Z).
						 
	/*checks if X is grandfather of Y*/
	isGrandFather(X,Y):- male(X),
						 isFather(Z,Y),
						 isFather(X,Z);
						 male(X),
						 isMother(Z,Y),
						 isFather(X,Z).
						 
	/*checks if X is spouse of Y*/
	/*also checks the constraints for being married*/
	isSpouse(X,Y):- isMarried(X),
					isMarried(Y),
					calcAge(X,T),
					calcAge(Y,P),
					person(X,_,_,_,_,_,_,_,Y),
					person(Y,_,_,_,_,_,_,_,X),
					(T<18
					->write(" !("),
					write(X),
					write(" is younger than 18, and cannot be married.)"),
					false
					;true),
				    (P<18
				    ->write(" !("),
				    write(Y),
				    write(" is younger than 18, and cannot be married.)"),
				    false
				    ;true),
				    (isChild(X,Y)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;isChild(Y,X)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				 	;true),
				    (isSibling(X,Y)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;true),
				    (isNephew(X,Y)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;isNephew(Y,X)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;true),
				    (isGrandMother(X,Y)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;isGrandMother(Y,X)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;true),
				    (isGrandFather(X,Y)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;isGrandFather(Y,X)
				    ->write(" (!"),
				    write(" cannot be married with a close relative)"),
				    false
				    ;true).
				    
	/*checks if X is brother of Y*/
	isBrother(X,Y):- male(Y),
					 isParent(T,Z,X),
					 isParent(T,Z,Y),
					 not(X=Y).
	
	/*checks if X is sister of Y*/
	isSister(X,Y):- female(Y),
					isParent(T,Z,X),
					isParent(T,Z,Y),
					not(X=Y).
					
	/*checks if X is a sibling of Y*/
	isSibling(X,Y):- isParent(T,Z,X),
					 isParent(T,Z,Y),
					 not(X=Y).
					 
	/*checks if X is son of Y*/
	isSon(X,Y):- male(X),
				 isFather(Y,X),
				 (not(isAlive(Y))
				 ->getDeathYear(Y,T),
				 getBirthYear(X,P),
				 (T<P
				 ->write("Father died before his son's birth date"),
				   false
				   ;true)
				 ;true);
				 male(X),
				 isMother(Y,X),
				 (not(isAlive(Y))
				 ->getDeathYear(Y,T),
				 getBirthYear(X,P),
				 (T<P
				 ->write("Mother died before her son's birth date"),
				   false
				  ;true)
				 ;true).

	/*checks if X is daughter of Y*/
	isDaughter(X,Y):- female(X),
				 	  isFather(Y,X),
				   	  (not(isAlive(Y))
				      ->getDeathYear(Y,T),
				      getBirthYear(X,P),
				      (T<P
				      ->write("Father died before his daughter's birth date"),
				      	false
				      ;true)
				      ;true);
				 	  female(X),
					  isMother(Y,X),
					  (not(isAlive(Y))
				      ->getDeathYear(Y,T),
				      getBirthYear(X,P),
				      (T<P
				      ->write("Mother died before her daughter's birth date"),
				      	false
				      ;true)
				      ;true).
				      
	/*checks if X is a child of Y*/
	isChild(X,Y):- isFather(Y,X),
				   (not(isAlive(Y))
				   ->getDeathYear(Y,T),
				   getBirthYear(X,P),
				   (T<P
				   ->write("Father died before the child's birth date"),
				   false
				   ;true)
				   ;true),
				   generation(Y,G),
				   J is (G + 1),
				   (not(generation(X,J))
				   ->assert(generation(X,J))
				   ;true);
				   isMother(Y,X),
				   (not(isAlive(Y))
				   ->getDeathYear(Y,T),
				   getBirthYear(X,P),
				   (T<P
				   ->write("(! Mother died before the child's birth date )\n"),
				   false
				   ;true)
				   ;true),
				   generation(Y,G),
				   J is (G + 1),
				   (not(generation(X,J))
				   ->assert(generation(X,J))
				   ;true).
	
	/*X'in Y'nin ablasi olup olmadigini kontrol eder*/
	isAbla(X,Y):- female(X),
				  isSister(Y,X),
				  calcAge(Y,T),
				  calcAge(X,P),
				  (P > T).
				  
	/*X'in Y'nin abisi olup olmadigini kontrol eder*/
	isAbi(X,Y):- male(X),
				 isBrother(Y,X),
				 calcAge(Y,T),
				 calcAge(X,P),
				 (P > T).
	
	/*X'in Y'nin amcasi olup olmadigini kontrol eder*/
	isAmca(X,Y):- isFather(Z,Y),
				  isBrother(Z,X).
	
	/*X'in Y'nin halasi olup olmadigini kontrol eder*/
	isHala(X,Y):- isFather(Z,Y),
				  isSister(Z,X).
				  
	/*X'in Y'nin dayisi olup olmadigini kontrol eder*/
	isDayi(X,Y):- isMother(Z,Y),
				  isBrother(Z,X).
	
	/*X'in Y'nin teyzesi olup olmadigini kontrol eder*/
	isTeyze(X,Y):- isMother(Z,Y),
				   isSister(Z,X).
	
	/*X'in Y'nin yegeni olup olmadigini kontrol eder*/
	isNephew(X,Y):- isMother(Z,X),
					isBrother(Z,Y);
					isMother(Z,X),
					isSister(Z,Y);
					isFather(Z,X),
					isBrother(Z,Y);
					isFather(Z,X),
					isSister(Z,Y).
					
	/*X'in Y'nin kuzeni olup olmadigini kontrol eder*/
	isCousin(X,Y):- isMother(Z,Y),
					isNephew(X,Z);
					isFather(Z,Y),
					isNephew(X,Z).
	
	/*X'in Y'nin enistesi olup olmadigini kontrol eder*/
	isEniste(X,Y):- male(X),
					isSpouse(X,Z),
					isNephew(Y,Z);
					male(X),
					isSpouse(X,Z),
					isSister(Z,Y).
	
	/*X'in Y'nin yengesi olup olmadigini kontrol eder*/
	isYenge(X,Y):-	female(X),
					isSpouse(X,Z),
					isNephew(Y,Z);
					female(X),
					isSpouse(X,Z),
					isSibling(Z,Y).
	
	/*X'in Y'nin kayinvalidesi olup olmadigini kontrol eder*/
	isMotherInLaw(X,Y):- female(X),
						 isSpouse(Y,Z),
						 isMother(X,Z).
	
	/*X'in Y'nin kayinpederi olup olmadigini kontrol eder*/
	isFatherInLaw(X,Y):- male(X),
						 isSpouse(Y,Z),
						 isFather(X,Z).
	
	/*X'in Y'nin gelini olup olmadigini kontrol eder*/
	isGelin(X,Y):- female(X),
				   isSpouse(X,Z),
				   isSon(Z,Y).

	/*X'in Y'nin damadi olup olmadigini kontrol eder*/
	isDamat(X,Y):- male(X),
				   isSpouse(X,Z),
				   isDaughter(Z,Y).

	/*X'in Y'nin bacanagi olup olmadigini kontrol eder*/
	isBacanak(X,Y):- male(X),
					 male(Y),
					 isSpouse(X,Z),
					 isSpouse(Y,P),
					 isSister(Z,P).
	
	/*X'in Y'nin baldizi olup olmadigini kontrol eder*/
	isBaldiz(X,Y):- female(X),
					male(Y),
					isSpouse(Y,Z),
					isSister(X,Z).
	
	/*X'in Y'nin eltisi olup olmadigini kontrol eder*/
	isElti(X,Y):- female(X),
				  female(Y),
				  isSpouse(X,Z),
				  isSpouse(Y,P),
				  isBrother(Z,P).
	
	/*X'in Y'nin kayinbiraderi olup olmadigini kontrol eder*/
	isKayinBirader(X,Y):- male(X),
						  male(Y),
						  isSpouse(X,Z),
						  isSister(Y,Z).
	
	/*displays the family tree diagram*/
	listchilds(X):- generation(A,0),
					(A==X
					->write(" |"),
					write(A),
					(isSpouse(A,Y)
					->write("--"),
					write(Y)
					;true),
					write("\n")
					;true),
					isChild(Z,X),
					generation(Z,T),
					(T==1
					->write("  |"),
					write(Z),
					(isSpouse(Z,P)
					->write("--"),
					generation(Z,G),
					assert(generation(P,G)),
					write(P)
					;true),
					write("\n")
					;T==2
					->write("   |"),
					write(Z),
					(isSpouse(Z,H)
					->write("--"),
					generation(Z,G),
					assert(generation(H,G)),
					write(H)
					;true),
					write("\n")
					;T==3
					->write("    |"),
					write(Z),
					(isSpouse(Z,U)
					->write("--"),
					generation(Z,G),
					assert(generation(U,G)),
					write(U)
					;true),
					write("\n")
					;true),
					listchilds(Z).

	/*Changes the name of X with Y*/
	updateName(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(Y,A,S,D,F,G,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the last name of X with Y*/
	updateLastName(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,Y,S,D,F,G,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the gender of X with Y*/
	updateGender(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,Y,D,F,G,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the birth date of X with Y*/
	updateBirthDate(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,Y,F,G,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the father name of X with Y*/
	updateFatherName(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,D,Y,G,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the mother name of X with Y*/
	updateMotherName(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,D,F,Y,H,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the death date of X with Y*/
	updateDeathDate(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,D,F,G,Y,J,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the marital status of X with Y*/
	updateMaritalStat(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,D,F,G,H,Y,K)),
					   retract(person(X,A,S,D,F,G,H,J,K)).
	
	/*Changes the partner name of X with Y*/
	updatePartnerName(X,Y) :- person(X,A,S,D,F,G,H,J,K),
					   assert(person(X,A,S,D,F,G,H,J,Y)),
					   retract(person(X,A,S,D,F,G,H,J,K)).

	
	/*For displaying the basic info of person X*/
	getBasicInfo(X) :- generation(X,Y),
						write("Generation level: "),
						write(Y),
						write("\n"),
						calcAge(X,T),
						write("Age: "),
						write(T),
						write("\n"),
						(isAlive(X)
						->write("Alive")
						;write("Dead")).

	/*Finds the relationship among X and Y and prints the related statement*/
	findRelation(X,Y) :-(isMother(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in annesidir. ")
						  ;isFather(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in babasidir.")
						  ;isGrandMother(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in buyukannesidir.")
						  ;isGrandFather(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in buyukbabasidir.")
						  ;isSpouse(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in esidir.")
						  ;isAbla(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin ablasidir.")
						  ;isAbi(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin abisidir.")
						  ;isBrother(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in erkek kardesidir.")
						  ;isSister(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in kiz kardesidir.")
						  ;isSon(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in ogludur.")
						  ;isDaughter(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in kizidir.")
						  ;isAmca(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin amcasidir.")
						  ;isHala(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin halasidir.")
						  ;isDayi(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin dayisidir.")
						  ;isTeyze(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin teyzesidir.")
						  ;isNephew(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in yegenidir.")
						  ;isCousin(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in kuzenidir.")
						  ;isEniste(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in enistesidir.")
						  ;isYenge(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in yengesidir.")
						  ;isMotherInLaw(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in kayinvalidesidir.")
						  ;isFatherInLaw(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in kayinbabasidir.")
						  ;isGelin(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in gelinidir.")
						  ;isDamat(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in damadidir.")
						  ;isBacanak(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in bacanagidir.")
						  ;isBaldiz(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'in baldizidir.")
						  ;isElti(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin eltisidir.")
						  ;isKayinBirader(X,Y)
						  ->write(X),
						  write(", "),
						  write(Y),
						  write("'nin kayinbiraderidir.")
						  ).
	
	/*Removes all the generation facts*/
	clearGeneration:-retract(generation(_,_)),
						clearGeneration.
	
	/*Removes all the persons*/
	removePerson:- retract(person(_,_,_,_,_,_,_,_,_)),
					   removePerson.


	/*to display the tree*/
	 displaytree(X):- not(clearGeneration),
	 				  assert(generation(X,0)),
	 				  listchilds(X).
	/* menu*/
	 menu:-
		 write("\nPress 1 to display the tree\n"),
		 write("Press 2 to display the user info\n"),
		 write("Press 3 to display the relationship of two people\n"),
		 write("Press 4 to update a person\n"),
		 write("Press 5 to revert the database to original version\n"),
		 write("Press 0 to exit\n"),
		 write("Enter your choice: "),
		 read(C),
		 (C==1
		 ->write("Enter root's name: "),
		 read(T),
		 write("\n"),
		 not(displaytree(T))
		 ;C==2
		 ->write("Enter the person's name: "),
		 read(N),
		 write("\n"),
		 getBasicInfo(N),
		 write("\n")
		 ;C==3
		 ->write("Enter the first person's name: "),
		 read(P1),
		 write("Enter the second person's name: "),
		 read(P2),
		 write("\n"),
		 findRelation(P1,P2),
		 write("\n")
		 ;C==4
		 ->write("\nPress 1 to update the name\n"),
		 write("Press 2 to update the last name\n"),
		 write("Press 3 to update the gender\n"),
		 write("Press 4 to update the birth date\n"),
		 write("Press 5 to update father name\n"),
		 write("Press 6 to update mother name\n"),
		 write("Press 7 to update death date\n"),
		 write("Press 8 to update marital status\n"),
		 write("Press 9 to update partner name\n"),
		 read(U),
		 write("\n"),
		 write("Enter the person's name: "),
		 read(N),
		 write("Enter the updated information: "),
		 read(D),
		 write("\n"),
		 (U==1
		 ->updateName(N,D),
		 write("\n")
		 ;U==2
		 ->updateLastName(N,D),
		 write("\n")
		 ;U==3
		 ->updateGender(N,D),
		 write("\n")
		 ;U==4
		 ->updateBirthDate(N,D),
		 write("\n")
		 ;U==5
		 ->updateFatherName(N,D),
		 write("\n")
		 ;U==6
		 ->updateMotherName(N,D),
		 write("\n")
		 ;U==7
		 ->updateDeathDate(N,D),
		 write("\n")
		 ;U==8
		 ->updateMaritalStat(N,D),
		 write("\n")
		 ;U==9
		 ->updatePartnerName(N,D),
		 write("\n"))
		 ;C==5
		 ->not(removePerson),
		 addPerson
		 ;C==0
		 ->false),
		 menu.







	
