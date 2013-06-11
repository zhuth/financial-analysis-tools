// (C) Copyright 2004, David M. Blei (blei [at] cs [dot] cmu [dot] edu)

// This file is part of LDA-C.

// LDA-C is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your
// option) any later version.

// LDA-C is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA

#include "lda-data.h"

corpus* read_full_data(char* cited_data_filename, char* citing_data_filename, char* citations_filename)
{
    FILE *fileptr;
    int length, count, word, n, nd, nw, cited_doc;
    corpus* c;
    c = (corpus*)malloc(sizeof(corpus));

    printf("reading data from %s\n", cited_data_filename);
    c->cited_docs = (cited_document*) malloc(sizeof(cited_document)*(100));
	
    fileptr = fopen(cited_data_filename, "r");
    nd = 0; nw = 0;
    while ((fscanf(fileptr, "%10d", &length) != EOF))
    {
	//c->cited_docs = (cited_document*) realloc(c->cited_docs, sizeof(cited_document)*(nd+1));
	c->cited_docs[nd].length = length;
	
	c->cited_docs[nd].total = 0;
	c->cited_docs[nd].words = malloc(sizeof(int)*length);
	c->cited_docs[nd].counts = malloc(sizeof(int)*length);
	for (n = 0; n < length; n++)
	{
	    fscanf(fileptr, "%10d:%10d", &word, &count);
	    word = word - OFFSET;
	    c->cited_docs[nd].words[n] = word;
	    c->cited_docs[nd].counts[n] = count;
	    c->cited_docs[nd].total += count;
	    if (word >= nw) { nw = word + 1; }
	}
	nd++;
    }
    fclose(fileptr);
    c->num_cited_docs = nd;

    printf("number of cited docs    : %d\n", nd);

    fileptr = fopen(citing_data_filename, "r");
    nd = 0;
    c->citing_docs = (citing_document*) malloc(sizeof(citing_document)*(100));
    while ((fscanf(fileptr, "%10d", &length) != EOF))
    {
	//c->citing_docs = (citing_document*) realloc(c->citing_docs, sizeof(citing_document)*(nd+1));
	c->citing_docs[nd].length = length;
	c->citing_docs[nd].total = 0;
	c->citing_docs[nd].words = (int*)malloc(sizeof(int)*length);
	c->citing_docs[nd].counts = (int*)malloc(sizeof(int)*length);
	for (n = 0; n < length; n++)
	{
	    fscanf(fileptr, "%10d:%10d", &word, &count);
	    word = word - OFFSET;
	    c->citing_docs[nd].words[n] = word;
	    c->citing_docs[nd].counts[n] = count;
	    c->citing_docs[nd].total += count;
	    if (word >= nw) { nw = word + 1; }
	}
	nd++;
    }
    fclose(fileptr);
    c->num_citing_docs = nd;
    c->num_terms = nw;

    printf("number of citing docs    : %d\n", nd);
    printf("number of terms   : %d\n", nw);
    
    printf("reading citations data (full) from %s\n", citations_filename);
    fileptr = fopen(citations_filename, "r");
    nd = 0;
    while((fscanf(fileptr, "%10d", &length) != EOF))
      {
	c->citing_docs[nd].citations = (int*)malloc(sizeof(int)*length);
	c->citing_docs[nd].num_citations = length;
	for (n = 0; n < length; n++)
	  {
	    fscanf(fileptr, "%10d", &cited_doc);
	    c->citing_docs[nd].citations[n] = cited_doc;
	  }
	nd++;
      } 
    fclose(fileptr);
    printf("citations read done.\n");
    return(c);
}

corpus* read_citing_data(char* citing_data_filename, char* citations_filename)
{
    FILE *fileptr;
    int length, count, word, n, nd, cited_doc;
    corpus* c;
    c = (corpus*)malloc(sizeof(corpus));
    //c->num_terms = num_terms;

    fileptr = fopen(citing_data_filename, "r");
    nd = 0;
    c->citing_docs = (citing_document*) malloc(sizeof(citing_document)*(100));
	while ((fscanf(fileptr, "%10d", &length) != EOF))
    {
	//c->citing_docs = (citing_document*) realloc(c->citing_docs, sizeof(citing_document)*(nd+1));
	c->citing_docs[nd].length = length;
	c->citing_docs[nd].total = 0;
	c->citing_docs[nd].words = (int*)malloc(sizeof(int)*length);
	c->citing_docs[nd].counts = (int*)malloc(sizeof(int)*length);
	for (n = 0; n < length; n++)
	{
	    fscanf(fileptr, "%10d:%10d", &word, &count);
	    word = word - OFFSET;
	    c->citing_docs[nd].words[n] = word;
	    c->citing_docs[nd].counts[n] = count;
	    c->citing_docs[nd].total += count;
	}
	nd++;
    }
    fclose(fileptr);
    c->num_citing_docs = nd;

    printf("number of citing docs    : %d\n", nd);
    
    printf("reading citations data from %s\n", citations_filename);
    fileptr = fopen(citations_filename, "r");
    nd = 0;
    while((fscanf(fileptr, "%10d", &length) != EOF))
      {
	c->citing_docs[nd].citations = (int*)malloc(sizeof(int)*length);
	c->citing_docs[nd].num_citations = length;
	for (n = 0; n < length; n++)
	  {
	    fscanf(fileptr, "%10d", &cited_doc);
	    c->citing_docs[nd].citations[n] = cited_doc;
	  }
	nd++;
      } 
    fclose(fileptr);
    return(c);
}

corpus* read_citing_data_text_only(char* citing_data_filename)
{
    FILE *fileptr;
    int length, count, word, n, nd;
    corpus* c;
    c = (corpus*)malloc(sizeof(corpus));
    //c->num_terms = num_terms;

    fileptr = fopen(citing_data_filename, "r");
    nd = 0;
    c->citing_docs = (citing_document*) malloc(sizeof(citing_document)*(100));
    while ((fscanf(fileptr, "%10d", &length) != EOF))
    {
	c->citing_docs = (citing_document*) realloc(c->citing_docs, sizeof(citing_document)*(nd+1));
	c->citing_docs[nd].length = length;
	c->citing_docs[nd].total = 0;
	c->citing_docs[nd].words = (int*)malloc(sizeof(int)*length);
	c->citing_docs[nd].counts = (int*)malloc(sizeof(int)*length);
	for (n = 0; n < length; n++)
	{
	    fscanf(fileptr, "%10d:%10d", &word, &count);
	    word = word - OFFSET;
	    c->citing_docs[nd].words[n] = word;
	    c->citing_docs[nd].counts[n] = count;
	    c->citing_docs[nd].total += count;
	}
	nd++;
    }
    fclose(fileptr);
    c->num_citing_docs = nd;

    printf("number of citing docs    : %d\n", nd);
    return(c);
}


int max_corpus_length(corpus* c)
{
    int n, max = 0;
    for (n = 0; n < c->num_cited_docs; n++)
	if (c->cited_docs[n].length > max) max = c->cited_docs[n].length;
    for (n = 0; n < c->num_citing_docs; n++)
      if (c->citing_docs[n].length > max) max = c->citing_docs[n].length;
    return(max);
}

int max_citations(corpus* c)
{
    int n, max = 0;
    for (n = 0; n < c->num_citing_docs; n++)
	if (c->citing_docs[n].num_citations > max) max = c->citing_docs[n].num_citations;
    return(max);
}
