
#
# Helper Functions
#

function readdata(filepath::AbstractString, sheet::Union{AbstractString, Int}, ref)
    xf = openxlsx(filepath, enable_cache=false)
    c = getdata(getsheet(xf, sheet), ref )
    close(xf)
    return c
end

function readdata(filepath::AbstractString, sheetref::AbstractString)
    xf = openxlsx(filepath, enable_cache=false)
    c = getdata(xf, sheetref)
    close(xf)
    return c
end

"""
    readtable(filepath, sheet, [columns]; [first_row], [column_labels], [header], [infer_eltypes], [stop_in_empty_row], [stop_in_row_function]) -> data, column_labels

Returns tabular data from a spreadsheet as a tuple `(data, column_labels)`.
`data` is a vector of columns. `column_labels` is a vector of symbols.
Use this function to create a `DataFrame` from package `DataFrames.jl`.

Use `columns` argument to specify which columns to get.
For example, `columns="B:D"` will select columns `B`, `C` and `D`.
If `columns` is not given, the algorithm will find the first sequence
of consecutive non-empty cells.

Use `first_row` to indicate the first row from the table.
`first_row=5` will look for a table starting at sheet row `5`.
If `first_row` is not given, the algorithm will look for the first
non-empty row in the spreadsheet.

`header` is a `Bool` indicating if the first row is a header.
If `header=true` and `column_labels` is not specified, the column labels
for the table will be read from the first row of the table.
If `header=false` and `column_labels` is not specified, the algorithm
will generate column labels. The default value is `header=true`.

Use `column_labels` as a vector of symbols to specify names for the header of the table.

Use `infer_eltypes=true` to get `data` as a `Vector{Any}` of typed vectors.
The default value is `infer_eltypes=false`.

`stop_in_empty_row` is a boolean indicating wether an empty row marks the end of the table.
If `stop_in_empty_row=false`, the `TableRowIterator` will continue to fetch rows until there's no more rows in the Worksheet.
The default behavior is `stop_in_empty_row=true`.

`stop_in_row_function` is a Function that receives a `TableRow` and returns a `Bool` indicating if the end of the table was reached.

Example for `stop_in_row_function`:

```
function stop_function(r)
    v = r[:col_label]
    return !Missings.ismissing(v) && v == "unwanted value"
end
```

Rows where all column values are equal to `Missing.missing` are dropped.

Example code for `readtable`:

```julia
julia> using DataFrames, XLSX

julia> df = DataFrame(XLSX.readtable("myfile.xlsx", "mysheet")...)

See also: `gettable`.
```
"""
function readtable(filepath::AbstractString, sheet::Union{AbstractString, Int}; first_row::Int = 1, column_labels::Vector{Symbol}=Vector{Symbol}(), header::Bool=true, infer_eltypes::Bool=false, stop_in_empty_row::Bool=true, stop_in_row_function::Union{Function, Void}=nothing, enable_cache::Bool=false)
    xf = openxlsx(filepath, enable_cache=enable_cache)
    c = gettable(getsheet(xf, sheet); first_row=first_row, column_labels=column_labels, header=header, infer_eltypes=infer_eltypes, stop_in_empty_row=stop_in_empty_row, stop_in_row_function=stop_in_row_function)
    close(xf)
    return c
end
