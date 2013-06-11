* This is an implementation of the Link_PLSA_LDA model for textual data with citations, as described in "Joint Topic Models for Text and Citations. Ramesh Nallapati, Amr Ahmed, Eric Xing, William Cohen, KDD 2008". This code is a modification of LDA-C code released by David Blei.  

* Please look at run-lda.csh on how to run the program. The first argument defines the run setting. "est" 
corresponds to estimating the model from text and citations. "inf" 
corresponds to estimating the perplexity of unseen citing data. "pdt" 
corresponds to predicting the likelihood of links for new citing data. 
Pleas run the model for these settings on toy data to understand the 
output of these models. You may also need to look into the code to figure 
out the meaning of some of the numbers (Sorry for not being more helpful 
at this time!).

* Please look at the sample_data directory 
for sample input files. 

* In the sample_data directory, cited_docs.txt and citing_docs.txt contain
the sparse term_document matrix of cited_docs and citing_docs in LDA
format. Please visit David Blei's LDA page to learn more about this
format.

* citations.txt contains the list of citations for each citing document.  
Each row corrsponds to a citing document in the same order as the
documents in the citing_docs.txt file. The first column is the number of
citations, and the remaining columns represent the IDs of the documents
which are cited. Note that since we assume a bipartite link structure (links arise 
from documents in the citing set and point towards documents in the cited set, but 
there are no links within each set), the cited document id corresponds to the 
row number in the cited_docs.txt file.  If your data is not bipartite, it is easy to create 
a bipartite approximation by making two copies of a document that has both incoming and outgoing links,
put one of them in the cited set with incoming links and the other in the citing set with outgoing links.

* IMPORTANT: The citations in each row in citations.txt file should be
sorted in the ascending order. Else, the code will give you incorrect
results.

* If you have any questions, please
contact me at ramesh.nallapati@gmail.com. I will try to respond as early as
possible, but I cannot guarantee immediate response, especially if the
question requires me to dig into the code.

