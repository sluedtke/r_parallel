
library(tidyverse)


# dompi inorder = TRUE -------------------------------------------------------
dompi_inorder_T <- readRDS("./dompi_inorder_T.rds")

#----------------------------------------------------------------------------
# calculate relative start and end time for the tasks
dompi_inorder_T$rel_start <- dompi_inorder_T$mpi_start_time - min(dompi_inorder_T$mpi_start_time)
dompi_inorder_T$rel_end <- dompi_inorder_T$rel_start + dompi_inorder_T$mpi_end_time - dompi_inorder_T$mpi_start_time

# prepare the long format table for plotting
dompi_inorder_T <- dompi_inorder_T %>%
    dplyr::select(mpi_rank, mpi_task_id, mpi_host, mpi_processing_time,
                  contains("rel_start"), contains("rel_end")) %>%
    dplyr::arrange(rel_start) %>%
    tidyr::gather(key, mpi_time, -mpi_rank, -mpi_host, -mpi_task_id,
                  -mpi_processing_time) %>%
    dplyr::mutate(mpi_rank = as.factor(mpi_rank)) %>%
    dplyr::mutate(mpi_time = as.numeric(mpi_time))
# plot results for dompi_inorder_T
dompi_inorder_T_plot = ggplot(dompi_inorder_T, aes(y = mpi_rank, x = mpi_time)) +
  geom_line(size = 15, aes(color = mpi_processing_time, group = mpi_rank)) +
  geom_label(data = dompi_inorder_T[dompi_inorder_T$key == "rel_start", ],
            size = 6, hjust = -.1,
            aes(label = mpi_task_id)) +
  ylab("CPU # ") +
  xlab("elapsed time") +
  ggtitle("dompi_inorder_T") +
  theme(legend.position = "bottom",
        legend.text = element_text(size = 12),
        text = element_text(size = 25),
        axis.ticks.length = unit(0.5, "cm")) +
  labs(color = "processing time") +
  scale_colour_gradient(low = "blue", high = "red")

ggsave(plot = dompi_inorder_T_plot, "./dompi_inorder_T.png")

# dompi inorder = FALSE -------------------------------------------------------

dompi_inorder_F <- readRDS("./dompi_inorder_F.rds")
# calculate relative start and end time for the tasks
dompi_inorder_F$rel_start <- dompi_inorder_F$mpi_start_time - min(dompi_inorder_F$mpi_start_time)
dompi_inorder_F$rel_end <- dompi_inorder_F$rel_start + dompi_inorder_F$mpi_end_time - dompi_inorder_F$mpi_start_time

# prepare the long format table for plotting
dompi_inorder_F <- dompi_inorder_F %>%
    dplyr::select(mpi_rank, mpi_task_id, mpi_host, mpi_processing_time,
                  contains("rel_start"), contains("rel_end")) %>%
    dplyr::arrange(rel_start) %>%
    tidyr::gather(key, mpi_time, -mpi_rank, -mpi_host, -mpi_task_id,
                  -mpi_processing_time) %>%
    dplyr::mutate(mpi_rank = as.factor(mpi_rank)) %>%
    dplyr::mutate(mpi_time = as.numeric(mpi_time))
# plot results for dompi_inorder_F
dompi_inorder_F_plot = ggplot(dompi_inorder_F, aes(y = mpi_rank, x = mpi_time)) +
  geom_line(size = 15, aes(color = mpi_processing_time, group = mpi_rank)) +
  geom_label(data = dompi_inorder_F[dompi_inorder_F$key == "rel_start", ],
            size = 6, hjust = -.1,
            aes(label = mpi_task_id)) +
  ylab("CPU # ") +
  xlab("elapsed time") +
  ggtitle("dompi_inorder_F") +
  theme(legend.position = "bottom",
        legend.text = element_text(size = 12),
        text = element_text(size = 25),
        axis.ticks.length = unit(0.5, "cm")) +
  labs(color = "processing time") +
  scale_colour_gradient(low = "blue", high = "red")

ggsave(plot = dompi_inorder_F_plot, "./dompi_inorder_F.png")

### rmpi results --------------------------------------------------------------
rmpi_results <- readRDS("./rmpi_results.rds")

rmpi_results$rel_start <- rmpi_results$mpi_start_time - min(rmpi_results$mpi_start_time)
rmpi_results$rel_end <- rmpi_results$rel_start +rmpi_results$mpi_end_time - rmpi_results$mpi_start_time

rmpi_results <- rmpi_results %>%
    dplyr::select(mpi_rank, mpi_task_id, mpi_host, mpi_processing_time,
                  contains("rel_start"), contains("rel_end")) %>%
    dplyr::arrange(rel_start) %>%
    dplyr::mutate(mpi_task_id = as.factor(1:nrow(rmpi_results))) %>%
    tidyr::gather(key, mpi_time, -mpi_rank, -mpi_host, -mpi_task_id,
                  -mpi_processing_time) %>%
    dplyr::mutate(mpi_rank = as.factor(mpi_rank)) %>%
    dplyr::mutate(mpi_time = as.numeric(mpi_time))

rmpi_results_plot = ggplot(rmpi_results, aes(y = mpi_rank, x = mpi_time)) +
  geom_line(size = 15, aes(color = mpi_processing_time, group = mpi_rank)) +
  geom_label(data = rmpi_results[rmpi_results$key == "rel_start", ],
            size = 6, hjust = -.1,
            aes(label = mpi_task_id)) +
  ylab("CPU # ") +
  xlab("elapsed time") +
  ggtitle("rmpi") +
  theme(legend.position = "bottom",
        legend.text = element_text(size = 12),
        text = element_text(size = 25),
        axis.ticks.length = unit(0.5, "cm")) +
  labs(color = "processing time") +
  scale_colour_gradient(low = "blue", high = "red")


ggsave(plot = rmpi_results_plot, "./rmpi_results.png")
