#!/bin/csh
set K = 60
set LDA = "/user/nmramesh/scr/Link_PLSA_LDA"
set TRAIN = "/user/nmramesh/scr/topicflow/cora/train4link_plsa_lda/"
set TEST = "/user/nmramesh/scr/topicflow/cora/test4link_plsa_lda/"
set OUT = "/user/nmramesh/scr/topicflow/cora/runs/link_plsa_lda/k"${K}

${LDA}/lda est 0.1 ${K} ${LDA}/settings.txt ${TRAIN}/citedDocs.txt ${TRAIN}/citingDocs.txt ${TRAIN}/citations.txt seeded $OUT
${LDA}/lda inf_new_corpus ${LDA}/settings.txt ${OUT}/final ${TEST}/citedDocs.txt ${TEST}/citingDocs.txt ${TEST}/citations.txt ${OUT}
${LDA}/lda pdt ${LDA}/settings.txt ${OUT}/final ${TRAIN}/citing_docs.txt ${TRAIN}/citations.txt ${OUT}/pdt
