#ifndef LDA_MODEL_H
#define LDA_MODEL

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "lda.h"
#include "lda-alpha.h"
#include "cokus.h"

#define myrand() (double) (((unsigned long) randomMT()) / 4294967296.)
#define NUM_INIT 1

void lda_mle(lda_model* model, lda_suffstats* ss, int estimate_alpha);
void lda_mle_log_prob_k_d_only(lda_model* model, lda_suffstats* ss);
lda_suffstats* new_lda_suffstats(lda_model* model);
void zero_initialize_ss(lda_suffstats* ss, lda_model* model);
void random_initialize_ss(lda_suffstats* ss, lda_model* model);
void corpus_initialize_ss(lda_suffstats* ss, lda_model* model, corpus* c);
lda_model* new_lda_model(int num_terms, int num_cited_docs, int num_topics);

void free_lda_model(lda_model*);
void save_lda_model(lda_model*, char*);

lda_model* load_lda_model(char* model_root);
lda_model* load_lda_model_topics_only(char* model_root, int num_cited_docs);

#endif
