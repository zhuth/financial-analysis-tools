function plotLines(d)
axes1 = axes('FontSize',12);
box(axes1,'on');
hold(axes1,'all');
axis([2 20 0.3 0.65]);
plot(d(:,1), d(:,2), '--', d(:,1), d(:,3), '*-', d(:,1), d(:,4), 'x-', d(:,1), d(:,5), '+-', d(:,1), d(:,6), 'LineWidth',2);
legend('Expert', 'LDA+LDA', 'LDA+Kmeans', 'Kmeans+Kmeans', 'NMF+KMeans');
%legend('boxoff'); legend('Orientation','horizontal');