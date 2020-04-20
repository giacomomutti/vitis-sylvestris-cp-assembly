library("ggplot2")

#setwd where is txt file produced in previous step

Covbed <- read.delim(file.txt, header=FALSE)
Covbed <- Covbed[-1]
colnames(Covbed) <- c("Position", "Read_Depth")

p1 <- ggplot(Covbed, aes(x = Position, y = Read_Depth)) +
    geom_line(color="#69b3a2") +
    theme_linedraw() +
    ggtitle("Total coverage of the assembly") +
    ylab("Coverage")

ggsave("total-coverage", p1, device = "png", dpi = 320, width = 11)
