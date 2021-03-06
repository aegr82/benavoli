#' @title Projection of 3-simplex points
#'
#' @export
#' @description This function projects 3-simplex points to a 2D triangle
#' @param points Simplex points to be projected
#' @param num.points Number of points to be shown
#' @examples
#' bs <- bayesianSign.test(results$random.forest, results$KNN)
#' plotSimplex(bs$sample, num.points = 5000)
#'
#' bsr <- bayesianSignedRank.test(results$random.forest, results$KNN)
#' plotSimplex(bsr$sample, num.points = 5000)
plotSimplex <- function(points, num.points = nrow(points), names=c("PFGA","PBC4cip"), dataset="Breast-cancer"){

if(num.points > nrow(points))
	num.points = nrow(points)

subset <- points[sample(nrow(points), num.points), ]

L <- subset[ ,1]
Rope <- subset[ ,2]
R <- subset[ ,3]

df.points <- data.frame("L" = L, "rope" = Rope, "R" = R, "d" = grDevices::densCols(subset, colramp = grDevices::colorRampPalette(grDevices::topo.colors(20))))

lines <- data.frame(x = c(0.5, 0, 0.5), y = c(0, 0.5, 0.5), z = c(0.5, 0.5, 0), xend = c(1,1,1)/3, yend = c(1,1,1)/3, zend = c(1,1,1)/3)

borders <- data.frame(x = c(1,0,0), y=c(0,1,0), z=c(0,0,1), xend = c(0,1,0), yend=c(0,0,1), zend=c(1,0,0))

suppressWarnings(ggtern::ggtern(data = df.points, ggtern::aes(L, Rope, R)) + ggplot2::geom_point(color = df.points$d) + ggplot2::geom_segment(data = lines, ggtern::aes(x = c(0.5, 0, 0.5), y = c(0, 0.5, 0.5), z = c(0.5, 0.5, 0), xend = c(1,1,1)/3, yend = c(1,1,1)/3, zend = c(1,1,1)/3), color = 'orange', size = 0.5) + ggplot2::geom_segment(data = borders, ggtern::aes(x = c(1,0,0), y=c(0,1,0), z=c(0,0,1), xend = c(0,1,0), yend=c(0,0,1), zend=c(1,0,0)), color = 'orange', size = 1) + ggplot2::xlab(names[2]) + ggplot2::labs(z = names[1]) + ggplot2::ggtitle(dataset) + ggplot2::theme(plot.title = element_text(hjust = 0.5)))

}

#' @title Plot of posterior distribution
#'
#' @export
#' @description This function plots the posterior distribution of the parameter
#' @param data Data for plotting
#' @param names Names of the algorithms
#' @param dataset Names of the dataset
#' @examples
#' cbt <- correlatedBayesianT.test(results.rf[1, ], results.knn[1, ])
#' plotPosterior(cbt, names = c("Random Forest", "KNN"), dataset = "abalone")
plotPosterior <- function (data, names, dataset) {
    
    ggplot2::qplot(data$dist$x, data$dist$y, geom = "line") +
        ggplot2::ggtitle(paste(dataset, "\n", names[1], "vs.", names[2])) +
        ggplot2::theme(plot.title = element_text(hjust = 0.5)) +
        ggplot2::xlab("Difference") +
        ggplot2::ylab("Value") +
        ggplot2::geom_area(ggplot2::aes(fill="distribution"), fill = "lightblue") +
        ggplot2::geom_line(color="darkblue") +
        ggplot2::geom_vline(xintercept = data$rope[1], color = "orange") +
        ggplot2::geom_vline(xintercept = data$rope[2], color = "orange") +
        ggplot2::geom_segment(data = data.frame(x = data$rope[1], y = 0, data$rope[2], yend = 0),
                              ggplot2::aes(x = data$rope[1], y = 0, xend=data$rope[2], yend = 0),
                              color = "orange")
    
}
