function [l c] = skmeans(x, k)
[l c] = kmeans(x, k, 'emptyaction' ,'drop');