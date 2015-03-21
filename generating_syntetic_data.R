years <- c(1900:2020)

categories <- c("Best Film Editing","Best Picture","Best Directing","Best Actor in a Leading Role","Best Actor in a Supporting Role","Best Actress in a Leading Role","Best Actress in a Supporting Role","Best Animated Feature","Best Animated Short Film","Best Cinematography","Best Costume Design","Best Documentary Feature","Best Documentary Short Subject","Best Foreign Language Film","Best Live Action Short Film","Best Makeup and Hairstyling","Best Original Score","Best Original Song","Best Production Design","Best Sound Editing","Best Sound Mixing","Best Visual Effects","Best Adapted Screenplay","Best Original Screenplay")

some_random_names <- c("Gerda Dyches","Kena Marchal","Shizue Pond","Hanh Vera","Melva Brumm","Pedro Mcgarr","Ginny Mooney","Bula Pocock","Kenisha Waldner","Lucilla Stlawrence","Daria Winstead","Dimple Hannah","Daina Kirts","Lenore Chesley","Annemarie Diggins","Daisey Schier","Mandi Santoyo","Nanette Cordle","Buford Stegall","Lester Burruss","Bridgette Gatewood","Avery Bise","Charmain Guinan","Ivonne Vanderhoof","Keiko Wisdom","Margurite Shumate","Leonardo Mcgowin","Felica Mahaney","Nita Markham","Karrie Robicheaux","Alexa Bylsma","Woodrow Isreal","Linh Fruge","Estella Reidhead","Junie Roeser","Kiley Groves","Eufemia Etherton","Niki Vanatta","Fae Garg","Brigette Shaw","Madalyn Midkiff","Stanton Maltos","Ashlie Santo","Peg Goucher","Racheal Sussman","Millicent Dunaway","Tien Heckard","Thad Perea","Porter Crader","Liberty Jerabek")

some_random_movie_names <- c("Birdemic: Shock and Terror","Overboard","Going Overboard","Marvin's Room","Iron Sky","Tucker and Dale vs. Evil","Quills","The Machinist","Swimming with Sharks","Barton Fink","Silver Bullet","The Man from Earth","The Quest","The Nine Lives of Fritz the Cat","Remo Williams: The Adventure Begins","The Octagon","Airport","Airport 1975","Cool World","The Paper","Paper Man","Atlas Shrugged: Part I","Bernie","Jeff, Who Lives at Home","The King's Speech","Butter","Bottle Shock","Ghost","Eight Men Out","Earth Girls Are Easy","Flowers in the Attic","Happy, Texas","Into the West","Lucky","Mermaids","Not Without My Daughter","The Parking Lot Movie","Things to Do in Denver When You're Dead","Humboldt County","$5 a Day","The African Queen","A Bag of Hammers","Beyond Silence","The Experts","Dutch","Grand Canyon","Heartburn","Once Around","Nine to Five","School Ties","Sabrina","Sassy Pants","Summer School","To Be or Not to Be","True Confessions","Undertaking Betty","In a Day","There Goes the Neighborhood","Cross My Heart","Rat","Raising Arizona","Rabbit Hole","The Lincoln Lawyer","Wild Target","Memento","The Last of the Mohicans","The Last Emperor","Insidious","Heathers","Following","8MM","Dead Man","Career Opportunities","Rubber","Chinatown","The Apostle","The Adventures of Ford Fairlane","Bustin' Loose","Greedy","She-Devil","The Smell of Success","Senseless","Far Out Man","Management","I.Q.","The Golden Child","Tremors","Red Corner","Millennium","Going Berserk","The Thing","Easy Money","Warrior","The Hunt for Red October","Seeking Justice","Guns, Girls and Gambling","Once Upon a Time in the West","The Andromeda Strain","Dylan Dog: Dead of Night","Time Bandits","Men of War","Star Trek II: The Wrath of Khan","Star Trek III: The Search for Spock","Star Trek: Insurrection","Star Trek: Nemesis","The Untouchables","Terms of Endearment","Morning Glory","For Greater Glory: The True Story of Cristiada","The Accused","October Baby","The Dream Team","The Manhattan Project","Renegades","Rain Man","Pet Sematary","The Philadelphia Experiment","Soapdish","Promised Land","Restoration","Into the Wild","Margin Call","The Paperboy","Airheads","The Cabin in the Woods","Drop Dead Fred","The Constant Gardener","Return to Paradise","Howl","The Pianist","Welcome to Sarajevo","The Last Temptation of Christ","Rosencrantz & Guildenstern Are Dead","The Chaperone","Toys","Religulous","Stop! Or My Mom Will Shoot","London Boulevard","Pi","The Final Countdown","An Officer and a Gentleman","The Boy in the Striped Pajamas","'night, Mother","Raggedy Man","The Long Walk Home","Goon","Agnes Browne","My Left Foot","Jiro Dreams of Sushi","Shakma","Nell","The House of the Spirits","Colors","Boyz n the Hood","In the Name of the Father","Perrier's Bounty","Beautiful Boxer","Ghost Dad","HouseSitter","The Evil Dead","Hellraiser","I'm a Cyborg, But That's OK","Penny Pinchers","Batman: The Movie","Mirror Mirror","Drive","Sympathy for Mr. Vengeance","Sympathy for Lady Vengeance","Hugo","The Hunger Games","Fierce People","The Onion Field","The Red Violin","Defiance","The Closet","Harry and Tonto","Zapped!","Orca","Dumplings","Sgt. Bilko","John Dies at the End","Thieves Like Us","Roman Holiday","ParaNorman","Streets of Fire","The Impostors","Quigley Down Under","Play It Again, Sam","Crimes of the Heart","Day of the Falcon","You've Been Trumped","Bully","8 Million Ways to Die","Clear and Present Danger","American Me","Today's Special","The Brink's Job","Cosmopolis","Sweet Liberty","Nature Calls","The Company Men","The Frighteners","The Great Waldo Pepper","The Eiger Sanction","The Paper Chase","Biutiful","The Artist","Strategic Air Command","The Great Gatsby","The Turning Point","Down and Out in Beverly Hills","Stick","Reds","Taps","Staying Alive","Cry, the Beloved Country","Frankie and Johnny","She's All That","Jumanji","Frogs")

#awards <- NULL
#assumption 1: There are a total of 20 awards. 4 people get nominated for each award per year. 
#              Let's say that the probability of being nominated is uniform
#             , except for four individuals that excelled in that year that get 3 times more nominations
#             than their peers
awards <- NA

for (year in years) {
  # pick 15 movies that we're going to be nominated across 20 awards with 4 nominations per award
  the_nominated_movies_this_year_are <- sample(some_random_movie_names,15,replace=FALSE)

  # pick 25 people that we're going to nominate across 20 awards with 4 nominations per award
  the_nominees_this_year_are <- sample(some_random_names,20,replace=FALSE)

  # the first 4 movies in the list are 3x likely to be nominated multiple times
  # the last 3 movies in the list are 1/2 x likely to be nominated multiple times
  odds_for_being_nominated_multiple_times <- c(rep(3/15,4),rep(1/15,8),rep(1/30,3))

  best_film_editing_winner <- NA
  best_documentary_winner <- NA
  for (category in categories) {
    nominated_movies_for_category <- sample(the_nominated_movies_this_year_are,4,replace=FALSE,prob=odds_for_being_nominated_multiple_times)
    winner <- sample(nominated_movies_for_category,1)
    this_years_awards <- data.frame(year,category,nominee=sample(the_nominees_this_year_are,4),additional_info=nominated_movies_for_category,won="NO")
    levels(this_years_awards$won) <- c("NO","YES")

    if (category == "Best Film Editing") {
      best_film_editing_winner <- winner
    } else if (category == "Best Picture" & best_film_editing_winner %in% nominated_movies_for_category) {
      winner<-sample(c(best_film_editing_winner,winner),1)
    } else if (category == "Best Documentary Feature") {
      best_documentary_winner <- winner
    } else if (category == "Best Documentary Short Subject" & best_documentary_winner %in% nominated_movies_for_category) {
      winner<-sample(c(best_documentary_winner,winner),1,prob=c(0.25,0.75))
    }
    
    this_years_awards[this_years_awards$year==year&this_years_awards$category==category&this_years_awards$additional_info==winner,"won"]<-"YES"
    awards <- rbind(awards,this_years_awards)
  }
}



awards[complete.cases(awards),]