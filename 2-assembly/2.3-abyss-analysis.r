library("dplyr")
library("ggplot2")
library("viridis")
library("gridExtra")

#you must set the wdir where you saved all the scaffold stats txt files previously created
#be careful that those are the only txt files there

filelist <- list.files(pattern = "*txt")
datalist <-  lapply(filelist, function(x) read.table(x, header=T))
df <-  do.call("rbind", datalist)
names(df)[names(df)=="n.500"] <- "n"


#this may be sensitive to the names specified for the assembly
##########
clean_df <- df %>%  mutate(cov=factor(gsub("_.*","",gsub("^([^_]*[^_]_)", "",name)),levels = c("10X","50X","100X","200X","500X","max")), k=factor(gsub("([0-9]+).*$", "\\1",gsub(".*k","",name)))) %>% select(-c(name)) %>%  arrange(cov,k) %>% filter(cov!="10X")

p1 <- ggplot(clean_df, aes(x=cov,y=N50,fill=k)) +
    geom_bar(stat = "identity",width = .8, position = "dodge", colour="black",show.legend = F) +
    theme(legend.position = "bottom") +
    scale_fill_viridis(discrete = T) +
    theme_linedraw() +
    ggtitle("N50") +
    theme(axis.text = element_text(size=10, family = "helvetica"), axis.title.x = element_blank(), axis.title.y = element_blank(), plot.title = element_text(size = 14 ))

p2 <- ggplot(clean_df, aes(x=cov,y=sum,fill=k)) +
    geom_bar(stat = "identity",width = .8, position = "dodge",show.legend = F, colour="black") +
    scale_fill_viridis(discrete = T) +
    theme_linedraw() +
    ggtitle("Total length") +
    theme(axis.text = element_text(size=10, family = "helvetica"), axis.title.x = element_blank(), axis.title.y = element_blank(), plot.title = element_text(size = 14 ))

p3 <- ggplot(clean_df, aes(x=cov,y=n,fill=k)) +
    geom_bar(stat = "identity",width = .8, position = "dodge",show.legend = T, colour="black") +
    scale_fill_viridis(discrete = T) +
    scale_y_continuous(breaks = c(2,4,6,8)) +
    theme_linedraw() +
    ggtitle("Number of contigs") +
    theme(legend.position = c(.37,.93), legend.direction =  "horizontal" ,legend.background = element_rect(fill = "transparent"),axis.text = element_text(size=10, family = "helvetica"), axis.title.x = element_blank(), axis.title.y = element_blank(), plot.title = element_text(size = 14 ))

p4 <- grid.arrange(p3,p1,p2, nrow=1)
ggsave("abyss-analysis-plot", p4, device = "png", dpi = 320, width = 15.67 , height = 8.04)
