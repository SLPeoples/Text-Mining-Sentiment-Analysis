### Handling Strings in R

# What are Strings? # It is a type of data - mainly text data # quotations "" are used to specify data as a string (character)

mystring <- "this is a string!" mystring

# Where are Strings mainly used? # Scraped data: Twitter, Google, etc # Text based data e.g. Sentiment Analysis # Text Mining,....

# What are the main ways in R to handle Strings? # R Base offers useful features to handle Strings e.g. gsub # In order to be able to handle Strings a sublanguage (Regular Expressions) is used # Add ons are available like "stringr" and "gsubfun"

# - Important note: According to your location and computer, characters  # (e.g. from Twitter messages) may be encoded or used differently in your R session # for example you might sometimes scrape texts is cyrillic or mandarin  # hence usage of Regular Expressions may slightly differ

# changing the cases tolower("Graphs and Histograms") toupper("Graphs and Histograms") # splitting the string in single character values strsplit("Graphs and Histograms", NULL) # splitting strings after each space strsplit("Graphs and Histograms", " ")

## Substitution in Strings - gsub family

# lets get a character vector with 2 strings teststring <- c("my teststring to explain how substitution with my R Base works",  "another teststring for My example of gsub and sub")

# output teststring

# 1. structure of the sub/gsub family gsub("my", "OUR", teststring)

# 2. difference sub vs gsub - sub exchanges only the first occurance per string sub("my", "OUR", teststring)

# 3. working with cases - see the last string My gsub("my", "OUR", teststring, ignore.case = T)

# 4. working with numbers - deleting numbers numberstring <- c("3445 is GReater than 23 - @???!§$", "Tom coded 11 Java scrips and 23 Python scripts")

numberstring

# we need to check the regular expression syntax to see how digits are encoded gsub("\\d", "", numberstring)

# now we go the other way round and replace anything not beeing a digit gsub("\\D", "", numberstring)

# 5.avoid the spaces gsub("\\s", "", numberstring)

# 6. advanced methods

# lets exchange specific letters with "Q" gsub("[iot]", "Q", numberstring)

# removing punctuation gsub("[[:punct:]]", "", numberstring)

# removing anything but graphical characters gsub("[^[:graph:]]", "", numberstring)

Package stringer offers several useful functions for string handling

library(stringer)

teststring <- c("my teststring to explain how substitution with my R Base works",  "another teststring for My example of gsub and sub")

numberstring <- c("3445 is GReater than 23 - @???!§$", "Tom coded 11 Java scrips and 23 Python scripts")

# adding strings together str_c(c(numberstring, teststring), sep="")

# we can count the occurences of a specific symbol in an element str_count(numberstring, "3")

# we can locate the first and last position of a symbol in a given string str_locate_all(numberstring, "3")

# replacement similar to sub - first occurence str_replace(numberstring, "\\d", "")

# and gsub - all occurences str_replace_all(numberstring, "\\d", "")

# library(gsubfn) - can be used to incorporate functions to gsub

### Exercise

ourstring <- c("Tom found 74 apples", "Is this a question?",  "How many $ and ??? doEs it cost?")

ourstring

# 1. put the string to complete lowercase # 2. remove the punctuation # 3. remove the spaces # 4. remove the ??? sign (if you have it on your keyboard) # 5. use str_extract_all from stringer to see which element contains "is" ourstring = tolower(ourstring); ourstring # 1

ourstring = gsub("[[:punct:]]", "", ourstring); ourstring # 2

ourstring = gsub("\\s", "", ourstring); ourstring # 3

ourstring = gsub("[???]", "", ourstring); ourstring # 4

str_extract_all(ourstring, "is") # 5