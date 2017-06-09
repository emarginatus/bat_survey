library(rgdal)
library(rmarkdown)
studyareas <- readOGR("studyarea.geojson", verbose = FALSE)
for (i in seq_along(studyareas$id)) {
  render(
    "fieldnotes.Rmd",
    output_file = paste0(
      "fieldnotes_",
      gsub(" ", "_", studyareas$name[i]),
      ".pdf"
    ),
    output_dir = "site",
    params = list(studyarea = studyareas$id[i])
  )
}
