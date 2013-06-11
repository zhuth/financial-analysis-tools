
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

#ifndef LDA_H
#define LDA_H

typedef struct
{
    int* words;
    int* counts;
    int length;
    int total;
} cited_document;

typedef struct
{
    int* words;
    int* counts;
    int *citations;
    int length;
    int total;
    int num_citations;
} citing_document;

typedef struct
{
    citing_document* citing_docs;
    cited_document* cited_docs; 
    int num_terms;
    int num_cited_docs;
    int num_citing_docs;
} corpus;

typedef struct
{
  double alpha_citing;
  double alpha_cited;
  double** log_prob_w;
  double** log_prob_d;
  double* log_prob_k;
  int num_topics;
  int num_terms;
  int num_cited_docs;
} lda_model;

typedef struct
{
  double** class_word;
  double* class_word_total;
  double **class_doc;
  double *class_doc_total;
  double *class_data;
  double class_total;
  double alpha_citing_suffstats;
  double alpha_cited_suffstats;
  int num_cited_docs;
  int num_citing_docs;
} lda_suffstats;

#endif
