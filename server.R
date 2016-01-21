shinyServer(function(input, output) {
    library(caret)
    library(randomForest)
    library(nnet)
    library(e1071)
    
    red <- read.csv('http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv', header = TRUE, sep = ';')
    white <- read.csv('http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv', header = TRUE, sep = ';')
    red[, 'color'] <- 'red'
    white[, 'color'] <- 'white'
    df <- rbind(red, white)
    df$color <- as.factor(df$color)
    
    good_qual <- df$quality >= 6
    bad_qual <- df$quality < 6
    df[good_qual, 'quality'] <- 'good'
    df[bad_qual, 'quality'] <- 'bad'  
    df$quality <- as.factor(df$quality)
    
    ## Change problem to binary classification
    dummies <- dummyVars(quality ~ ., data = df)
    df_dummied <- data.frame(predict(dummies, newdata = df))
    df_dummied[, 'quality'] <- df$quality
    
## Exploratory Data Analysis ============================================
    output$f_plot <- renderPlot({
        numericColumns <- !colnames(df_dummied) %in% c('quality', 'color.red', 'color.white')
        feat_normalized <- preProcess(df_dummied[, numericColumns], method = 'range')
        feat_plot <- predict(feat_normalized, df_dummied[, numericColumns])
        featurePlot(feat_plot, df_dummied$quality, 'box')
    })
    
## Data Set ================================================================
    output$table <- renderDataTable({
        df_dummied
    })
## Random Forest ==========================================================
    output$confMatrix<- renderPrint({
        trainIndices <- createDataPartition(df_dummied$quality, p=input$fraction, list = FALSE)
        train <- df_dummied[trainIndices, ]
        test <- df_dummied[-trainIndices, ]
        
        features <- colnames(df_dummied)[1:13]
        
        fit_rf <- randomForest(x = train[, features], y = train$quality, 
                               ntree = input$ntree, importance=TRUE)
        predict_rf <- predict(fit_rf, newdata = test[, features])
        confMat_rf <- confusionMatrix(predict_rf, test$quality, positive = 'good')
        
        confMat_rf
    }) 
    
    output$i_plot <- renderPlot({
        trainIndices <- createDataPartition(df_dummied$quality, p=input$fraction, list = FALSE)
        train <- df_dummied[trainIndices, ]
        test <- df_dummied[-trainIndices, ]
        
        features <- colnames(df_dummied)[1:13]
        
        fit_rf <- randomForest(x = train[, features], y = train$quality, 
                               ntree = input$ntree, importance=TRUE)
        varImpPlot(fit_rf, type = 2, main = 'Feature Importance')
    }) 
})

