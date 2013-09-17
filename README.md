moss.rb
=======

A plagiarism detection engine based on Stanford's MOSS(Measure of Software Similarity) 

#### What is Moss?
Moss (for a Measure Of Software Similarity) is an automatic system for determining the similarity of programs. To date, the main application of Moss has been in detecting plagiarism in programming classes. Since its development in 1994, Moss has been very effective in this role. The algorithm behind moss is a significant improvement over other cheating detection algorithms (at least, over those known to us).


#### Languages
Moss can currently analyze code written in the following languages:
C, Java

Adding new languages is fairly easy, check out the conf directory to learn how and add your language (don't forget to open a pull request so we can incorporate the new language)

#### How Does it Work?

A paper on the ideas behind Moss can be found [here](http://theory.stanford.edu/~aiken/publications/papers/sigmod03.pdf). 
