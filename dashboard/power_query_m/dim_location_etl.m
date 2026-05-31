let
    // Load pre-processed sales CSV
    Source = Csv.Document(File.Contents("D:\Future_Intern\Task-1\data\processed\cleaned_superstore.csv"),[Delimiter=",", Columns=21, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // Select geographical columns
    KeepLocationFields = Table.SelectColumns(PromoteHeaders,{"postal_code", "city", "state", "region", "country"}),
    
    // Deduplicate on primary Postal Code key to build clean territory dimension
    DeduplicateLocations = Table.Distinct(KeepLocationFields, {"postal_code"}),
    
    // Rename Postal Code key to standard Location ID
    RenameLocationKey = Table.RenameColumns(DeduplicateLocations,{{"postal_code", "Location_ID"}}),
    
    // Clean string formats
    CleanLocationText = Table.TransformColumnTypes(RenameLocationKey,{
        {"Location_ID", type text}, 
        {"city", type text}, 
        {"state", type text}, 
        {"region", type text}, 
        {"country", type text}
    })
in
    CleanLocationText
