let
    // Load pre-processed sales CSV
    Source = Csv.Document(File.Contents("D:\Future_Intern\Task-1\data\processed\cleaned_superstore.csv"),[Delimiter=",", Columns=21, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // Cast structural column types
    TypeCast = Table.TransformColumnTypes(PromoteHeaders,{
        {"row_id", Int64.Type}, 
        {"order_id", type text}, 
        {"order_date", type date}, 
        {"ship_date", type date}, 
        {"ship_mode", type text}, 
        {"customer_id", type text}, 
        {"customer_name", type text}, 
        {"segment", type text}, 
        {"country", type text}, 
        {"city", type text}, 
        {"state", type text}, 
        {"postal_code", type text}, 
        {"region", type text}, 
        {"product_id", type text}, 
        {"category", type text}, 
        {"sub_category", type text}, 
        {"product_name", type text}, 
        {"sales", type number}, 
        {"quantity", Int64.Type}, 
        {"discount", type number}, 
        {"profit", type number}
    }),
    
    // Rename Zip Code to standard primary Location ID
    RenameLocationKey = Table.RenameColumns(TypeCast,{{"postal_code", "Location_ID"}}),
    
    // Drop descriptive dimensional text columns to preserve Star Schema shape
    DropDimTextColumns = Table.RemoveColumns(RenameLocationKey,{
        "customer_name", 
        "segment", 
        "country", 
        "city", 
        "state", 
        "region", 
        "category", 
        "sub_category", 
        "product_name"
    })
in
    DropDimTextColumns
