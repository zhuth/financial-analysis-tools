@echo off
set K=5
set LDA=C:\Users\ZTH\Desktop\Link_PLSA_LDA
set TRAIN=%LDA%\sample_data
set TEST=%LDA%\sample_data
set OUT=%LDA%\sample_data\out_%K%

@echo on
%LDA%\link_plsa_lda est 0.1 %K% %LDA%\settings.txt %TRAIN%\citedDocs.txt %TRAIN%\citingDocs.txt %TRAIN%\citations.txt seeded %OUT%
%LDA%\link_plsa_lda inf_new_corpus %LDA%\settings.txt %OUT%\final %TEST%\citedDocs.txt %TEST%\citingDocs.txt %TEST%\citations.txt %OUT%
%LDA%\link_plsa_lda pdt %LDA%\settings.txt %OUT%\final %TRAIN%\citing_docs.txt %TRAIN%\citations.txt %OUT%\pdt
