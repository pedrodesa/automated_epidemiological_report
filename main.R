if (!require(pacman)) install.packages("pacman")
pacman::p_load(shiny)

shiny::runApp("./app.R")
