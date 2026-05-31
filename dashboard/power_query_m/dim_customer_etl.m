let
    // Load pre-processed sales CSV
    Source = Csv.Document(File.Contents("D:\Future_Intern\Task-1\data\processed\cleaned_superstore.csv"),[Delimiter=",", Columns=21, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // Select customer profile columns
    KeepCustomerFields = Table.SelectColumns(PromoteHeaders,{"customer_id", "customer_name", "segment"}),
    
    // De-duplicate on primary Customer ID key to build clean lookup lookup dimension
    DeduplicateCustomers = Table.Distinct(KeepCustomerFields, {"customer_id"}),
    
    // Clean string formats
    CleanCustomerText = Table.TransformColumnTypes(DeduplicateCustomers,{
        {"customer_id", type text}, 
        {"customer_name", type text}, 
        {"segment", type text}
    })
in
    CleanCustomerText
