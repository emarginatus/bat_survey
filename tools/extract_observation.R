library(dplyr)
library(tidyr)
library(digest)
library(tuneR)

setwd("~/thierry.onkelinx@inbo.be/persoonlijk/opnames/provinciaal_domein_huizingen/20170525")
files <- list.files(recursive = TRUE, pattern = ".WAV$")
hash <- sapply(
  files,
  function(wav){
    tmp <- readWave(wav)
    sha1(
      list(
        left = tmp@left,
        right = tmp@right,
        stereo = tmp@stereo,
        samp.rate = tmp@samp.rate,
        bit = tmp@bit,
        pcm = tmp@pcm
      )
    )
  }
)
observation <- data.frame(
  id = hash,
  filename = files,
  time = file.info(files)$mtime
) %>%
  mutate(
    detector = gsub("^(.*)/(.*)/(.*)$", "\\1", filename),
    species = gsub("^(.*)/(.*)/(.*)$", "\\2", filename),
    filename = gsub("^(.*)/(.*)/(.*)$", "\\3", filename),
    species = gsub("ruis", "noise", species) %>%
      gsub(pattern = "controle", replacement = "check") %>%
      strsplit(split = "_")
  ) %>%
  unnest(species)
setwd("/home/thierry_onkelinx/thierry.onkelinx@inbo.be/github/persoonlijk/bat_survey/")
observation %>%
  select(id, species) %>%
  arrange(id, species) %>%
  write.table(file = "observation_species.txt", sep = "\t", row.names = FALSE)
observation %>%
  distinct(id, detector, filename, time) %>%
  arrange(time) %>%
  write.table(file = "observation.txt", sep = "\t", row.names = FALSE)
