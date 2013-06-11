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

#include "lda-estimate.h"

/*
 * perform inference on a document and update sufficient statistics
 *
 */

double citing_doc_e_step(citing_document* doc, double* gamma, double** phi, double **var_phi,
                  lda_model* model, lda_suffstats* ss)
{
    double likelihood;
    int n,d,k;

    // posterior inference

    likelihood = lda_inference_citing(doc, model, gamma, phi,var_phi);
  
    // update sufficient statistics

    /*
    double gamma_sum = 0;
    for (k = 0; k < model->num_topics; k++)
    {
        gamma_sum += gamma[k];
        ss->alpha_citing_suffstats += digamma(gamma[k]);
    }
    ss->alpha_suffstats -= model->num_topics * digamma(gamma_sum);
    */

    for (n = 0; n < doc->length; n++)
    {
        for (k = 0; k < model->num_topics; k++)
        {
            ss->class_word[k][doc->words[n]] += doc->counts[n]*phi[n][k];
            ss->class_word_total[k] += doc->counts[n]*phi[n][k];
        }
    }

    for (d = 0; d < doc->num_citations; d++)
    {
        for (k = 0; k < model->num_topics; k++)
        {
            ss->class_doc[k][doc->citations[d]] += var_phi[d][k];
            ss->class_doc_total[k] += var_phi[d][k];
        }
    }

    ss->num_citing_docs = ss->num_citing_docs + 1;

    return(likelihood);
}


double cited_docs_e_step(cited_document * cited_docs, lda_model *model, lda_suffstats *ss)
{
  int d,k,n;
  double zetasum, likelihood = 0;
  double zeta[model->num_topics]; 


  zero_initialize_ss(ss,model);


  for(d= 0; d < model->num_cited_docs; d++)
    {
      //printf("d = %d\n", d); //, n = %d k = %d zeta = %f likelihood = %f\n",d,n,k,zeta[k],likelihood);
      cited_document * doc = &(cited_docs[d]);
      for(n = 0; n < doc->length; n++)
	{ 
	  zetasum = 0;
	  for(k = 0; k < model->num_topics;k++)
	    { 
	      zeta[k] = model->log_prob_k[k] + model->log_prob_w[k][doc->words[n]]
		+ model->log_prob_d[k][d];
	      if(k > 0) 
		zetasum = log_sum(zetasum,zeta[k]);
	      else
		zetasum = zeta[k];
	    }
	  for(k = 0; k < model->num_topics; k++)
	    {
	      zeta[k] = exp(zeta[k] - zetasum);

		likelihood+= doc->counts[n]*zeta[k]*(model->log_prob_k[k] 
						   +  model->log_prob_w[k][doc->words[n]]
						   +  model->log_prob_d[k][d]);
	      if(zeta[k] > 0)
		likelihood -= doc->counts[n]*zeta[k]*log(zeta[k]);

	      ss->class_word[k][doc->words[n]]+=doc->counts[n]*zeta[k];
	      ss->class_word_total[k]+=doc->counts[n]*zeta[k];
	      ss->class_doc[k][d]+=doc->counts[n]*zeta[k];
	      ss->class_doc_total[k]+=doc->counts[n]*zeta[k];
	      ss->class_data[k] +=zeta[k]*doc->counts[n];
	      ss->class_total+=zeta[k]*doc->counts[n];
	    }
	}
    }

  //printf(">>>> reached here\n");
  assert(!isnan(likelihood));
   return likelihood;
}

/*
 * writes the word assignments line for a document to a file
 *


void write_word_assignment(FILE* f, document* doc, double** phi, lda_model* model)
{
    int n;

    fprintf(f, "%03d", doc->length);
    for (n = 0; n < doc->length; n++)
    {
        fprintf(f, " %04d:%02d",
                doc->words[n], argmax(phi[n], model->num_topics));
    }
    fprintf(f, "\n");
    fflush(f);
}

*/

/*
 * saves the gamma parameters of the current dataset
 *
 */

void save_gamma(char* filename, double** gamma, int num_docs, int num_topics)
{
    FILE* fileptr;
    int d, k;
    fileptr = fopen(filename, "w");

    for (d = 0; d < num_docs; d++)
    {
	fprintf(fileptr, "%5.10f", gamma[d][0]);
	for (k = 1; k < num_topics; k++)
	{
	    fprintf(fileptr, " %5.10f", gamma[d][k]);
	}
	fprintf(fileptr, "\n");
    }
    fclose(fileptr);
}


/*
 * run_em
 *
 */
 
void run_em(char* start, char* directory, corpus* corpus)
{

    int d, n;
    lda_model *model = NULL;
    double **var_gamma, **phi, **var_phi;  

    // allocate variational parameters
    var_gamma = (double**)malloc(sizeof(double*) * corpus->num_citing_docs);
    for (d = 0; d < corpus->num_citing_docs; d++)
		var_gamma[d] = (double*)malloc(sizeof(double) * NTOPICS);

    int max_length = max_corpus_length(corpus);
    phi = (double**)malloc(sizeof(double*)*max_length);
    for (n = 0; n < max_length; n++)
      {
	phi[n] = (double*)malloc(sizeof(double) * NTOPICS);
      }
    int max_cite = max_citations(corpus);
    var_phi = (double**)malloc(sizeof(double*)*max_cite);
    for (n = 0; n < max_cite; n++)
	var_phi[n] = (double*)malloc(sizeof(double)*NTOPICS);

    // initialize model

    char filename[100];
    
    lda_suffstats* ss = NULL;
    if (strcmp(start, "seeded")==0)
    {
      //printf("initializing using the corpus");
      model = new_lda_model(corpus->num_terms, corpus->num_cited_docs, NTOPICS);
      ss = new_lda_suffstats(model);
      corpus_initialize_ss(ss, model, corpus);
      lda_mle(model, ss, 0);
      model->alpha_citing = INITIAL_ALPHA;
      model->alpha_cited = INITIAL_ALPHA;
    }
    else if (strcmp(start, "random")==0)
    {
      model = new_lda_model(corpus->num_terms, corpus->num_cited_docs, NTOPICS);
        ss = new_lda_suffstats(model);
        random_initialize_ss(ss, model);
        lda_mle(model, ss, 0);
        model->alpha_citing = INITIAL_ALPHA;
	model->alpha_cited = INITIAL_ALPHA;
    }
    else
    {
        model = load_lda_model(start);
        ss = new_lda_suffstats(model);
    }
    sprintf(filename,"%s/000",directory);
    save_lda_model(model, filename);

    // run expectation maximization

    int i = 0;
    double likelihood, likelihood_old = 0, converged = 1;
    sprintf(filename, "%s/likelihood.dat", directory);
    FILE* likelihood_file = fopen(filename, "w");

    while (((converged < 0) || (converged > EM_CONVERGED) || (i <= 2)) && (i <= EM_MAX_ITER))
    {
        i++; printf("**** em iteration %d ****\n", i);
        likelihood = 0;
        zero_initialize_ss(ss, model);

        // e-step

	likelihood+= cited_docs_e_step(corpus->cited_docs,model,ss);

        for (d = 0; d < corpus->num_citing_docs; d++)
        {
	  if ((d % 100) == 0) 
	      printf("document %d\n",d);
	  //printf("var_gamma[d][0] %f\n",var_gamma[d][0]);
            likelihood += citing_doc_e_step(&(corpus->citing_docs[d]),
                                     var_gamma[d],
                                     phi, var_phi,
                                     model,
                                     ss);
	    //printf("likelihood of document %d %10.10f\n",d,likelihood);
        }



        // m-step

        lda_mle(model, ss, ESTIMATE_ALPHA);

        // check for convergence

        converged = (likelihood_old - likelihood) / (likelihood_old);
        if (converged < 0) VAR_MAX_ITER = VAR_MAX_ITER * 2;
        likelihood_old = likelihood;

        // output model and likelihood

        fprintf(likelihood_file, "%10.10f\t%5.5e\n", likelihood, converged);
        fflush(likelihood_file);
        if ((i % LAG) == 0)
        {
            sprintf(filename,"%s/%03d",directory, i);
            save_lda_model(model, filename);
            sprintf(filename,"%s/%03d.gamma",directory, i);
            save_gamma(filename, var_gamma, corpus->num_citing_docs, model->num_topics);
	    sprintf(filename,"%s/%03d.tau",directory,i);
        }
    }
 
    // output the final model

    sprintf(filename,"%s/final",directory);
    save_lda_model(model, filename);
    sprintf(filename,"%s/final.gamma",directory);
    save_gamma(filename, var_gamma, corpus->num_citing_docs, model->num_topics);
    // output the word assignments (for visualization)

    /*
    sprintf(filename, "%s/word-assignments.dat", directory);
    FILE* w_asgn_file = fopen(filename, "w");
    for (d = 0; d < corpus->num_docs; d++)
    {
        if ((d % 100) == 0) printf("final e step document %d\n",d);
        likelihood += lda_inference(&(corpus->docs[d]), model, var_gamma[d], phi);
        write_word_assignment(w_asgn_file, &(corpus->docs[d]), phi, model);
    }
    fclose(w_asgn_file);
    */
    fclose(likelihood_file);
}


/*
 * read settings.
 *
 */

void read_settings(char* filename)
{
    FILE* fileptr;
    char alpha_action[100];
    fileptr = fopen(filename, "r");
    fscanf(fileptr, "var max iter %d\n", &VAR_MAX_ITER);
    fscanf(fileptr, "var convergence %f\n", &VAR_CONVERGED);
    fscanf(fileptr, "em max iter %d\n", &EM_MAX_ITER);
    fscanf(fileptr, "em convergence %f\n", &EM_CONVERGED);
    fscanf(fileptr, "alpha %s", alpha_action);
    if (strcmp(alpha_action, "fixed")==0)
    {
	ESTIMATE_ALPHA = 0;
    }
    else
    {
	ESTIMATE_ALPHA = 1;
    }
    fclose(fileptr);
}


/*
 * inference only
 *
 */

void infer(char* model_root, char* save, corpus* corpus)
{
    FILE* fileptr;
    char filename[100];
    int i, d, n;
    lda_model *model;
    double **var_gamma, likelihood, **phi, **var_phi;
    citing_document* doc;

    model = load_lda_model(model_root);
    var_gamma = (double**)malloc(sizeof(double*)*(corpus->num_citing_docs));
    for (i = 0; i < corpus->num_citing_docs; i++)
	var_gamma[i] = (double*)malloc(sizeof(double)*model->num_topics);
    sprintf(filename, "%s-lda-lhood.dat", save);
    fileptr = fopen(filename, "w");
    for (d = 0; d < corpus->num_citing_docs; d++)
    {
	if ((d % 100) == 0) printf("document %d\n",d);

	doc = &(corpus->citing_docs[d]);
	phi = (double**) malloc(sizeof(double*) * doc->length);
	for (n = 0; n < doc->length; n++)
	    phi[n] = (double*) malloc(sizeof(double) * model->num_topics);
	var_phi = (double**)malloc(sizeof(double*)*doc->num_citations);
	for(n = 0; n < doc->num_citations; n++)
	  var_phi[n] = (double*)malloc(sizeof(double)*model->num_topics);
	likelihood = lda_inference_citing(doc, model, var_gamma[d], phi,var_phi);
	for(n = 0; n < doc->length;n++)
	  free(phi[n]);
	free(phi);
	for(n = 0; n < doc->num_citations; n++)
	  free(var_phi[n]);
	free(var_phi);
	fprintf(fileptr, "%5.5f\n", likelihood);
    }
    fclose(fileptr);
    sprintf(filename, "%s-gamma.dat", save);
    save_gamma(filename, var_gamma, corpus->num_citing_docs, model->num_topics);
}

void infer_new_corpus(char* model_root, char* directory, corpus* corpus)
{
    char filename[100];
    int i = 0, d,n;
    lda_model *model = NULL;
    lda_suffstats* ss = NULL;
    double **var_gamma, **phi, **var_phi;


    //initialize the model
    model = load_lda_model_topics_only(model_root,corpus->num_cited_docs);
    ss = new_lda_suffstats(model);

    var_gamma = (double**)malloc(sizeof(double*)*(corpus->num_citing_docs));

    for (i = 0; i < corpus->num_citing_docs; i++)
	var_gamma[i] = (double*)malloc(sizeof(double)*model->num_topics);   


    int max_length = max_corpus_length(corpus);
    phi = (double**)malloc(sizeof(double*)*max_length);
    for (n = 0; n < max_length; n++)
      {
	phi[n] = (double*)malloc(sizeof(double) * model->num_topics);
      }



    int max_cite = max_citations(corpus);
    var_phi = (double**)malloc(sizeof(double*)*max_cite);
    for (n = 0; n < max_cite; n++)
	var_phi[n] = (double*)malloc(sizeof(double)*model->num_topics);

    double likelihood, citing_likelihood ,cited_likelihood, likelihood_old = 0, converged = 1;
    sprintf(filename, "%s/inf-likelihood.dat", directory);
    FILE* likelihood_file = fopen(filename, "w");
    fprintf(likelihood_file,"# cited_likelihood\tciting_likelihood\toverall_likelihood\tconvergence\n");

    i = 0;
    while (((converged < 0) || (converged > EM_CONVERGED) || (i <= 2)) && (i <= EM_MAX_ITER))
    {
        i++; printf("**** em iteration %d ****\n", i);
        likelihood = 0;
        cited_likelihood = 0;
        citing_likelihood = 0;
        zero_initialize_ss(ss, model);


        // e-step

	cited_likelihood+= cited_docs_e_step(corpus->cited_docs,model,ss);



        for (d = 0; d < corpus->num_citing_docs; d++)
        {
	  if ((d % 100) == 0) 
	      printf("document %d\n",d); 
	  //printf("var_gamma[d][0] %f\n",var_gamma[d][0]);
            citing_likelihood += citing_doc_e_step(&(corpus->citing_docs[d]),
                                     var_gamma[d],
                                     phi, var_phi,
                                     model,
                                     ss);
	    //printf("likelihood of document %d %10.10f\n",d,likelihood);
        }

        // m-step

        lda_mle_log_prob_k_d_only(model, ss);

        // check for convergence
        likelihood = citing_likelihood + cited_likelihood;
        converged = (likelihood_old - likelihood) / (likelihood_old);
        if (converged < 0) VAR_MAX_ITER = VAR_MAX_ITER * 2;
        likelihood_old = likelihood;

        // output model and likelihood

        fprintf(likelihood_file, "%10.10f\t%10.10f\t%10.10f\t%5.5e\n", cited_likelihood,citing_likelihood,likelihood, converged);
        fflush(likelihood_file);
    }
 
    // output the final model

    sprintf(filename,"%s/inf-final",directory);
    save_lda_model(model, filename);
    sprintf(filename,"%s/inf-final.gamma",directory);
    save_gamma(filename, var_gamma, corpus->num_citing_docs, model->num_topics);
    // output the word assignments (for visualization)

    /*
    sprintf(filename, "%s/word-assignments.dat", directory);
    FILE* w_asgn_file = fopen(filename, "w");
    for (d = 0; d < corpus->num_docs; d++)
    {
        if ((d % 100) == 0) printf("final e step document %d\n",d);
        likelihood += lda_inference(&(corpus->docs[d]), model, var_gamma[d], phi);
        write_word_assignment(w_asgn_file, &(corpus->docs[d]), phi, model);
    }
    fclose(w_asgn_file);
    */
    fclose(likelihood_file);

}




void predict(char* model_root, char* save, corpus* corpus)
{
  FILE* fileptr;
  FILE* p_fileptr;
  char filename[100],predict_filename[100];
  int i, d,k, n, curr_cite_ind = 0;
  lda_model *model;
  double **var_gamma, likelihood, **phi, var_gamma_sum,p_d;
  citing_document* doc;
    
  sprintf(filename, "%s-lda-lhood.dat", save);
  sprintf(predict_filename, "%s-predictions.dat", save);
  model = load_lda_model(model_root);
  var_gamma = (double**)malloc(sizeof(double*)*(corpus->num_citing_docs));
  for (i = 0; i < corpus->num_citing_docs; i++)
    var_gamma[i] = (double*)malloc(sizeof(double)*model->num_topics);
  
  fileptr = fopen(filename, "w");
  p_fileptr = fopen(predict_filename, "w");
  for (d = 0; d < corpus->num_citing_docs; d++)
    {
      if ((d % 100) == 0) printf("document %d\n",d);

      doc = &(corpus->citing_docs[d]);
      if(doc->num_citations > 0)
	curr_cite_ind = 0;
      else
	curr_cite_ind = -1;

      phi = (double**) malloc(sizeof(double*) * doc->length);
      for (n = 0; n < doc->length; n++)
	phi[n] = (double*) malloc(sizeof(double) * model->num_topics);
      likelihood = lda_inference_citing_text_only(doc, model, var_gamma[d], phi);
      var_gamma_sum = 0;
      for(k = 0; k < model->num_topics;k++)
	var_gamma_sum += var_gamma[d][k];
      for(i = 0; i < model->num_cited_docs; i++)
	{
	  p_d = model->log_prob_d[0][i] + log(var_gamma[d][0]/var_gamma_sum);
	  for(k = 1; k< model->num_topics;k++)
	    p_d = log_sum(p_d, (model->log_prob_d[k][i] + log(var_gamma[d][k]/var_gamma_sum)));
	  if(curr_cite_ind >= 0)
	    {
	      if(i < doc->citations[curr_cite_ind])
		fprintf(p_fileptr, "%3d 0 %5.5f\n",d,p_d);
	      else// i equals the current citation 
		{
		  fprintf(p_fileptr, "%3d 1 %5.5f\n",d,p_d);
		  if(curr_cite_ind < doc->num_citations-1)
		    curr_cite_ind++;
		  else
		    curr_cite_ind = -1;
		}
	    }
	  else
	    {
	      fprintf(p_fileptr, "%3d 0 %5.5f\n",d,p_d);
	    }
	    
	}
      for(n = 0; n < doc->length;n++)
	free(phi[n]);
      free(phi);
      fprintf(fileptr, "%5.5f\n", likelihood);
    }
  fclose(fileptr);
  fclose(p_fileptr);
  sprintf(filename, "%s-gamma.dat", save);
  save_gamma(filename, var_gamma, corpus->num_citing_docs, model->num_topics);
}


/*
 * update sufficient statistics
 *
 */



/*
 * main
 *
 */

int main(int argc, char* argv[])
{
    // (est / inf) alpha k settings data (random / seed/ model) (directory / out)

    corpus* corpus;

    seedMT(4357U);
    if (argc > 1)
    {
        if (strcmp(argv[1], "est")==0)
        {
            INITIAL_ALPHA = atof(argv[2]);
            NTOPICS = atoi(argv[3]);
            read_settings(argv[4]);
            corpus = read_full_data(argv[5],argv[6],argv[7]);
            make_directory(argv[9]);
            run_em(argv[8], argv[9], corpus);
        }
        else if(strcmp(argv[1], "inf_new_corpus")==0)
        {
           read_settings(argv[2]);
           corpus = read_full_data(argv[4],argv[5],argv[6]);
           infer_new_corpus(argv[3], argv[7], corpus);
           
        }
        else if (strcmp(argv[1], "inf")==0)
        {
	  read_settings(argv[2]);
	  corpus = read_citing_data(argv[4],argv[5]);	  
	  infer(argv[3], argv[6], corpus);
        }
	else if (strcmp(argv[1], "pdt")==0)
        {
	  read_settings(argv[2]);
	  corpus = read_citing_data(argv[4],argv[5]); //correct argv[6] later
	  predict(argv[3], argv[6], corpus);
        }	
    }
    else
    {
        printf("usage : lda est [initial alpha] [k] [settings] [cited_data] [citing_data] [citations] [random/seeded/*] [directory]\n");
        printf("        lda inf_new_corpus [settings] [model_root] [cited_data] [citing_data] [citations] [out_dir]\n");
        printf("        lda inf [settings] [model] [citing_data] [citations] [name]\n");
	printf("        lda pdt [settings] [model] [citing_data] [citations] [name]\n");
    }
    return(0);
}
