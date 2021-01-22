#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Setting our working directory
setwd("/srv/shiny-server")

#Loading our R libraries...

library(shiny)
library(shinythemes)
library(shinypop)
library(shinyWidgets)
library(reticulate)
library(glue)
library(DT)
library(dplyr)
library(magrittr)



#Initializing our python3 interpreter...

use_python("/root/.local/share/r-miniconda/envs/r-reticulate/bin/python")


#Importing our Python libraries...
pd <- import("pandas")
nd <- import("numpy")
os <- import("os")
glob <- import("glob")
time <- import("time")
datetime <-  import("datetime")
requests <- import("requests")
json <- import("json")


#Defining our storage location for Questions and Answers
path = '/home/shiny/responses2'

##########################################################################################################################################################################################################################################

##########################################################################USER INTERFACE SECTION###############################################################################################################

# Using the Cyborg (Dark Theme)
ui <- fluidPage(theme = shinytheme("cyborg"),
                # Confirmation message function for successful data submissions.        
                use_notiflix_report(),
                #Warning message function for data entry not captured
                use_notiflix_notify(position = "right-bottom"),
                titlePanel( HTML('<center>Magic Eight Ball</center>')),            
                HTML('<center><img src="8Ball.png"></center>'),
                
                hr(),
                fluidRow(textInput("question", "Ask the Magic 8-ball a question!",""), align = "center"), 
                fluidRow(h5('Output of the most recent click', width = 4), align = "center"),
                fluidRow(
                  align = "center",
                  actionButton("YesNo", "Kindly enter a Yes or No answer above....", class = "btn-danger", icon = icon("smile"), style = 'padding:20px; font-size:100%', width = "20%"),
                ),
                hr(),
                
                use_notiflix_notify(position = "right-bottom"),
                fluidRow(actionButton("submit", "Shake the Magic 8-ball", class = "btn-danger", icon = icon("bowling-ball"), style = 'padding:20px; font-size:100%', width = "20%"), align = "center"),
                hr(),
                fluidRow(
                  
                  verbatimTextOutput('eightballanswers'), align = "center"),
                fluidRow(dataTableOutput('historyofluck'),align = "center"), 
                
                fluidRow(
                  
                  
                  pickerInput(
                    inputId = "luck",
                    label = h5("History of luck", width = 4),
                    choices = c("Output of First Click","Output of Second Click","Output of Third Click"),
                    options = list(
                      style = "btn-danger")
                  ),
                  align = "center",
                  style = 'padding:20px; font-size:100%', width = "20%"
                ),
                
                
)


#########################################################################################################################################################################################################################################

#####################################################################################SERVER PORTION OF CODE############################################################################################


server <- function(input, output) {
  
  #Observe Function that throws an error if no Question is sent upon hitting the Shake the Magic Ball button
  observeEvent(input$submit, {
    if (nchar(input$question) == 0) {
      nx_notify_error("Oops... Kindly type in a question!")
    }
  })
  
  
  
  
  #Collecting our Question | Defining Path Variables | Unix Time (To capture time delivery of the Questions and rank them accordingly.)
  fieldsAll <- c("question")
  responsesDir <- file.path("/home/shiny/responses2")
  epochTime <- function() {
    as.integer(Sys.time())
  }
  
  
  # Applying our Dataset R Input Sources in to a list | Creating our Questions csv Columns | Transposing the Dataframe       
  formData <- reactive({
    data <- sapply(fieldsAll, function(x) input[[x]])
    data <- c(data, timestamp = epochTime())
    data <- t(data)
    data
  })
  
  
  #Appending  timestamp to the csv filename | writing the csv file to our Path Directory.
  humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")
  
  saveData <- function(data) {
    fileName <- sprintf("%s_%s.csv",
                        humanTime(),
                        digest::digest(data))
    
    
    
    write.csv(x = data, file = file.path(responsesDir, fileName),
              row.names = FALSE, quote = TRUE)
    
  }
  
  
  
  #Observe Function that runs each time the Shake Magic Ball Button is hit| It Runs the message shown below
  observeEvent(input$submit, {
    req(input$question)
    saveData(formData())
    nx_report_success("Done!", HTML('<center>Ask another question!</center>'))
    
  })
  
  
  
  
  
  #Observe Function monitoring the Shake the Magic 8 Ball button (input$submit)
  
  observeEvent(input$submit, {
    # Requirement for a  data entry for the 
    req(input$question)
    
    
    # Magic 8 Ball API | PYTHON CODE
    Sys.sleep(1)
    
    EightBallQA = requests$get("https://8ball.delegator.com/magic/JSON/glue(question)")
    
    
    
    EightBallQA = EightBallQA$text
    
    EightBallQA = json$loads(EightBallQA)
    
    answer = EightBallQA$magic[2]
    answertype = EightBallQA$magic[3]
    
    #Timestamp to order the sequence in which answers are returned from the API
    timestamp_answer = (time$time()*1000)
    
    
    #Column binding the answer, answertype and timestamp_answer columns
    answerfinal = cbind(answer, answertype, timestamp_answer)
    
    #Writing the answers to a csv file| appending the current time to the csv filename
    write.csv(answerfinal, file = paste0("/home/shiny/responses2/", "answersfinal", Sys.time(), ".csv"))
    
    
    
    #If Statements for the History of Answers DataTable | Defined in a Reactive Function | The Datatable library is used to produce the Table and its corresponding CSS Elements | Each Data Input Source is defined.
    
    HistoryClicks <- reactive({   
      if(input$luck == "Output of First Click"){
        QAFinal1 <- QAFinal %>% slice(1)
        
        bb <- DT::datatable(QAFinal1,  class = 'cell-border stripe', extensions = 'FixedColumns', options = list(pageLength = 3,dom = 't', scrollX = TRUE,fixedColumns = TRUE,
                                                                                                                 initComplete = JS(
                                                                                                                   "function(settings, json) {",
                                                                                                                   "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                                                                                                   "}")
        ))%>% formatStyle('question',  color = 'grey', backgroundColor = 'black')%>% formatStyle('answer',  color = 'grey', backgroundColor = 'black')%>% formatStyle('answertype',  color = 'grey', backgroundColor = 'black')
        
        
        
        return(bb)
      } else if(input$luck == "Output of Second Click"){
        QAFinal2 <- QAFinal %>% slice(2)
        bb <- DT::datatable(QAFinal2, class = 'cell-border stripe', options = list(pageLength = 3, dom = 't', scrollX = TRUE,fixedColumns = TRUE,
                                                                                   initComplete = JS(
                                                                                     "function(settings, json) {",
                                                                                     "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                                                                     "}")
        ))%>% formatStyle('question',  color = 'grey', backgroundColor = 'black')%>% formatStyle('answer',  color = 'grey', backgroundColor = 'black') %>% formatStyle('answertype',  color = 'grey', backgroundColor = 'black')
        return(bb)
        
      }else {
        QAFinal3 <- QAFinal %>% slice(3)
        bb <- DT::datatable(QAFinal3, class = 'cell-border stripe', options = list(pageLength = 3,dom = 't', scrollX = TRUE,fixedColumns = TRUE,
                                                                                   initComplete = JS(
                                                                                     "function(settings, json) {",
                                                                                     "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                                                                     "}")
        ))%>% formatStyle('question',  color = 'grey', backgroundColor = 'black')%>% formatStyle('answer',  color = 'grey', backgroundColor = 'black') %>% formatStyle('answertype',  color = 'grey', backgroundColor = 'black')
        return(bb)
      }
      
      
      
    })
    
    
    # The Output from the Reactive Function + Loop is rendered on the portion in the UI Interface defined.
    
    #Python Script is called to obtain wrangled datasets for consumption
    source_python("8BallPythonScript.py")
    
    QAFinal <- py$QAFinal
    
    print(QAFinal)
    
    output$historyofluck <- renderDataTable({
      
      HistoryClicks()
      
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    #This Reactive Function is defined to relay Answers to the UI Interface | The function is dependent on the Shake the EightBall Button(input$submit)
    
    text <- reactive({
      #Requires the input$submit to run this function
      req(input$submit)
      #Calling the python script for already wrangled data....
      source_python("8BallPythonScript.py")
      QAFinal <- py$QAFinal
      QA1 <- QAFinal %>% slice(1)
      QA2 <- QAFinal %>% slice(2)
      QA3 <- QAFinal %>% slice(3)
      ifelse(input$luck == "Output of First Click", return(QA1$answer),
             ifelse(input$luck == "Output of Second Click", return(QA2$answer),
                    ifelse(input$luck == "Output of Third Click", return(QA3$answer))))     
      
      
    })
    
    
    # The Reactive function is passed to the UI portion | Answers
    output$eightballanswers <- renderText({
      text()
    })
    
    
    
    
    
  })
  
  
  
  
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
