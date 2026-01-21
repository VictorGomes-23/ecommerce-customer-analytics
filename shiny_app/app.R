# ============================================================================
# E-COMMERCE CUSTOMER ANALYTICS DASHBOARD
# ============================================================================
# 
# Author: Victor Gomes
# Purpose: Interactive dashboard for customer analytics insights
# Data: Online Retail Dataset (UCI ML Repository)
#
# ============================================================================

# Load required libraries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(lubridate)
library(scales)
library(plotly)
library(DT)

# ============================================================================
# DATA LOADING
# ============================================================================

# Load data
transactions <- read_csv("data/retail_customers_only.csv", 
                         show_col_types = FALSE)
customer_rfm <- read_csv("data/customer_rfm_scored.csv",
                         show_col_types = FALSE)
churn_predictions <- read_csv("data/churn_predictions.csv",
                              show_col_types = FALSE)

# Prepare data for dashboard
transactions <- transactions %>%
  mutate(
    InvoiceDate = as.Date(InvoiceDate),
    YearMonth = floor_date(InvoiceDate, "month"),
    Revenue = TotalAmount
  ) %>%
  filter(!IsReturn)  # Exclude returns for cleaner metrics

# Date range for filters
min_date <- min(transactions$InvoiceDate, na.rm = TRUE)
max_date <- max(transactions$InvoiceDate, na.rm = TRUE)

# ============================================================================
# UI DEFINITION
# ============================================================================

ui <- dashboardPage(
  skin = "blue",
  
  # Dashboard Header
  dashboardHeader(
    title = "E-Commerce Analytics",
    titleWidth = 300
  ),
  
  # Dashboard Sidebar
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Customer Segments", tabName = "segments", icon = icon("users")),
      menuItem("Churn Analysis", tabName = "churn", icon = icon("user-times")),
      menuItem("Product Performance", tabName = "products", icon = icon("shopping-cart")),
      menuItem("Cohort Analysis", tabName = "cohorts", icon = icon("calendar"))
    ),
    
    # Global Filters
    hr(),
    h4("Filters", style = "padding-left: 15px; font-weight: bold;"),
    
    # Date range filter
    dateRangeInput(
      "date_range",
      "Date Range:",
      start = max_date - months(6),
      end = max_date,
      min = min_date,
      max = max_date,
      format = "yyyy-mm-dd"
    ),
    
    # Customer segment filter
    pickerInput(
      "segment_filter",
      "Customer Segments:",
      choices = c("All", unique(customer_rfm$Segment)),
      selected = "All",
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `selected-text-format` = "count > 3"
      )
    ),
    
    # Country filter
    pickerInput(
      "country_filter",
      "Countries:",
      choices = c("All", sort(unique(transactions$Country))),
      selected = "All",
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `selected-text-format` = "count > 3"
      )
    ),
    
    hr(),
    
    # Refresh button
    actionButton(
      "refresh",
      "Refresh Data",
      icon = icon("sync"),
      width = "90%",
      style = "margin-left: 15px;"
    )
  ),
  
  # Dashboard Body
  dashboardBody(
    # Custom CSS for styling
    tags$head(
      tags$style(HTML("
        .box.box-solid.box-primary > .box-header {
          background: #3c8dbc;
          color: #fff;
        }
        .small-box {
          border-radius: 5px;
        }
        .small-box h3 {
          font-size: 2.5em;
          font-weight: bold;
        }
        .content-wrapper {
          background-color: #ecf0f5;
        }
      "))
    ),
    
    tabItems(
      # ======================================================================
      # TAB 1: OVERVIEW
      # ======================================================================
      tabItem(
        tabName = "overview",
        
        h2("Business Overview", style = "font-weight: bold; margin-bottom: 20px;"),
        
        # KPI Boxes Row 1
        fluidRow(
          valueBoxOutput("total_revenue", width = 3),
          valueBoxOutput("total_customers", width = 3),
          valueBoxOutput("total_orders", width = 3),
          valueBoxOutput("avg_order_value", width = 3)
        ),
        
        # KPI Boxes Row 2
        fluidRow(
          valueBoxOutput("revenue_per_customer", width = 3),
          valueBoxOutput("conversion_rate", width = 3),
          valueBoxOutput("churn_rate", width = 3),
          valueBoxOutput("active_customers", width = 3)
        ),
        
        # Charts Row 1
        fluidRow(
          box(
            title = "Revenue Trend",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            plotlyOutput("revenue_trend", height = "300px")
          ),
          box(
            title = "Top 10 Products",
            status = "primary",
            solidHeader = TRUE,
            width = 4,
            plotlyOutput("top_products", height = "300px")
          )
        ),
        
        # Charts Row 2
        fluidRow(
          box(
            title = "Customer Distribution by Segment",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("segment_distribution", height = "300px")
          ),
          box(
            title = "Revenue by Country",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("country_revenue", height = "300px")
          )
        )
      ),
      
      # ======================================================================
      # TAB 2: CUSTOMER SEGMENTS
      # ======================================================================
      tabItem(
        tabName = "segments",
        
        h2("Customer Segmentation Analysis", style = "font-weight: bold; margin-bottom: 20px;"),
        
        fluidRow(
          box(
            title = "Segment Performance Summary",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("segment_table")
          )
        ),
        
        fluidRow(
          box(
            title = "RFM Score Distribution",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("rfm_distribution", height = "350px")
          ),
          box(
            title = "Segment Revenue Contribution",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("segment_revenue_pie", height = "350px")
          )
        ),
        
        fluidRow(
          box(
            title = "Customer Lifetime Value by Segment",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("clv_by_segment", height = "300px")
          )
        )
      ),
      
      # ======================================================================
      # TAB 3: CHURN ANALYSIS
      # ======================================================================
      tabItem(
        tabName = "churn",
        
        h2("Customer Churn Analysis", style = "font-weight: bold; margin-bottom: 20px;"),
        
        fluidRow(
          valueBoxOutput("high_risk_customers", width = 4),
          valueBoxOutput("revenue_at_risk", width = 4),
          valueBoxOutput("avg_churn_probability", width = 4)
        ),
        
        fluidRow(
          box(
            title = "Churn Risk Distribution",
            status = "danger",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("churn_risk_dist", height = "300px")
          ),
          box(
            title = "Risk Category Breakdown",
            status = "danger",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("risk_category_breakdown", height = "300px")
          )
        ),
        
        fluidRow(
          box(
            title = "High-Risk Customers (Top 20)",
            status = "danger",
            solidHeader = TRUE,
            width = 12,
            DTOutput("high_risk_table")
          )
        )
      ),
      
      # ======================================================================
      # TAB 4: PRODUCT PERFORMANCE
      # ======================================================================
      tabItem(
        tabName = "products",
        
        h2("Product Performance", style = "font-weight: bold; margin-bottom: 20px;"),
        
        fluidRow(
          valueBoxOutput("total_products", width = 3),
          valueBoxOutput("avg_product_revenue", width = 3),
          valueBoxOutput("top_product_revenue", width = 3),
          valueBoxOutput("total_units_sold", width = 3)
        ),
        
        fluidRow(
          box(
            title = "Top 20 Products by Revenue",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("top_products_revenue", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = "Product Performance Table",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            DTOutput("product_table")
          )
        )
      ),
      
      # ======================================================================
      # TAB 5: COHORT ANALYSIS
      # ======================================================================
      tabItem(
        tabName = "cohorts",
        
        h2("Cohort Retention Analysis", style = "font-weight: bold; margin-bottom: 20px;"),
        
        fluidRow(
          box(
            title = "Cohort Retention Heatmap",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("cohort_heatmap", height = "500px")
          )
        ),
        
        fluidRow(
          box(
            title = "Retention Rate by Cohort",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("retention_line", height = "300px")
          )
        )
      )
    )
  )
)

# ============================================================================
# SERVER LOGIC
# ============================================================================

server <- function(input, output, session) {
  
  # ==========================================================================
  # REACTIVE DATA FILTERING
  # ==========================================================================
  
  filtered_transactions <- reactive({
    data <- transactions %>%
      filter(
        InvoiceDate >= input$date_range[1],
        InvoiceDate <= input$date_range[2]
      )
    
    # Apply segment filter
    if (!"All" %in% input$segment_filter && length(input$segment_filter) > 0) {
      customer_ids <- customer_rfm %>%
        filter(Segment %in% input$segment_filter) %>%
        pull(CustomerID)
      data <- data %>% filter(CustomerID %in% customer_ids)
    }
    
    # Apply country filter
    if (!"All" %in% input$country_filter && length(input$country_filter) > 0) {
      data <- data %>% filter(Country %in% input$country_filter)
    }
    
    return(data)
  })
  
  filtered_customers <- reactive({
    customer_ids <- unique(filtered_transactions()$CustomerID)
    customer_rfm %>% filter(CustomerID %in% customer_ids)
  })
  
  filtered_churn <- reactive({
    customer_ids <- unique(filtered_transactions()$CustomerID)
    churn_predictions %>% filter(CustomerID %in% customer_ids)
  })
  
  # ==========================================================================
  # TAB 1: OVERVIEW - VALUE BOXES
  # ==========================================================================
  
  output$total_revenue <- renderValueBox({
    revenue <- sum(filtered_transactions()$Revenue, na.rm = TRUE)
    valueBox(
      value = paste0("£", format(round(revenue/1000, 1), big.mark = ","), "K"),
      subtitle = "Total Revenue",
      icon = icon("pound-sign"),
      color = "green"
    )
  })
  
  output$total_customers <- renderValueBox({
    customers <- n_distinct(filtered_transactions()$CustomerID)
    valueBox(
      value = format(customers, big.mark = ","),
      subtitle = "Total Customers",
      icon = icon("users"),
      color = "blue"
    )
  })
  
  output$total_orders <- renderValueBox({
    orders <- n_distinct(filtered_transactions()$InvoiceNo)
    valueBox(
      value = format(orders, big.mark = ","),
      subtitle = "Total Orders",
      icon = icon("shopping-cart"),
      color = "purple"
    )
  })
  
  output$avg_order_value <- renderValueBox({
    aov <- filtered_transactions() %>%
      group_by(InvoiceNo) %>%
      summarize(OrderValue = sum(Revenue), .groups = "drop") %>%
      summarize(AOV = mean(OrderValue)) %>%
      pull(AOV)
    
    valueBox(
      value = paste0("£", round(aov, 2)),
      subtitle = "Avg Order Value",
      icon = icon("credit-card"),
      color = "yellow"
    )
  })
  
  output$revenue_per_customer <- renderValueBox({
    rpc <- sum(filtered_transactions()$Revenue, na.rm = TRUE) / 
      n_distinct(filtered_transactions()$CustomerID)
    
    valueBox(
      value = paste0("£", format(round(rpc, 0), big.mark = ",")),
      subtitle = "Revenue per Customer",
      icon = icon("user-circle"),
      color = "teal"
    )
  })
  
  output$conversion_rate <- renderValueBox({
    # Simplified conversion rate calculation
    conv_rate <- (n_distinct(filtered_transactions()$InvoiceNo) / 
                    n_distinct(filtered_transactions()$CustomerID)) * 100
    
    valueBox(
      value = paste0(round(conv_rate, 1), "%"),
      subtitle = "Purchase Frequency",
      icon = icon("chart-line"),
      color = "orange"
    )
  })
  
  output$churn_rate <- renderValueBox({
    churn_rate <- mean(filtered_churn()$Churned, na.rm = TRUE) * 100
    
    valueBox(
      value = paste0(round(churn_rate, 1), "%"),
      subtitle = "Churn Rate",
      icon = icon("exclamation-triangle"),
      color = "red"
    )
  })
  
  output$active_customers <- renderValueBox({
    active <- sum(!filtered_churn()$Churned, na.rm = TRUE)
    
    valueBox(
      value = format(active, big.mark = ","),
      subtitle = "Active Customers",
      icon = icon("user-check"),
      color = "green"
    )
  })
  
  # ==========================================================================
  # TAB 1: OVERVIEW - CHARTS
  # ==========================================================================
  
  output$revenue_trend <- renderPlotly({
    data <- filtered_transactions() %>%
      group_by(YearMonth) %>%
      summarize(Revenue = sum(Revenue), .groups = "drop") %>%
      arrange(YearMonth)
    
    plot_ly(data, x = ~YearMonth, y = ~Revenue, type = "scatter", mode = "lines+markers",
            line = list(color = "#3c8dbc", width = 3),
            marker = list(size = 8, color = "#3c8dbc")) %>%
      layout(
        xaxis = list(title = "Month"),
        yaxis = list(title = "Revenue (£)", tickformat = ",.0f"),
        hovermode = "x unified"
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$top_products <- renderPlotly({
    data <- filtered_transactions() %>%
      group_by(Description) %>%
      summarize(Revenue = sum(Revenue), .groups = "drop") %>%
      arrange(desc(Revenue)) %>%
      head(10) %>%
      mutate(Description = str_trunc(Description, 30))
    
    plot_ly(data, x = ~Revenue, y = ~reorder(Description, Revenue),
            type = "bar", orientation = "h",
            marker = list(color = "#2ecc71")) %>%
      layout(
        xaxis = list(title = "Revenue (£)"),
        yaxis = list(title = ""),
        margin = list(l = 150)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$segment_distribution <- renderPlotly({
    data <- filtered_customers() %>%
      count(Segment) %>%
      arrange(desc(n))
    
    plot_ly(data, labels = ~Segment, values = ~n, type = "pie",
            textinfo = "label+percent",
            marker = list(colors = c("#e74c3c", "#f39c12", "#3498db", "#2ecc71", "#9b59b6"))) %>%
      layout(showlegend = TRUE) %>%
      config(displayModeBar = FALSE)
  })
  
  output$country_revenue <- renderPlotly({
    data <- filtered_transactions() %>%
      group_by(Country) %>%
      summarize(Revenue = sum(Revenue), .groups = "drop") %>%
      arrange(desc(Revenue)) %>%
      head(10)
    
    plot_ly(data, x = ~reorder(Country, Revenue), y = ~Revenue,
            type = "bar",
            marker = list(color = "#3498db")) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Revenue (£)", tickformat = ",.0f")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ==========================================================================
  # TAB 2: CUSTOMER SEGMENTS
  # ==========================================================================
  
  output$segment_table <- renderDT({
    data <- filtered_customers() %>%
      group_by(Segment) %>%
      summarize(
        Customers = n(),
        `Avg RFM Score` = round(mean(RFM_Total), 1),
        `Avg Total Spent` = round(mean(TotalSpent), 2),
        `Avg Transactions` = round(mean(TotalTransactions), 1),
        `Total Revenue` = sum(TotalSpent),
        .groups = "drop"
      ) %>%
      arrange(desc(`Total Revenue`))
    
    datatable(
      data,
      options = list(
        pageLength = 10,
        dom = "t",
        ordering = TRUE
      ),
      rownames = FALSE
    ) %>%
      formatCurrency(c("Avg Total Spent", "Total Revenue"), "£") %>%
      formatRound(c("Avg RFM Score", "Avg Transactions"), 1)
  })
  
  output$rfm_distribution <- renderPlotly({
    data <- filtered_customers()
    
    plot_ly() %>%
      add_trace(x = ~data$R_Score, type = "histogram", name = "Recency",
                marker = list(color = "#e74c3c"), opacity = 0.7) %>%
      add_trace(x = ~data$F_Score, type = "histogram", name = "Frequency",
                marker = list(color = "#3498db"), opacity = 0.7) %>%
      add_trace(x = ~data$M_Score, type = "histogram", name = "Monetary",
                marker = list(color = "#2ecc71"), opacity = 0.7) %>%
      layout(
        barmode = "overlay",
        xaxis = list(title = "RFM Score"),
        yaxis = list(title = "Count")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$segment_revenue_pie <- renderPlotly({
    data <- filtered_customers() %>%
      group_by(Segment) %>%
      summarize(Revenue = sum(TotalSpent), .groups = "drop")
    
    plot_ly(data, labels = ~Segment, values = ~Revenue, type = "pie",
            textposition = "inside",
            textinfo = "label+percent",
            marker = list(colors = c("#e74c3c", "#f39c12", "#3498db", "#2ecc71", "#9b59b6"))) %>%
      config(displayModeBar = FALSE)
  })
  
  output$clv_by_segment <- renderPlotly({
    data <- filtered_customers()
    
    plot_ly(data, x = ~Segment, y = ~TotalSpent, type = "box",
            marker = list(color = "#3498db"),
            boxmean = TRUE) %>%
      layout(
        xaxis = list(title = "Segment"),
        yaxis = list(
          title = "Customer Lifetime Value (£)",
          type = "log"  # THIS IS THE KEY FIX - log scale
        )
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ==========================================================================
  # TAB 3: CHURN ANALYSIS
  # ==========================================================================
  
  output$high_risk_customers <- renderValueBox({
    high_risk <- filtered_churn() %>%
      filter(Risk_Category %in% c("High Risk", "Critical Risk")) %>%
      nrow()
    
    valueBox(
      value = format(high_risk, big.mark = ","),
      subtitle = "High Risk Customers",
      icon = icon("exclamation-triangle"),
      color = "red"
    )
  })
  
  output$revenue_at_risk <- renderValueBox({
    revenue_risk <- filtered_churn() %>%
      filter(Risk_Category %in% c("High Risk", "Critical Risk")) %>%
      summarize(Total = sum(Hist_TotalSpent, na.rm = TRUE)) %>%
      pull(Total)
    
    valueBox(
      value = paste0("£", format(round(revenue_risk/1000, 1), big.mark = ","), "K"),
      subtitle = "Revenue at Risk",
      icon = icon("pound-sign"),
      color = "red"
    )
  })
  
  output$avg_churn_probability <- renderValueBox({
    avg_prob <- mean(filtered_churn()$Churn_Probability, na.rm = TRUE) * 100
    
    valueBox(
      value = paste0(round(avg_prob, 1), "%"),
      subtitle = "Avg Churn Probability",
      icon = icon("chart-line"),
      color = "orange"
    )
  })
  
  output$churn_risk_dist <- renderPlotly({
    data <- filtered_churn()
    
    plot_ly(data, x = ~Churn_Probability, type = "histogram",
            marker = list(color = "#e74c3c"),
            nbinsx = 30) %>%
      layout(
        xaxis = list(title = "Churn Probability", tickformat = ".0%"),
        yaxis = list(title = "Number of Customers")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$risk_category_breakdown <- renderPlotly({
    data <- filtered_churn() %>%
      count(Risk_Category) %>%
      mutate(Risk_Category = factor(Risk_Category, 
                                    levels = c("Low Risk", "Medium Risk", "High Risk", "Critical Risk")))
    
    plot_ly(data, x = ~Risk_Category, y = ~n, type = "bar",
            marker = list(color = c("#2ecc71", "#f39c12", "#e67e22", "#e74c3c"))) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Number of Customers")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$high_risk_table <- renderDT({
    data <- filtered_churn() %>%
      filter(Risk_Category %in% c("High Risk", "Critical Risk")) %>%
      arrange(desc(Churn_Probability)) %>%
      head(20) %>%
      select(CustomerID, Risk_Category, Churn_Probability, 
             Hist_RecencyDays, Hist_TotalTransactions, Hist_TotalSpent)
    
    datatable(
      data,
      options = list(
        pageLength = 10,
        dom = "tp",
        ordering = TRUE
      ),
      rownames = FALSE
    ) %>%
      formatPercentage("Churn_Probability", 1) %>%
      formatCurrency("Hist_TotalSpent", "£") %>%
      formatRound(c("Hist_RecencyDays", "Hist_TotalTransactions"), 0)
  })
  
  # ==========================================================================
  # TAB 4: PRODUCT PERFORMANCE
  # ==========================================================================
  
  output$total_products <- renderValueBox({
    products <- n_distinct(filtered_transactions()$StockCode)
    
    valueBox(
      value = format(products, big.mark = ","),
      subtitle = "Total Products",
      icon = icon("box"),
      color = "green"
    )
  })
  
  output$avg_product_revenue <- renderValueBox({
    avg_rev <- filtered_transactions() %>%
      group_by(StockCode) %>%
      summarize(Revenue = sum(Revenue), .groups = "drop") %>%
      summarize(Avg = mean(Revenue)) %>%
      pull(Avg)
    
    valueBox(
      value = paste0("£", format(round(avg_rev, 0), big.mark = ",")),
      subtitle = "Avg Product Revenue",
      icon = icon("chart-bar"),
      color = "teal"
    )
  })
  
  output$top_product_revenue <- renderValueBox({
    top_rev <- filtered_transactions() %>%
      group_by(StockCode) %>%
      summarize(Revenue = sum(Revenue), .groups = "drop") %>%
      arrange(desc(Revenue)) %>%
      head(1) %>%
      pull(Revenue)
    
    valueBox(
      value = paste0("£", format(round(top_rev/1000, 1), big.mark = ","), "K"),
      subtitle = "Top Product Revenue",
      icon = icon("star"),
      color = "yellow"
    )
  })
  
  output$total_units_sold <- renderValueBox({
    units <- sum(filtered_transactions()$Quantity, na.rm = TRUE)
    
    valueBox(
      value = format(round(units, 0), big.mark = ","),
      subtitle = "Total Units Sold",
      icon = icon("cubes"),
      color = "blue"
    )
  })
  
  output$top_products_revenue <- renderPlotly({
    data <- filtered_transactions() %>%
      group_by(Description) %>%
      summarize(Revenue = sum(Revenue), Units = sum(Quantity), .groups = "drop") %>%
      arrange(desc(Revenue)) %>%
      head(20) %>%
      mutate(Description = str_trunc(Description, 40))
    
    plot_ly(data, x = ~Revenue, y = ~reorder(Description, Revenue),
            type = "bar", orientation = "h",
            marker = list(color = "#2ecc71"),
            text = ~paste0("£", format(round(Revenue, 0), big.mark = ",")),
            textposition = "outside") %>%
      layout(
        xaxis = list(title = "Revenue (£)"),
        yaxis = list(title = ""),
        margin = list(l = 200, r = 100)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$product_table <- renderDT({
    data <- filtered_transactions() %>%
      group_by(StockCode, Description) %>%
      summarize(
        Revenue = sum(Revenue),
        `Units Sold` = sum(Quantity),
        `Avg Price` = mean(UnitPrice),
        Orders = n_distinct(InvoiceNo),
        .groups = "drop"
      ) %>%
      arrange(desc(Revenue)) %>%
      head(50)
    
    datatable(
      data,
      options = list(
        pageLength = 15,
        scrollX = TRUE,
        ordering = TRUE
      ),
      rownames = FALSE,
      filter = "top"
    ) %>%
      formatCurrency(c("Revenue", "Avg Price"), "£") %>%
      formatRound("Units Sold", 0)
  })
  
  # ==========================================================================
  # TAB 5: COHORT ANALYSIS
  # ==========================================================================
  
  output$cohort_heatmap <- renderPlotly({
    # Calculate cohorts from filtered data
    cohort_data <- filtered_transactions() %>%
      group_by(CustomerID) %>%
      mutate(CohortMonth = floor_date(min(InvoiceDate), "month")) %>%
      ungroup() %>%
      mutate(
        OrderMonth = floor_date(InvoiceDate, "month"),
        MonthNumber = interval(CohortMonth, OrderMonth) %/% months(1)
      ) %>%
      group_by(CohortMonth, MonthNumber) %>%
      summarize(Customers = n_distinct(CustomerID), .groups = "drop") %>%
      group_by(CohortMonth) %>%
      mutate(
        CohortSize = Customers[MonthNumber == 0],
        Retention = Customers / CohortSize
      ) %>%
      ungroup()
    
    # Create matrix for heatmap
    cohort_matrix <- cohort_data %>%
      select(CohortMonth, MonthNumber, Retention) %>%
      pivot_wider(names_from = MonthNumber, values_from = Retention, values_fill = NA)
    
    plot_ly(
      x = colnames(cohort_matrix)[-1],
      y = format(cohort_matrix$CohortMonth, "%Y-%m"),
      z = as.matrix(cohort_matrix[, -1]),
      type = "heatmap",
      colorscale = list(c(0, "#fee5d9"), c(0.5, "#fc9272"), c(1, "#de2d26")),
      text = ~paste0(round(as.matrix(cohort_matrix[, -1]) * 100, 0), "%"),
      hovertemplate = "Cohort: %{y}<br>Month: %{x}<br>Retention: %{text}<extra></extra>"
    ) %>%
      layout(
        xaxis = list(title = "Months Since First Purchase"),
        yaxis = list(title = "Cohort Month")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$retention_line <- renderPlotly({
    cohort_data <- filtered_transactions() %>%
      group_by(CustomerID) %>%
      mutate(CohortMonth = floor_date(min(InvoiceDate), "month")) %>%
      ungroup() %>%
      mutate(
        OrderMonth = floor_date(InvoiceDate, "month"),
        MonthNumber = interval(CohortMonth, OrderMonth) %/% months(1)
      ) %>%
      group_by(CohortMonth, MonthNumber) %>%
      summarize(Customers = n_distinct(CustomerID), .groups = "drop") %>%
      group_by(CohortMonth) %>%
      mutate(
        CohortSize = Customers[MonthNumber == 0],
        Retention = Customers / CohortSize
      ) %>%
      ungroup()
    
    # Average retention by month
    avg_retention <- cohort_data %>%
      group_by(MonthNumber) %>%
      summarize(AvgRetention = mean(Retention, na.rm = TRUE), .groups = "drop")
    
    plot_ly(avg_retention, x = ~MonthNumber, y = ~AvgRetention,
            type = "scatter", mode = "lines+markers",
            line = list(color = "#f39c12", width = 3),
            marker = list(size = 8, color = "#f39c12")) %>%
      layout(
        xaxis = list(title = "Months Since First Purchase"),
        yaxis = list(title = "Retention Rate", tickformat = ".0%"),
        hovermode = "x unified"
      ) %>%
      config(displayModeBar = FALSE)
  })
}

# ============================================================================
# RUN APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)
