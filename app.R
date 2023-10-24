ui <- fluidPage(
  titlePanel("Processo de Renderização e Movimentação de Arquivo"),
  actionButton("startButton", "Iniciar Processo"),
  textOutput("status")
)

server <- function(input, output) {
  observeEvent(input$startButton, {
    output$status <- renderText({
      # Verifica se o pacote "quarto" está instalado; se não estiver, instala o pacote
      if (!requireNamespace("quarto", quietly = TRUE)) {
        pacman::p_load(quarto)
      }
      
      if (!require(pacman)) install.packages("pacman")
      pacman::p_load(shiny)
      
      PATH_SRC <- file.path(".", "src/boletim_epidemiologico.qmd")
      Data <- format(Sys.Date(), "%Y-%m-%d")
      arquivo_word <- paste("doc_", ".docx", sep = Data)
      
      # Renderiza o arquivo QMD para DOCX
      quarto::quarto_render(input = PATH_SRC, output_file = arquivo_word)
      
      PATH_OUTPUT <- file.path(".", "output/")
      
      # Verifica se a pasta "output" existe, e se não, a cria
      if (!file.exists(PATH_OUTPUT)) {
        dir.create(PATH_OUTPUT)
      }
      
      novo_path_arquivo_word <- file.path(PATH_OUTPUT, basename(arquivo_word))
      
      # Move o arquivo docx para a pasta "output"
      file.rename(arquivo_word, novo_path_arquivo_word)
      
      # Verifica se o arquivo foi movido com sucesso
      if (file.exists(novo_path_arquivo_word)) {
        return("Arquivo movido com sucesso para a pasta 'output'.")
      } else {
        return("Erro ao mover o arquivo.")
      }
      
      #####
      # Especifique os caminhos completos para as pastas de origem e destino
      caminho_src_pasta = paste("./src/Saidas_", "/", sep = Data)
      
      # Move a pasta "src" para o diretório "output"
      if (file.path(caminho_src_pasta, file.copy(from = folder_old_path, to = path_new, 
                                                 overwrite = recursive, recursive = FALSE, copy.mode = TRUE))) {
        cat("Pasta 'src' movida com sucesso para a pasta 'output'.\n")
      } else {
        cat("Erro ao mover a pasta 'src' para a pasta 'output'.\n")
      }
      
      
    })
  })
}

shinyApp(ui, server)
