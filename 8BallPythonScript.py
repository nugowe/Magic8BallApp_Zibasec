#!/usr/bin/env /root/.local/share/r-miniconda/envs/r-reticulate/bin/python




import pandas as pd
import numpy as nd
import glob
import os


#Declared Path for Storing Data for our Magic 8Ball App
path = '/home/shiny/responses2'                     

#Search the Path for csv files
all_files = glob.glob(os.path.join(path, "*.csv"))   


#Running a loop and concatenating across all files discovered
df_from_each_file = (pd.read_csv(f) for f in all_files)
concatenated_df   = pd.concat(df_from_each_file, ignore_index=True)
concatenated_df = pd.DataFrame(concatenated_df)



#Sorting out the Submitted Questions in an descending order using the variable 'timestamp_answer'
ArrangedQA = concatenated_df.sort_values(['timestamp_answer'], ascending = [False])


#Selecting our desired Columns for the Answers Variable
Answers = concatenated_df[["answer", "answertype","timestamp_answer"]]

#Selecting our desired Columns for the Questions Variable
Questions = concatenated_df[["question", "timestamp"]]

#Dropping null values
Answers.dropna()
Questions.dropna()

#Sorting out both variables by their timestamps in a descending order
ArrangedQuestions = Questions.sort_values(['timestamp'], ascending = [False])
ArrangedAnswers = Answers.sort_values(['timestamp_answer'], ascending = [False])

#Droping null values
ArrangedQuestions = ArrangedQuestions.dropna()
ArrangedAnswers = ArrangedAnswers.dropna()

#selecting our desired columns
ArrangedAnswers = ArrangedAnswers[["answer","answertype"]]
ArrangedQuestions = ArrangedQuestions[["question"]]

#preventing incremental indexes
ArrangedQuestions = ArrangedQuestions.reset_index(drop = True)
ArrangedAnswers = ArrangedAnswers.reset_index(drop = True)

#Merging both Question & Answer variables 
QAFinal = pd.concat([ArrangedQuestions, ArrangedAnswers], axis = 1)

#filtering for the latest three rows
QAFinal = QAFinal.head(3)
print(QAFinal)
