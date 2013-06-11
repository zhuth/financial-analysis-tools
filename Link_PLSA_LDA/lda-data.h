#ifndef LDA_DATA_H
#define LDA_DATA_H

#include <stdio.h>
#include <stdlib.h>

#include "lda.h"

#define OFFSET 0;                  // offset for reading data

corpus* read_full_data(char* cited_data_filename, 
                       char* citing_data_filename, 
                       char* citations_filename);

corpus* read_citing_data(char* citing_data_filename, 
                         char* citations_filename);

corpus* read_citing_data_text_only(char* citing_data_filename);


int max_corpus_length(corpus* c);
int max_citations(corpus *c);

#endif
