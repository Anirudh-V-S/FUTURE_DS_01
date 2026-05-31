let
    // Load pre-processed sales CSV
    Source = Csv.Document(File.Contents("D:\Future_Intern\Task-1\data\processed\cleaned_superstore.csv"),[Delimiter=",", Columns=21, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // Select product catalog columns
    KeepProductFields = Table.SelectColumns(PromoteHeaders,{"product_id", "category", "sub_category", "product_name"}),
    
    // Deduplicate on primary Product ID key to build clean catalog dimension
    DeduplicateProducts = Table.Distinct(KeepProductFields, {"product_id"}),
    
    // Clean string formats
    CleanProductText = Table.TransformColumnTypes(DeduplicateProducts,{
        {"product_id", type text}, 
        {"category", type text}, 
        {"sub_category", type text}, 
        {"product_name", type text}
    })
in
    CleanProductText
